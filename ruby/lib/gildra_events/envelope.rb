# frozen_string_literal: true

require 'time'
require 'json'

module GildraEvents
  # Reference to a domain entity — type + id, with optional handle for users/places.
  EntityRef = Struct.new(:type, :id, :handle, keyword_init: true) do
    def to_h
      h = { 'type' => type, 'id' => id }
      h['handle'] = handle if handle
      h
    end

    def self.from_hash(h)
      return nil if h.nil?
      h = h.transform_keys(&:to_s) if h.is_a?(Hash)
      new(type: h['type'], id: h['id'], handle: h['handle'])
    end
  end

  # User-facing presentation hints carried alongside the event. Clients should
  # render `title` / `body` verbatim and dispatch on `action` for navigation.
  # `image_url`, when present, is a square image suitable for an avatar /
  # thumbnail on both the rich push banner and the in-app notification list.
  class EventUI
    attr_reader :title, :body, :image_url, :action

    def initialize(title:, body: nil, image_url: nil, action: PushAction.open_notifications)
      @title = title
      @body = body
      @image_url = image_url
      @action = action
    end

    def to_h
      h = { 'title' => title, 'body' => body, 'action' => action.to_h }
      h['image_url'] = image_url if image_url
      h
    end

    def self.from_hash(h)
      return nil if h.nil?
      h = h.transform_keys(&:to_s) if h.is_a?(Hash)
      new(
        title: h['title'],
        body: h['body'],
        image_url: h['image_url'],
        action: PushAction.from_hash(h['action'])
      )
    end
  end

  # Canonical wrapper around every Gildra event.
  class Envelope
    attr_reader :event_type, :schema_version, :occurred_at, :actor, :recipient, :resource, :data, :ui

    def initialize(event_type:, schema_version: 1, occurred_at: Time.now.utc,
                   actor: nil, recipient: nil, resource: nil, data: {}, ui: nil)
      @event_type = event_type
      @schema_version = schema_version
      @occurred_at = occurred_at
      @actor = actor
      @recipient = recipient
      @resource = resource
      @data = data
      @ui = ui
    end

    def to_h
      {
        'event_type' => event_type,
        'schema_version' => schema_version,
        'occurred_at' => occurred_at.iso8601,
        'actor' => actor&.to_h,
        'recipient' => recipient&.to_h,
        'resource' => resource&.to_h,
        'data' => data,
        'ui' => ui&.to_h
      }.compact
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    # Build an Envelope from the raw field hash of a Redis Streams entry.
    # Strict: requires the `envelope` field to be present with a JSON-encoded
    # envelope payload. Raises ArgumentError otherwise. Symbol keys are used on
    # the returned `data` hash so handler code can call `data[:foo]`.
    def self.from_redis_fields(fields)
      f = fields.transform_keys(&:to_s)
      envelope_json = f['envelope']
      raise ArgumentError, "Missing 'envelope' field in Redis Streams entry: #{f.keys.inspect}" if envelope_json.nil?

      parsed = JSON.parse(envelope_json)
      new(
        event_type: parsed['event_type'],
        schema_version: parsed['schema_version'] || 1,
        occurred_at: parse_time(parsed['occurred_at']) || Time.now.utc,
        actor:     EntityRef.from_hash(parsed['actor']),
        recipient: EntityRef.from_hash(parsed['recipient']),
        resource:  EntityRef.from_hash(parsed['resource']),
        data:      symbolize_keys_deep(parsed['data'] || {}),
        ui:        EventUI.from_hash(parsed['ui'])
      )
    end

    # Serialize and publish this envelope to a Redis Stream. The wire format is
    # `{event: <event_type>, envelope: <full json>}` — `event` is kept as a
    # top-level field for easy `redis-cli xrange` filtering and ops debugging;
    # consumers parse the full envelope JSON.
    def publish_to(stream_key, redis:, maxlen: 100_000, approximate: true)
      redis.xadd(
        stream_key,
        {
          event: event_type,
          envelope: to_json
        },
        maxlen: maxlen,
        approximate: approximate
      )
    end

    class << self
      private

      def parse_time(value)
        return nil if value.nil? || value.to_s.empty?
        Time.parse(value.to_s)
      rescue ArgumentError
        nil
      end

      def symbolize_keys_deep(value)
        case value
        when Hash
          value.each_with_object({}) { |(k, v), h| h[k.to_sym] = symbolize_keys_deep(v) }
        when Array
          value.map { |v| symbolize_keys_deep(v) }
        else
          value
        end
      end
    end
  end
end
