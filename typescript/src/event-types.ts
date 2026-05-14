// Namespaced verb strings for every Gildra event published on the Redis Streams bus.
// Source of truth: LocationsManager/lib/notification_publisher.rb and
// Notifications/app/listener.rb HANDLERS map. Keep in sync with the Swift +
// Ruby equivalents.

export const EventType = {
  // appointment
  AppointmentRequested:    'appointment.requested',
  AppointmentConfirmed:    'appointment.confirmed',
  AppointmentDeclined:     'appointment.declined',
  AppointmentCancelled:    'appointment.cancelled',
  AppointmentCompleted:    'appointment.completed',

  // booking
  BookingRequested:        'booking.requested',
  BookingConfirmed:        'booking.confirmed',
  BookingDeclined:         'booking.declined',
  BookingCancelled:        'booking.cancelled',
  BookingPaid:             'booking.paid',

  // comment
  CommentReacted:          'comment.reacted',

  // contract
  ContractAccepted:        'contract.accepted',
  ContractStarted:         'contract.started',
  ContractEnded:           'contract.ended',
  ContractRequestCreated:  'contract_request.created',

  // event (milestone event posts)
  EventCommented:          'event.commented',
  EventReacted:            'event.reacted',

  // handle
  HandleCreated:           'handle.created',
  HandleUpdated:           'handle.updated',

  // invitation
  InvitationCreated:       'invitation.created',
  PlaceInvitationCreated:  'place_invitation.created',

  // organization
  OrganizationCreated:     'organization.created',
  OrganizationUpdated:     'organization.updated',
  OrganizationUserAdded:   'organization.user_added',
  OrganizationRequestCreated:  'organization_request.created',
  OrganizationRequestApproved: 'organization_request.approved',

  // place
  PlaceCreated:            'place.created',

  // post
  PostCreated:             'post.created',
  PostCommented:           'post.commented',
  PostReacted:             'post.reacted',

  // user
  UserCreated:             'user.created',
  UserUpdated:             'user.updated',
  UserFollow:              'user.follow',
  UserUnfollow:            'user.unfollow',
} as const;

export type EventTypeName = typeof EventType[keyof typeof EventType];
