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

## Blocked on Joshua
- [ ] **Icon uses teal (#39CCCC viewfinder motif)**, which contradicts the standing "no teal, no purple" rule. Not changed here on purpose: the icon is baked into build `1ed73f24`, which is currently under review — swapping it means a new build and a resubmit. Decide after the review clears whether to redesign.
- [ ] **Orange accent removal** (wiki lists this for wiretext + Talli + Curvely together). The orange is the canvas cursor box, visible in the App Store screenshots. Same reason as above — deferred until the current review resolves, since it needs a rebuild + new screenshots.

## Polish (not blocking)
- [ ] iPad: the canvas stops at 50 rows and leaves a white band across the bottom third of the screen on a 12.9" display — visible in the uploaded iPad screenshot. Canvas should either fill the viewport or the empty area should take the canvas background.

## WKWebView shell (reviewed 2026-07-22)
Not a gap — `CLAUDE.md` documents this as intentional ("app has no native API needs"). Unlike Books, this was a deliberate choice, not an oversight. Revisit only if wiretext ever needs a real native API. If it's ever ported anyway: no real blockers (grid/undo logic and 23 presets are plain data, map cleanly to SwiftUI) — could also resolve the still-open blank-white-screen sim bug above as a side effect.

## From App Store.pdf (imported 2026-07-28)
- [ ] Ship a macOS version of Wiretext.

## TestFlight signing defect (found 2026-08-03)

- [x] **iOS builds were TestFlight-ineligible (ITMS-90886) — FIXED 2026-08-04.** Added `ios/Wiretext.entitlements` + `CODE_SIGN_ENTITLEMENTS` in `ios/project.yml`, mirroring Uprighty `df346b8`. Verified on a real Release archive: `application-identifier => QMM486NPYC.com.nulljosh.wiretext`. Needs a rebuild + resubmit to reach users — the in-review build still has the defect. The entitlement change also invalidates the provisioning profile; refetch with `asc signing fetch` before the next upload. Original diagnosis below for reference:
  Fix proven on Uprighty 2026-08-03 (commit `df346b8`): add `<Target>.entitlements` with `application-identifier` = `$(AppIdentifierPrefix)$(CFBundleIdentifier)`, wire via `CODE_SIGN_ENTITLEMENTS` in `project.yml`, hand-commit it (xcodegen silently drops keys).
  Verify: `codesign -d --entitlements :- <exported>.app` should show `application-identifier`, `beta-reports-active: true`, `get-task-allow: false`. An entitlement change invalidates the profile — refetch with `asc signing fetch`.

## Ingested 2026-08-04
- [x] Product name decided 2026-08-04: **Charwork** (rejected: Gridling, Plotline). The rename itself is the separate parked item below.
- [x] Font still wrong — root cause: shared `heyitsmejosh.com/tokens.css` defines `--font` as a mono stack, and every `font-family` in this app pointed at it. A previous pass had redefined the local `--font-mono` to sans, which did nothing since nothing used it. Now `--font` is overridden locally to the system sans stack in `src/index.css` `:root` (`--font-mono` aliases it — the canvas is already sans by design, glyphs centered in fixed cells per `Canvas.jsx`). Deployed + verified in the live CSS bundle.

## Decision 2026-08-04

- [ ] Rename wiretext -> **Charwork** (approved 2026-08-04, deliberately parked - "we can work on it later", not urgent). Reason: current name was copied from the source idea. Charwork says what it is (character-grid canvas). Touches: repo name, Cloudflare Pages project, `wiretext.heyitsmejosh.com` DNS, App Store Connect record, in-app title/manifest. Do as one deliberate pass, not a drive-by. Rejected alternatives: Gridling, Plotline.
