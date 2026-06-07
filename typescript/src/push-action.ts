// Discriminated union describing what a client should do when the user taps a
// push notification (or, in the web case, clicks an in-app banner). Encoded as
// a single JSON object with a `kind` discriminator plus kind-specific fields.

export type PushAction =
  | { kind: 'open_appointment'; appointment_id: string }
  | { kind: 'open_chat'; handle: string; conversation_id?: string }
  | { kind: 'open_profile'; handle: string }
  | { kind: 'open_place'; place_id: string }
  | { kind: 'open_notifications' }
  | { kind: 'open_url'; url: string }
  | { kind: 'none' };

export const PushAction = {
  openAppointment: (appointment_id: string): PushAction =>
    ({ kind: 'open_appointment', appointment_id }),
  openChat: (handle: string, conversation_id?: string): PushAction =>
    conversation_id ? { kind: 'open_chat', handle, conversation_id } : { kind: 'open_chat', handle },
  openProfile: (handle: string): PushAction =>
    ({ kind: 'open_profile', handle }),
  openPlace: (place_id: string): PushAction =>
    ({ kind: 'open_place', place_id }),
  openNotifications: (): PushAction =>
    ({ kind: 'open_notifications' }),
  openUrl: (url: string): PushAction =>
    ({ kind: 'open_url', url }),
  none: (): PushAction =>
    ({ kind: 'none' }),
};
