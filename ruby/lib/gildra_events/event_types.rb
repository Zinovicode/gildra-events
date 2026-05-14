# frozen_string_literal: true

module GildraEvents
  # Namespaced verb strings for every Gildra event published on the Redis Streams bus.
  # Source of truth — new event types must be added here AND in the Swift + TypeScript
  # equivalents, then the repo re-tagged.
  module EventTypes
    APPOINTMENT_REQUESTED   = 'appointment.requested'
    APPOINTMENT_CONFIRMED   = 'appointment.confirmed'
    APPOINTMENT_DECLINED    = 'appointment.declined'
    APPOINTMENT_CANCELLED   = 'appointment.cancelled'
    APPOINTMENT_COMPLETED   = 'appointment.completed'

    BOOKING_CONFIRMED       = 'booking.confirmed'

    MESSAGE_CREATED         = 'message.created'

    FOLLOW_CREATED          = 'follow.created'

    POST_REACTION_CREATED   = 'post.reaction.created'
    POST_COMMENT_CREATED    = 'post.comment.created'

    INVITATION_CREATED      = 'invitation.created'
    PLACE_INVITATION_CREATED = 'place_invitation.created'
  end
end
