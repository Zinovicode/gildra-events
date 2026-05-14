# Contributing

This repo carries three parallel language packages — Swift (SPM), Ruby (gem), TypeScript (npm) — describing the same event envelope shape and the same `PushAction` discriminated union. They are hand-maintained: every change touches **all three** plus a version bump and tag.

## Adding a field, a `PushAction` kind, or an event type

1. **Edit all three language packages.** A new field on `EventUI` means editing:
   - `swift/Sources/GildraEvents/EventEnvelope.swift`
   - `ruby/lib/gildra_events/envelope.rb`
   - `typescript/src/envelope.ts`
   A new `PushAction.kind` means editing `PushAction.swift`, `push_action.rb`, and `push-action.ts`. A new event type means editing `EventType.swift`, `event_types.rb`, and `event-types.ts`. The README has a kinds table — update it too.
2. **Bump the version** in three places — keep them in sync:
   - `Package.swift` (no version field, but the tag is the version SPM uses)
   - `ruby/lib/gildra_events/version.rb`
   - `package.json`
3. **Open a PR.** CI will build Swift, exercise the Ruby gem, and `tsc` the TypeScript. All three must pass.
4. **After merge, tag and push.**
   ```bash
   git checkout main && git pull
   git tag v0.X.0
   git push origin v0.X.0
   ```
   Then create a release: `gh release create v0.X.0 --generate-notes`.
5. **Bump consumers.** Pinned versions live in:
   - `iosapp/project.yml` — `GildraEvents` package `from:` field
   - `Notifications/Gemfile` — `tag:` value
   - `FrontEnd/zinovi-frontend/package.json` (when wired) — `gildra-events` version
   Bump each, run their builds locally, open PRs.

## Versioning

Pre-1.0 we treat **minor** bumps as breaking-or-additive — any field or kind change. **Patch** bumps are docs/tooling only. After 1.0 we'll switch to strict SemVer.

## What does NOT belong here

- Runtime logic — this package is types and constants only.
- Service-specific code — handlers, publishers, FCM serialization, etc. live in their respective repos and consume gildra-events.
- Codegen — the three language packages are hand-maintained on purpose. Revisit if the maintenance load gets painful.
