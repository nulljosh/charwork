# Wiretext Roadmap

## Shipped 2026-08-03 — iOS 1.0 SUBMITTED (WAITING_FOR_REVIEW)

Review submission `27425fb8-9404-42a0-88bf-ec85773ed696`, submitted 2026-08-03T17:25Z, on build `1ed73f24` (uploaded 07-29, VALID). `asc review doctor` went from **34 blocking errors to 0**. What was set this pass, all via CLI:

- Age rating (`asc age-rating edit --all-none`), content rights, copyright, review contact details (demo account flag cleared — app needs no login)
- Description / keywords / support + marketing URL; subtitle + privacy policy URL via new canonical `metadata/` dir (`asc metadata pull/plan/apply`) — this repo had no ASC metadata wiring at all before
- Categories: primary DEVELOPER_TOOLS, secondary GRAPHICS_AND_DESIGN → age rating resolved to 4+
- App Privacy: DATA_NOT_COLLECTED applied + published
- Non-exempt encryption set false on the build, and `ITSAppUsesNonExemptEncryption` added to `ios/App/Info.plist` so future builds never re-trip it
- Screenshots: iPhone 6.5" (1242x2688) + iPad Pro 12.9" (2064x2752), captured on sim via AXe-driven taps building a real wireframe (browser, navbar, card, table, list, button, input, tabs, alert) rather than an empty canvas. `TARGETED_DEVICE_FAMILY "1,2"` means iPad shots are mandatory.
- Free price schedule (was the last hidden gate — `asc review doctor` does NOT check pricing, but `review items add` fails with "App is not eligible" without it)

### Two CLI findings worth reusing on every other app

1. **The "app availability is dashboard-only" dead end is FALSE.** `asc pricing availability create` works — but `asc pricing territories list` defaults to a 50-item page, and the CLI then builds a payload referencing territories it never fetched, failing with a misleading `expects an included resource ... id 'ROU' but no matching resource was included` (it errors on ROU even when you pass only `--territory USA`). Fix: fetch with `--limit 200` (175 territories) and pass all of them:
   `asc pricing availability create --app <ID> --territory "<all 175 ids>" --available true --available-in-new-territories true`
   This should unblock availability on curvely, healstack, nyc, portfolio and anything else stuck on it.
2. **App Privacy publish returns a bare 409** until you `asc web privacy apply --file <declaration.json> --confirm` first; publish alone never works on a fresh app.

- [x] Blank white screen — RESOLVED 2026-08-03, no longer reproduces. Launched on iPhone 11 Pro Max + iPad Pro 13" sims: app renders correctly (tour modal, canvas, palette, inspector), components stamp and undo/redo work. Was likely fixed by the 07-29 `project.yml` resource-wiring pass; nothing left to diagnose.

## Blocked on Joshua
- [ ] **Icon uses teal (#39CCCC viewfinder motif)**, which contradicts the standing "no teal, no purple" rule. Not changed here on purpose: the icon is baked into build `1ed73f24`, which is currently under review — swapping it means a new build and a resubmit. Decide after the review clears whether to redesign.
- [ ] **Orange accent removal** (wiki lists this for wiretext + Talli + Curvely together). The orange is the canvas cursor box, visible in the App Store screenshots. Same reason as above — deferred until the current review resolves, since it needs a rebuild + new screenshots.

## Polish (not blocking)
- [ ] iPad: the canvas stops at 50 rows and leaves a white band across the bottom third of the screen on a 12.9" display — visible in the uploaded iPad screenshot. Canvas should either fill the viewport or the empty area should take the canvas background.

## WKWebView shell (reviewed 2026-07-22)
Not a gap — `CLAUDE.md` documents this as intentional ("app has no native API needs"). Unlike Books, this was a deliberate choice, not an oversight. Revisit only if wiretext ever needs a real native API. If it's ever ported anyway: no real blockers (grid/undo logic and 23 presets are plain data, map cleanly to SwiftUI) — could also resolve the still-open blank-white-screen sim bug above as a side effect.

## From App Store.pdf (imported 2026-07-28)
- [ ] Ship a macOS version of Wiretext.

## From App Store.pdf (imported 2026-07-29)
- [x] RESOLVED 2026-08-02 (false alarm, same pattern as Spinelist): `asc builds icons list` on the only build (uploaded 2026-07-29T04:26, VALID) shows both APP_STORE icon variants rendering the real teal-viewfinder icon (icon commit b45dab3, 2026-07-28 21:56, predates the build). Fetched and viewed both CDN thumbnails directly — no placeholder, matches local `icon_1024.png` (1024x1024, no alpha). Nothing to fix; likely a stale local dashboard view when the item was logged.
