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

    # Build an Envelope from the raw field hash of a Redis Streams entry. Handles
    # BOTH the new wire format (with an `envelope` field carrying full JSON) and
    # the legacy `{event, data, timestamp}` format published by un-migrated
    # services. The returned Envelope's `data` field uses symbol keys so existing
    # handler code that calls `data[:foo]` keeps working.
    def self.from_redis_fields(fields)
      f = fields.transform_keys(&:to_s)

      if (envelope_json = f['envelope'])
        parsed = JSON.parse(envelope_json)
        new(
          event_type: parsed['event_type'] || f['event'],
          schema_version: parsed['schema_version'] || 1,
          occurred_at: parse_time(parsed['occurred_at']) || parse_time(f['timestamp']) || Time.now.utc,
          actor:     EntityRef.from_hash(parsed['actor']),
          recipient: EntityRef.from_hash(parsed['recipient']),
          resource:  EntityRef.from_hash(parsed['resource']),
          data:      symbolize_keys_deep(parsed['data'] || {}),
          ui:        EventUI.from_hash(parsed['ui'])
        )
      else
        data_json = f['data']
        data = data_json ? JSON.parse(data_json) : {}
        new(
          event_type: f['event'],
          occurred_at: parse_time(f['timestamp']) || Time.now.utc,
          data: symbolize_keys_deep(data)
        )
      end
    end

    # Serialize and publish this envelope to a Redis Stream. Wire format keeps
    # the legacy `event` and `timestamp` fields (for consumer compatibility) and
    # adds the full envelope JSON under an `envelope` key. Old consumers reading
    # `event` + `data` will ignore the new field and miss the envelope; new
    # consumers prefer `envelope` and ignore `data` when present.
    def publish_to(stream_key, redis:, maxlen: 100_000, approximate: true)
      redis.xadd(
        stream_key,
        {
          event: event_type,
          envelope: to_json,
          timestamp: occurred_at.iso8601
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
