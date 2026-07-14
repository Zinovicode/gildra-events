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
  // artist-initiated invite lifecycle (recipient = client)
  AppointmentInvited:         'appointment.invited',
  AppointmentInviteReminder:  'appointment.invite_reminder',
  // client's response to an invite (recipient = artist)
  AppointmentInviteAccepted:  'appointment.invite_accepted',
  AppointmentInviteDeclined:  'appointment.invite_declined',

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
  ContractRequestDeclined: 'contract_request.declined',

  // event (milestone event posts)
  EventCommented:          'event.commented',
  EventReacted:            'event.reacted',

  // handle
  HandleCreated:           'handle.created',
  HandleUpdated:           'handle.updated',

  // invitation
  InvitationCreated:       'invitation.created',
  PlaceInvitationCreated:  'place_invitation.created',
  InvitationAccepted:      'invitation.accepted',

  // organization
  OrganizationCreated:     'organization.created',
  OrganizationUpdated:     'organization.updated',
  OrganizationUserAdded:   'organization.user_added',
  OrganizationRequestCreated:  'organization_request.created',
  OrganizationRequestApproved: 'organization_request.approved',

  // empire (Identity-owned; supersedes organization.created for new empires)
  EmpireCreated:                 'empire.created',
  EmpireInvitationCreated:       'empire_invitation.created',
  EmpireInvitationAccepted:      'empire_invitation.accepted',
  EmpireInvitationDeclined:      'empire_invitation.declined',
  EmpireMembershipRoleChanged:   'empire_membership.role_changed',

  // place
  PlaceCreated:            'place.created',

  // post
  PostCreated:             'post.created',
  PostCommented:           'post.commented',
  PostReacted:             'post.reacted',

  // message (chat messages — consumed by Notifications MessageHandler for push)
  MessageCreated:          'message.created',

  // reminder (scheduled-cron-driven email triggers; published by Gildra.Email
  // cron scripts and consumed by Gildra.Email's listener so only the listener
  // process touches Mailtrap.)
  ProfileReminderDue:        'profile_reminder.due',
  AvailabilityReminderDue:   'availability_reminder.due',

  // user
  UserCreated:             'user.created',
  UserUpdated:             'user.updated',
  UserFollow:              'user.follow',
  UserUnfollow:            'user.unfollow',

  // payment / receipt (Billing payment lifecycle; consumers: Notifications + Email)
  PaymentHoldPlaced:          'payment.hold_placed',
  PaymentHoldFailed:          'payment.hold_failed',
  PaymentCaptureFailed:       'payment.capture_failed',
  PaymentBankDebitInitiated:  'payment.bank_debit_initiated',
  PaymentBankDebitFailed:     'payment.bank_debit_failed',
  ReceiptIssued:              'receipt.issued',
} as const;

export type EventTypeName = typeof EventType[keyof typeof EventType];
