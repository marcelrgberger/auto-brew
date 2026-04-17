# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AutoBrew — native macOS 26+ menu bar app that auto-updates Homebrew packages in the background. Distributed directly via GitHub Releases + Sparkle (NOT App Store).

- **Bundle ID:** `za.co.digitalfreedom.AutoBrew`
- **Team ID:** `7TSZJCJY88`
- **Repo:** `marcelrgberger/auto-brew` (public, MIT)
- **Homebrew Tap:** `marcelrgberger/homebrew-tap`

## Build Commands

```bash
# Generate Xcode project (REQUIRED before building — project.yml is source of truth)
xcodegen generate && bash scripts/patch-localizations.sh

# Build
xcodebuild build -scheme AutoBrew -destination 'platform=macOS'

# Run tests
xcodebuild test -scheme AutoBrew -destination 'platform=macOS'
```

After any change to `project.yml`, re-run the generate + patch command. The patch script fixes XcodeGen's incomplete `knownRegions` propagation from `.xcstrings`.

## Tech Stack

- Swift 6.0 with **strict concurrency** (`SWIFT_STRICT_CONCURRENCY: complete`)
- SwiftUI, macOS 26+ deployment target
- XcodeGen (`project.yml`) — never edit `.xcodeproj` directly
- Sparkle 2.x — the only external dependency (SPM)
- IOKit for system idle detection, ServiceManagement for login items

## Architecture

### Core Update Flow

```
SchedulerService (orchestrator) → BrewManager (executor) → BrewProcess (process runner)
```

1. **SchedulerService** decides *when* to run based on trigger mode (idle polling every 60s or scheduled timer)
2. **BrewManager.runFullUpdate()** executes the 4-stage sequence: update → upgrade → upgrade casks → cleanup
3. **BrewProcess.run()** executes each brew command with a 600-second timeout using `withThrowingTaskGroup` to race process vs timeout

### Concurrency Model

All observable singletons (`BrewManager`, `SchedulerService`, `SettingsStore`, `SleepWakeObserver`) are `@Observable @MainActor`. Views hold them via `@State var x = X.shared`. Background work uses `Task` with cancellation checks. `BrewProcess` uses `@unchecked Sendable` `PipeBuffer` with NSLock for thread-safe output capture across process callbacks.

### Data Flow

- **SettingsStore** — UserDefaults-backed computed properties, read by SchedulerService (trigger mode, timing, lastRunDate) and views
- **SchedulerService** — state machine (`SchedulerState`: idle → waitingForIdle/waitingForSchedule → running → completed/failed), observed by MenuBarView and MenuBarIcon
- **BrewManager** — exposes `isRunning`, `currentStage`, `lastError`, `outdatedPackages`; stateless executor that doesn't read settings directly

### App Startup

AppDelegate sets `NSApp.setActivationPolicy(.accessory)` (menu-bar only, no dock icon), requests notification permissions, then starts SchedulerService if Homebrew is installed. `AutoBrewApp` uses `MenuBarExtra` with `.window` style.

### Supporting Services

- **SleepWakeObserver** — NSWorkspace notifications, checks for missed runs on wake
- **IdleDetector** — IOKit `HIDIdleTime` property
- **NotificationManager** — UNUserNotificationCenter wrapper
- **LoginItemManager** — SMAppService wrapper
- **UpdaterService** — Sparkle SPUUpdater wrapper

## Branches & CI

```
development → test → beta → main
```

- **development:** Local dev, Xcode Cloud Test+Analyze
- **test/beta/main:** GitHub Actions (`build-and-release.yml`) → Build, Developer ID sign, Notarize, DMG, GitHub Release
- **main only:** Sparkle appcast.xml update + full release; test/beta create pre-releases

Version bump: GitHub Actions UI → "03. Set new Version" workflow → MAJOR/MINOR/PATCH (only on development branch). Updates `project.yml` MARKETING_VERSION and CURRENT_PROJECT_VERSION.

## Release Process

1. Run "03. Set new Version" workflow on development
2. PR development → test → beta → main
3. CI builds, signs, notarizes, creates Release with DMG
4. Update Homebrew Cask in `homebrew-tap` repo (SHA256 + version)
5. Sparkle appcast updates automatically on main

## Localization

8 languages: en, de, fr, it, nl, pl, pt-BR, es. Managed via `Localizable.xcstrings` + `InfoPlist.strings` per `.lproj`. Always run `bash scripts/patch-localizations.sh` after `xcodegen generate`.

## Key Decisions

- **No App Sandbox** — must execute `/opt/homebrew/bin/brew` (also checks `/usr/local/bin` and `which`)
- **No shell interpolation** — BrewProcess passes argument arrays directly to `Process`
- **600-second timeout** per brew command with process termination via task group racing
- **LSUIElement = true** in Info.plist — menu-bar only app, no dock icon
- **Empty entitlements** — no special entitlements needed for current functionality
- **Icon** generated programmatically via `scripts/generate-final-icon.swift` (CoreGraphics)

## Signing & Secrets

All in GitHub repo settings. Developer ID cert + API Key reusable across macOS apps (stored in KeePass). Only `SPARKLE_PRIVATE_KEY` is per-app.

## Tests

Smoke/integration tests in `Tests/` — hosted in the app bundle (`TEST_HOST`). Tests run against real singletons (no mocking framework). IdleDetector tests tolerate nil in CI where IOKit is unavailable.
