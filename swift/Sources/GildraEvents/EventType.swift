import Foundation

/// Namespaced verb strings for every Gildra event published on the Redis Streams bus.
/// Treat these as the source of truth; new event types must be added here AND in the
/// Ruby + TypeScript equivalents, then the repo re-tagged.
public enum EventType {
    public static let appointmentRequested  = "appointment.requested"
    public static let appointmentConfirmed  = "appointment.confirmed"
    public static let appointmentDeclined   = "appointment.declined"
    public static let appointmentCancelled  = "appointment.cancelled"
    public static let appointmentCompleted  = "appointment.completed"

    public static let bookingConfirmed      = "booking.confirmed"

    public static let messageCreated        = "message.created"

    public static let followCreated         = "follow.created"

    public static let postReactionCreated   = "post.reaction.created"
    public static let postCommentCreated    = "post.comment.created"

    public static let invitationCreated     = "invitation.created"
    public static let placeInvitationCreated = "place_invitation.created"
}
