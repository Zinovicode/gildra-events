import Foundation

/// Namespaced verb strings for every Gildra event published on the Redis Streams bus.
/// Source of truth: `LocationsManager/lib/notification_publisher.rb` and
/// `Notifications/app/listener.rb`'s HANDLERS map. Keep these in sync with the
/// Ruby + TypeScript equivalents.
public enum EventType {
    // MARK: appointment
    public static let appointmentRequested  = "appointment.requested"
    public static let appointmentConfirmed  = "appointment.confirmed"
    public static let appointmentDeclined   = "appointment.declined"
    public static let appointmentCancelled  = "appointment.cancelled"
    public static let appointmentCompleted  = "appointment.completed"
    // artist-initiated invite lifecycle (recipient = client)
    public static let appointmentInvited        = "appointment.invited"
    public static let appointmentInviteReminder = "appointment.invite_reminder"
    // client's response to an invite (recipient = artist)
    public static let appointmentInviteAccepted = "appointment.invite_accepted"
    public static let appointmentInviteDeclined = "appointment.invite_declined"
    public static let appointmentInviteViewed   = "appointment.invite_viewed"

    // MARK: booking
    public static let bookingRequested      = "booking.requested"
    public static let bookingConfirmed      = "booking.confirmed"
    public static let bookingDeclined       = "booking.declined"
    public static let bookingCancelled      = "booking.cancelled"
    public static let bookingPaid           = "booking.paid"

    // MARK: comment
    public static let commentReacted        = "comment.reacted"

    // MARK: contract
    public static let contractAccepted      = "contract.accepted"
    public static let contractStarted       = "contract.started"
    public static let contractEnded         = "contract.ended"
    public static let contractRequestCreated  = "contract_request.created"
    public static let contractRequestDeclined = "contract_request.declined"

    // MARK: event (milestone event posts)
    public static let eventCommented        = "event.commented"
    public static let eventReacted          = "event.reacted"

    // MARK: handle
    public static let handleCreated         = "handle.created"
    public static let handleUpdated         = "handle.updated"

    // MARK: invitation
    public static let invitationCreated     = "invitation.created"
    public static let placeInvitationCreated = "place_invitation.created"
    public static let invitationAccepted    = "invitation.accepted"

    // MARK: organization
    public static let organizationCreated   = "organization.created"
    public static let organizationUpdated   = "organization.updated"
    public static let organizationUserAdded = "organization.user_added"
    public static let organizationRequestCreated  = "organization_request.created"
    public static let organizationRequestApproved = "organization_request.approved"

    // MARK: empire (Identity-owned; supersedes organization.created for new empires)
    public static let empireCreated                = "empire.created"
    public static let empireInvitationCreated      = "empire_invitation.created"
    public static let empireInvitationAccepted     = "empire_invitation.accepted"
    public static let empireInvitationDeclined     = "empire_invitation.declined"
    public static let empireMembershipRoleChanged  = "empire_membership.role_changed"

    // MARK: place
    public static let placeCreated          = "place.created"

    // MARK: post
    public static let postCreated           = "post.created"
    public static let postCommented         = "post.commented"
    public static let postReacted           = "post.reacted"

    // MARK: message (chat messages — consumed by Notifications MessageHandler for push)
    public static let messageCreated        = "message.created"

    // MARK: reminder (scheduled-cron-driven email triggers; published by
    // Gildra.Email's cron scripts and consumed by Gildra.Email's listener so
    // only the listener process touches Mailtrap.)
    public static let profileReminderDue       = "profile_reminder.due"
    public static let availabilityReminderDue  = "availability_reminder.due"

    // MARK: user
    public static let userCreated           = "user.created"
    public static let userUpdated           = "user.updated"
    public static let userFollow            = "user.follow"
    public static let userUnfollow          = "user.unfollow"

    // MARK: payment / receipt (Billing payment lifecycle; consumers: Notifications + Email)
    public static let paymentHoldPlaced         = "payment.hold_placed"
    public static let paymentHoldFailed         = "payment.hold_failed"
    public static let paymentCaptureFailed      = "payment.capture_failed"
    public static let paymentBankDebitInitiated = "payment.bank_debit_initiated"
    public static let paymentBankDebitFailed    = "payment.bank_debit_failed"
    public static let paymentCaptureSucceeded   = "payment.capture_succeeded"
}
