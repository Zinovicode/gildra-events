import type { PushAction } from './push-action';

/** Reference to a domain entity — type + id, with optional handle for users/places. */
export interface EntityRef {
  type: string;
  id: string;
  handle?: string;
}

/**
 * User-facing presentation hints carried alongside the event.
 * `image_url`, when present, is a square image suitable for an avatar /
 * thumbnail on the in-app notification list and rich push banner.
 */
export interface EventUI {
  title: string;
  body?: string;
  image_url?: string;
  action: PushAction;
}

/**
 * Canonical wrapper around every Gildra event. v0.1.0 defines the *shape* —
 * existing event publishers continue to emit ad-hoc payloads for now.
 */
export interface EventEnvelope {
  event_type: string;
  schema_version: number;
  occurred_at: string;          // ISO-8601
  actor?: EntityRef;
  recipient?: EntityRef;
  resource?: EntityRef;
  data?: Record<string, unknown>;
  ui?: EventUI;
}
