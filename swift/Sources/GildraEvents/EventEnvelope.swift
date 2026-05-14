import Foundation

/// Canonical wrapper around every Gildra event. v0.1.0 defines the *shape* —
/// existing event publishers continue to emit ad-hoc payloads on the Redis bus
/// for now; migrating them to this envelope is a separate workstream.
public struct EventEnvelope: Codable, Equatable, Sendable {
    public let eventType: String
    public let schemaVersion: Int
    public let occurredAt: Date
    public let actor: EntityRef?
    public let recipient: EntityRef?
    public let resource: EntityRef?
    public let ui: EventUI?

    public init(
        eventType: String,
        schemaVersion: Int = 1,
        occurredAt: Date = Date(),
        actor: EntityRef? = nil,
        recipient: EntityRef? = nil,
        resource: EntityRef? = nil,
        ui: EventUI? = nil
    ) {
        self.eventType = eventType
        self.schemaVersion = schemaVersion
        self.occurredAt = occurredAt
        self.actor = actor
        self.recipient = recipient
        self.resource = resource
        self.ui = ui
    }

    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case schemaVersion = "schema_version"
        case occurredAt = "occurred_at"
        case actor, recipient, resource, ui
    }
}

/// Reference to a domain entity — type + id, with optional handle for users/places.
public struct EntityRef: Codable, Equatable, Sendable {
    public let type: String
    public let id: String
    public let handle: String?

    public init(type: String, id: String, handle: String? = nil) {
        self.type = type
        self.id = id
        self.handle = handle
    }
}

/// User-facing presentation hints carried alongside the event. Clients should
/// render `title` / `body` verbatim and dispatch on `action` for navigation.
/// `imageURL`, when present, is a square image suitable for an avatar /
/// thumbnail on both the rich push banner (via the Notification Service
/// Extension) and the in-app notification list.
public struct EventUI: Codable, Equatable, Sendable {
    public let title: String
    public let body: String?
    public let imageURL: URL?
    public let action: PushAction

    public init(
        title: String,
        body: String? = nil,
        imageURL: URL? = nil,
        action: PushAction = .openNotifications
    ) {
        self.title = title
        self.body = body
        self.imageURL = imageURL
        self.action = action
    }

    enum CodingKeys: String, CodingKey {
        case title, body, action
        case imageURL = "image_url"
    }
}
