# Wiretext Roadmap

## App Review rejection reason — READ FROM RESOLUTION CENTER 2026-08-12

**Guideline 5.6 — Developer Code of Conduct — Review Suspended.** Not an app-specific
defect. Verbatim: *"the current submission does not meet the required quality standard for
distribution on the App Store... this app is not eligible for resubmission before August
18th, 2026. Replies and resubmissions before this date will not be reviewed."*

Apple's listed next steps before resubmitting: no placeholder/unfinished/unrefined content;
every screen reviewed and tested; stable across **all** supported devices (iPad included if
the app is offered there); and **detailed notes of the improvements made** in the App Review
Information → Notes field. Continued similar submissions are warned as grounds for removal
from the Developer Program.

This hit 4 apps at once on 2026-08-09: curvely, nyc, transcriptly, wiretext.

Source: `asc web review show --app 6794988951 --apple-id trommatic@icloud.com` (needs `asc-login`;
the public API only returns a generic "unresolved issues" wrapper). Submissions frozen
until 2026-08-18 regardless — fix and stage, do not submit.

## ASC state VERIFIED 2026-08-12 (`asc versions list`)

**iOS 1.0 is `REJECTED`** — the section below says WAITING_FOR_REVIEW. Submission
`27425fb8…` came back rejected. Reason is Resolution-Center-only (needs `asc-login`).

Separately, a real defect found 2026-08-12: `ios/Wiretext.entitlements` exists but
`ios/project.yml` never sets `CODE_SIGN_ENTITLEMENTS`, so xcodegen drops it and every build
ships without `application-identifier` (ITMS-90886, TestFlight-ineligible). It *looks*
fixed and is not. Proven fix to copy: `curvely/ios/project.yml`. This target also lacks
`DEVELOPMENT_TEAM`, `CODE_SIGN_STYLE`, and an AppIcon catalog.

Submissions frozen until 2026-08-18 (Guideline 5.6 review) — build and stage only, no
`asc review submit`. Anything below this heading predates this check; trust this block.

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

## Decision 2026-08-04

- [ ] Rename wiretext -> **Charwork** (approved 2026-08-04, deliberately parked - "we can work on it later", not urgent). Reason: current name was copied from the source idea. Charwork says what it is (character-grid canvas). Touches: repo name, Cloudflare Pages project, `wiretext.heyitsmejosh.com` DNS, App Store Connect record, in-app title/manifest. Do as one deliberate pass, not a drive-by. Rejected alternatives: Gridling, Plotline.

## App Store submission freeze — until 2026-08-18
- [ ] **BLOCKED: no App Store submission on any app until 2026-08-18.** Account is under a Guideline 5.6 Developer Code of Conduct review suspension (Curvely, Transcriptly, Wiretext, NYC Survive). Apple warns that continued similar submissions may result in removal from the Apple Developer Program. Full detail: wiki `ship-plan.md` § "Guideline 5.6 suspension (2026-08-10)". TestFlight builds, pushes and web deploys are still fine.
- [ ] Wiretext iOS 1.0 is SUSPENDED under 5.6. The app is 1 Swift file / 72 lines — a pure WKWebView shell. Do not resubmit as-is. Decide: rewrite native, or withdraw and delete the record (6794988951). Recommendation: withdraw.

## Decision 2026-08-10: keep the record, build the app out
Not withdrawing. The App Store record (6794988951) stays; it just goes dormant until the app is
real. Payments/IAP alone will NOT clear Guideline 4.2 — 4.2 is about what the app *does*, and a
paid WebView wrapper is still a wrapper.
- [ ] Before any resubmit, the app needs genuine app-only functionality — something the website cannot do: offline use, share-sheet/extension, widget, local persistence, native input. Today it is 1 Swift file / 72 lines wrapping a web view.
- [ ] Do not resubmit until that exists AND it is past 2026-08-18.

## 2026-08-10 — App Review notes are EMPTY
`asc review details-for-version` shows no App Review notes on Wiretext's version. Apple's 5.6
letter explicitly requires "detailed notes of the improvements made" before resubmission.
- [ ] Write real review notes once the app has genuine functionality. Do not resubmit with an empty notes field — that is part of what the 5.6 letter asks for.

> Resume note (2026-08-11): a `wip: partial work from /work notes ingest` commit holds unfinished, unverified changes for the items above. Review `git show HEAD` before building on it — it was committed mid-flight, not reviewed, and is unpushed.
