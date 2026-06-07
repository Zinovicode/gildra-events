# frozen_string_literal: true

require 'json'

module GildraEvents
  # Discriminated union describing what a client should do when the user taps a
  # push notification. Serializes to a single JSON object with a `kind`
  # discriminator plus kind-specific fields. Stored as a JSON *string* inside
  # the FCM `data.action` payload because FCM `data` is `Map<String, String>`.
  class PushAction
    KIND_OPEN_APPOINTMENT   = 'open_appointment'
    KIND_OPEN_CHAT          = 'open_chat'
    KIND_OPEN_PROFILE       = 'open_profile'
    KIND_OPEN_PLACE         = 'open_place'
    KIND_OPEN_NOTIFICATIONS = 'open_notifications'
    KIND_OPEN_URL           = 'open_url'
    KIND_NONE               = 'none'

    attr_reader :kind, :params

    def initialize(kind, params = {})
      @kind = kind
      @params = params
    end

    def self.open_appointment(appointment_id)
      new(KIND_OPEN_APPOINTMENT, appointment_id: appointment_id)
    end

    def self.open_chat(handle, conversation_id = nil)
      params = { handle: handle }
      params[:conversation_id] = conversation_id if conversation_id
      new(KIND_OPEN_CHAT, params)
    end

    def self.open_profile(handle)
      new(KIND_OPEN_PROFILE, handle: handle)
    end

    def self.open_place(place_id)
      new(KIND_OPEN_PLACE, place_id: place_id)
    end

    def self.open_notifications
      new(KIND_OPEN_NOTIFICATIONS)
    end

    def self.open_url(url)
      new(KIND_OPEN_URL, url: url)
    end

    def self.none
      new(KIND_NONE)
    end

    def to_h
      { 'kind' => kind }.merge(params.transform_keys(&:to_s))
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def self.from_hash(h)
      return open_notifications if h.nil?
      h = h.transform_keys(&:to_s) if h.is_a?(Hash)
      kind = h['kind']
      params = h.reject { |k, _| k == 'kind' }.transform_keys(&:to_sym)
      new(kind, params)
    end
  end
end
