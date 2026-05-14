// Namespaced verb strings for every Gildra event published on the Redis Streams bus.
// Source of truth — new event types must be added here AND in the Swift + Ruby
// equivalents, then the repo re-tagged.

export const EventType = {
  AppointmentRequested:  'appointment.requested',
  AppointmentConfirmed:  'appointment.confirmed',
  AppointmentDeclined:   'appointment.declined',
  AppointmentCancelled:  'appointment.cancelled',
  AppointmentCompleted:  'appointment.completed',

  BookingConfirmed:      'booking.confirmed',

  MessageCreated:        'message.created',

  FollowCreated:         'follow.created',

  PostReactionCreated:   'post.reaction.created',
  PostCommentCreated:    'post.comment.created',

  InvitationCreated:     'invitation.created',
  PlaceInvitationCreated: 'place_invitation.created',
} as const;

export type EventTypeName = typeof EventType[keyof typeof EventType];
