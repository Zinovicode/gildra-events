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
    public static let contractRequestCreated = "contract_request.created"

    // MARK: event (milestone event posts)
    public static let eventCommented        = "event.commented"
    public static let eventReacted          = "event.reacted"

    // MARK: handle
    public static let handleCreated         = "handle.created"
    public static let handleUpdated         = "handle.updated"

    // MARK: invitation
    public static let invitationCreated     = "invitation.created"
    public static let placeInvitationCreated = "place_invitation.created"

    // MARK: organization
    public static let organizationCreated   = "organization.created"
    public static let organizationUpdated   = "organization.updated"
    public static let organizationUserAdded = "organization.user_added"
    public static let organizationRequestCreated  = "organization_request.created"
    public static let organizationRequestApproved = "organization_request.approved"

    // MARK: place
    public static let placeCreated          = "place.created"

    // MARK: post
    public static let postCreated           = "post.created"
    public static let postCommented         = "post.commented"
    public static let postReacted           = "post.reacted"

    // MARK: user
    public static let userCreated           = "user.created"
    public static let userUpdated           = "user.updated"
    public static let userFollow            = "user.follow"
    public static let userUnfollow          = "user.unfollow"
}
