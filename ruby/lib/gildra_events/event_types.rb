# frozen_string_literal: true

module GildraEvents
  # Namespaced verb strings for every Gildra event published on the Redis Streams bus.
  # Source of truth: LocationsManager/lib/notification_publisher.rb and
  # Notifications/app/listener.rb HANDLERS map. Keep in sync with the Swift +
  # TypeScript equivalents.
  module EventTypes
    # appointment
    APPOINTMENT_REQUESTED   = 'appointment.requested'
    APPOINTMENT_CONFIRMED   = 'appointment.confirmed'
    APPOINTMENT_DECLINED    = 'appointment.declined'
    APPOINTMENT_CANCELLED   = 'appointment.cancelled'
    APPOINTMENT_COMPLETED   = 'appointment.completed'

    # booking
    BOOKING_REQUESTED       = 'booking.requested'
    BOOKING_CONFIRMED       = 'booking.confirmed'
    BOOKING_DECLINED        = 'booking.declined'
    BOOKING_CANCELLED       = 'booking.cancelled'
    BOOKING_PAID            = 'booking.paid'

    # comment
    COMMENT_REACTED         = 'comment.reacted'

    # contract
    CONTRACT_ACCEPTED       = 'contract.accepted'
    CONTRACT_STARTED        = 'contract.started'
    CONTRACT_ENDED          = 'contract.ended'
    CONTRACT_REQUEST_CREATED  = 'contract_request.created'
    CONTRACT_REQUEST_DECLINED = 'contract_request.declined'

    # event (milestone event posts)
    EVENT_COMMENTED         = 'event.commented'
    EVENT_REACTED           = 'event.reacted'

    # handle
    HANDLE_CREATED          = 'handle.created'
    HANDLE_UPDATED          = 'handle.updated'

    # invitation
    INVITATION_CREATED      = 'invitation.created'
    PLACE_INVITATION_CREATED = 'place_invitation.created'

    # organization
    ORGANIZATION_CREATED    = 'organization.created'
    ORGANIZATION_UPDATED    = 'organization.updated'
    ORGANIZATION_USER_ADDED = 'organization.user_added'
    ORGANIZATION_REQUEST_CREATED  = 'organization_request.created'
    ORGANIZATION_REQUEST_APPROVED = 'organization_request.approved'

    # place
    PLACE_CREATED           = 'place.created'

    # post
    POST_CREATED            = 'post.created'
    POST_COMMENTED          = 'post.commented'
    POST_REACTED            = 'post.reacted'

    # user
    USER_CREATED            = 'user.created'
    USER_UPDATED            = 'user.updated'
    USER_FOLLOW             = 'user.follow'
    USER_UNFOLLOW           = 'user.unfollow'

    ALL = [
      APPOINTMENT_REQUESTED, APPOINTMENT_CONFIRMED, APPOINTMENT_DECLINED,
      APPOINTMENT_CANCELLED, APPOINTMENT_COMPLETED,
      BOOKING_REQUESTED, BOOKING_CONFIRMED, BOOKING_DECLINED,
      BOOKING_CANCELLED, BOOKING_PAID,
      COMMENT_REACTED,
      CONTRACT_ACCEPTED, CONTRACT_STARTED, CONTRACT_ENDED,
      CONTRACT_REQUEST_CREATED, CONTRACT_REQUEST_DECLINED,
      EVENT_COMMENTED, EVENT_REACTED,
      HANDLE_CREATED, HANDLE_UPDATED,
      INVITATION_CREATED, PLACE_INVITATION_CREATED,
      ORGANIZATION_CREATED, ORGANIZATION_UPDATED, ORGANIZATION_USER_ADDED,
      ORGANIZATION_REQUEST_CREATED, ORGANIZATION_REQUEST_APPROVED,
      PLACE_CREATED,
      POST_CREATED, POST_COMMENTED, POST_REACTED,
      USER_CREATED, USER_UPDATED, USER_FOLLOW, USER_UNFOLLOW
    ].freeze
  end
end
