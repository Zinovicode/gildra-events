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
  end

  # Canonical wrapper around every Gildra event. v0.1.0 defines the *shape* —
  # existing publishers continue to emit ad-hoc payloads for now.
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
  end
end
