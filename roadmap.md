# Wiretext Roadmap

## From Apps.pdf (imported 2026-07-12)
- [ ] Sim verification skipped (usage raincheck) — rebuilt ios/web fresh (`npm run build:ios`), regenerated Xcode project, xcodebuild build succeeds, resource-folder wiring in project.yml and BundleSchemeHandler both correct (no obvious static bug found). Blank white screen needs an actual sim launch to diagnose (can't repro headlessly) — still open

## WKWebView shell (reviewed 2026-07-22)
Not a gap — `CLAUDE.md` documents this as intentional ("app has no native API needs"). Unlike Books, this was a deliberate choice, not an oversight. Revisit only if wiretext ever needs a real native API. If it's ever ported anyway: no real blockers (grid/undo logic and 23 presets are plain data, map cleanly to SwiftUI) — could also resolve the still-open blank-white-screen sim bug above as a side effect.

## From App Store.pdf (imported 2026-07-28)
- [x] Create an app icon for Wiretext (ASC 6794988951) — DONE 2026-07-28: viewfinder-bracket + placed-component motif in clrs.cc teal (#39CCCC) on #111111, unclaimed color (talli/echo already own blue #0074D9). Wired via `App/Assets.xcassets/AppIcon.appiconset`, `ASSETCATALOG_COMPILER_APPICON_NAME` added to project.yml, xcodebuild verified passing. Not yet uploaded to ASC — lands with the next build.
- [ ] Ship a macOS version of Wiretext.
