# gildra-events

Shared event types and the canonical push-notification action contract used across Gildra services.

This repo carries three sibling language packages — Swift (SPM), Ruby (gem), and TypeScript (npm) — all describing the same envelope shape and the same `PushAction` discriminated union. It is intentionally hand-maintained for now; codegen can be added later if event count grows beyond a handful.

## What's here

- **Envelope** — the canonical wrapper around every Gildra event. Fields: `event_type`, `schema_version`, `occurred_at`, `actor`, `recipient`, `resource`, `data`, `ui`.
- **PushAction** — discriminated union describing what an iOS / web client should do when the user taps a notification (`open_appointment`, `open_chat`, `open_profile`, `open_place`, `open_url`, `open_notifications`, `none`).

For v0.1.0 the scope is deliberately narrow: just the envelope shape and `PushAction`. Existing event handlers in LocationsManager / Notifications continue to publish in their current ad-hoc form. The first real consumer is the iOS push payload — `Notifications/FcmService` serializes a `PushAction` into the FCM `data.action` field, and the iOS app decodes it to deep-link the user.

## Consuming

**Swift / iOS (SPM):**

```swift
// In project.yml or Package.swift
.package(url: "https://github.com/Zinovicode/gildra-events.git", from: "0.1.0")
// Target product: GildraEvents
```

**Ruby (Bundler git source):**

```ruby
# Gemfile
gem 'gildra-events',
    git: 'https://github.com/Zinovicode/gildra-events.git',
    tag: 'v0.1.0'
```

**TypeScript (npm GitHub source):**

```json
{
  "dependencies": {
    "gildra-events": "github:Zinovicode/gildra-events#v0.1.0"
  }
}
```

## The envelope

```json
{
  "event_type": "appointment.requested",
  "schema_version": 1,
  "occurred_at": "2026-05-14T13:42:00Z",
  "actor":     { "type": "User",        "id": "uuid", "handle": "@sarah" },
  "recipient": { "type": "User",        "id": "uuid" },
  "resource":  { "type": "Appointment", "id": "uuid" },
  "data": { "...event-specific..." },
  "ui": {
    "title": "New appointment request",
    "body":  "Sarah requested Color at Sola Studios on Friday at 2pm",
    "action": { "kind": "open_appointment", "appointment_id": "uuid" }
  }
}
```

## Event types

| `event_type` | Group | Notes |
|---|---|---|
| `appointment.requested` | appointment | |
| `appointment.confirmed` | appointment | |
| `appointment.declined` | appointment | |
| `appointment.cancelled` | appointment | |
| `appointment.completed` | appointment | |
| `appointment.reminder` | appointment | Daily reminder sweep from LM (recipient = client); covers cancel cutoff, reschedule cutoff, and the appointment itself — collapsed into one event per appointment per local day |
| `booking.requested` | booking | |
| `booking.confirmed` | booking | |
| `booking.declined` | booking | |
| `booking.cancelled` | booking | |
| `booking.paid` | booking | |
| `comment.reacted` | comment | |
| `contract.accepted` | contract | |
| `contract.started` | contract | |
| `contract.ended` | contract | |
| `contract_request.created` | contract | |
| `contract_request.declined` | contract | |
| `event.commented` | event | Milestone event posts |
| `event.reacted` | event | Milestone event posts |
| `handle.created` | handle | |
| `handle.updated` | handle | |
| `invitation.created` | invitation | |
| `place_invitation.created` | invitation | |
| `invitation.accepted` | invitation | |
| `organization.created` | organization | |
| `organization.updated` | organization | |
| `organization.user_added` | organization | |
| `organization_request.created` | organization | |
| `organization_request.approved` | organization | |
| `empire.created` | empire | Identity-owned; supersedes `organization.created` for new empires |
| `empire_invitation.created` | empire | Identity-owned empire onboarding (see Identity's EmpireEvents publisher) |
| `empire_invitation.accepted` | empire | |
| `empire_invitation.declined` | empire | |
| `empire_membership.role_changed` | empire | |
| `place.created` | place | |
| `post.created` | post | |
| `post.commented` | post | |
| `post.reacted` | post | |
| `message.created` | message | Chat messages — consumed by Notifications MessageHandler for push |
| `profile_reminder.due` | reminder | Scheduled cron-driven email trigger |
| `availability_reminder.due` | reminder | Scheduled cron-driven email trigger |
| `user.created` | user | |
| `user.updated` | user | |
| `user.follow` | user | |
| `user.unfollow` | user | |
| `artist_service.announced` | artist_service | Artist announces a new service or price change to their clients and followers; published per-recipient by LM. Consumers: Notifications (in-app + push) + Email |

## PushAction kinds

| `kind` | Required fields | iOS behavior |
|---|---|---|
| `open_appointment` | `appointment_id` | Switch to My Book tab → push AppointmentDetailView |
| `open_chat` | `handle` | Switch to Messages tab → open conversation |
| `open_profile` | `handle` | Push ProfileView |
| `open_place` | `place_id` | Push PlaceDetailView |
| `open_notifications` | — | Switch to Notifications tab (default fallback) |
| `open_url` | `url` | In-app web view |
| `none` | — | No navigation on tap |

## Adding a new event or action kind

1. Add it to all three language packages (Swift enum, Ruby class, TS union) and the table above.
2. Bump the version in `Package.swift`/`gildra-events.gemspec`/`package.json` and tag the repo (`git tag v0.2.0 && git push --tags`).
3. Update each consumer's pinned version.
