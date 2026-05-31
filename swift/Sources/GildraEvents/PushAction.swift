import Foundation

/// Discriminated union describing what a client should do when the user taps a
/// push notification. Encoded as a single JSON object with a `kind` discriminator
/// plus `kind`-specific fields. Stored as a JSON string in the FCM `data.action`
/// payload so it survives the APNs/FCM `[String: String]` constraint.
public enum PushAction: Equatable, Sendable {
    /// Switch to the artist's My Book tab and push AppointmentDetailView.
    case openAppointment(appointmentId: String)
    /// Switch to the Messages tab and open the conversation with `handle`.
    case openChat(handle: String, conversationId: String?)
    /// Push ProfileView for `handle`.
    case openProfile(handle: String)
    /// Switch to the Notifications tab. Default fallback when no richer action fits.
    case openNotifications
    /// Open an arbitrary URL in an in-app web view.
    case openURL(url: URL)
    /// No navigation on tap.
    case none
}

extension PushAction: Codable {
    private enum Kind: String, Codable {
        case openAppointment = "open_appointment"
        case openChat = "open_chat"
        case openProfile = "open_profile"
        case openNotifications = "open_notifications"
        case openURL = "open_url"
        case none = "none"
    }

    private enum CodingKeys: String, CodingKey {
        case kind
        case appointmentId = "appointment_id"
        case handle
        case conversationId = "conversation_id"
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .openAppointment:
            self = .openAppointment(appointmentId: try container.decode(String.self, forKey: .appointmentId))
        case .openChat:
            self = .openChat(
                handle: try container.decode(String.self, forKey: .handle),
                conversationId: try container.decodeIfPresent(String.self, forKey: .conversationId)
            )
        case .openProfile:
            self = .openProfile(handle: try container.decode(String.self, forKey: .handle))
        case .openNotifications:
            self = .openNotifications
        case .openURL:
            self = .openURL(url: try container.decode(URL.self, forKey: .url))
        case .none:
            self = .none
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .openAppointment(let id):
            try container.encode(Kind.openAppointment, forKey: .kind)
            try container.encode(id, forKey: .appointmentId)
        case .openChat(let handle, let conversationId):
            try container.encode(Kind.openChat, forKey: .kind)
            try container.encode(handle, forKey: .handle)
            try container.encodeIfPresent(conversationId, forKey: .conversationId)
        case .openProfile(let handle):
            try container.encode(Kind.openProfile, forKey: .kind)
            try container.encode(handle, forKey: .handle)
        case .openNotifications:
            try container.encode(Kind.openNotifications, forKey: .kind)
        case .openURL(let url):
            try container.encode(Kind.openURL, forKey: .kind)
            try container.encode(url, forKey: .url)
        case .none:
            try container.encode(Kind.none, forKey: .kind)
        }
    }
}

public extension PushAction {
    /// Decode from the JSON string typically carried in `userInfo["action"]` of a
    /// remote notification. Returns `.openNotifications` (the safe fallback) if the
    /// string is malformed or missing — push taps must always do *something*.
    static func decode(fromJSONString jsonString: String?) -> PushAction {
        guard let jsonString,
              let data = jsonString.data(using: .utf8),
              let action = try? JSONDecoder().decode(PushAction.self, from: data)
        else {
            return .openNotifications
        }
        return action
    }
}
