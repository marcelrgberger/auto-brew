# AutoBrew

Native macOS 26+ menu bar app. Auto-updates Homebrew packages in the background.

## Quick Reference

- **Bundle ID:** `za.co.digitalfreedom.AutoBrew`
- **Team ID:** `7TSZJCJY88`
- **Distribution:** Direct (GitHub Releases + Sparkle), NOT App Store
- **Repo:** `marcelrgberger/auto-brew` (public, MIT)
- **Tap:** `marcelrgberger/homebrew-tap`

## Tech Stack

- Swift 6.0, strict concurrency, SwiftUI, macOS 26+
- XcodeGen (`project.yml`) — run `xcodegen generate && bash scripts/patch-localizations.sh`
- Sparkle 2.x for auto-updates (only external dependency)
- IOKit for idle detection, ServiceManagement for login items

## Build

```bash
xcodegen generate
bash scripts/patch-localizations.sh
xcodebuild build -scheme AutoBrew -destination 'platform=macOS'
```

## Branches & CI

```
development → test → beta → main
```

- **development:** Local dev, Xcode Cloud Test+Analyze
- **test/beta/main:** GitHub Actions → Build, Sign (Developer ID), Notarize, DMG, Release

Version bump: GitHub Actions UI → "03. Set new Version" → MAJOR/MINOR/PATCH (only on development)

## Release Process

1. Run "03. Set new Version" workflow on development
2. PR development → test → beta → main
3. GitHub Actions builds, signs, notarizes, creates Release with DMG
4. Update Homebrew Cask in `homebrew-tap` repo (SHA256 + version)
5. Sparkle appcast updates automatically in CI

## Signing & Secrets

All secrets in GitHub repo settings. Developer ID cert + API Key reusable across all macOS apps (stored in KeePass).

| Secret | Per-App? |
|---|---|
| `APPLE_TEAM_ID` | No |
| `MACOS_DEVELOPER_ID_CERTIFICATE_BASE64` | No |
| `MACOS_DEVELOPER_ID_CERTIFICATE_PASSWORD` | No |
| `MACOS_GITHUB_KEYCHAIN_PASSWORD` | No |
| `MACOS_APPSTORE_API_KEY_BASE64` | No |
| `MACOS_APPSTORE_API_KEY_ID` | No |
| `MACOS_APPSTORE_API_ISSUER_ID` | No |
| `SPARKLE_PRIVATE_KEY` | Yes |

## Localization

8 languages: en, de, fr, it, nl, pl, pt-BR, es. Managed via `Localizable.xcstrings` + `InfoPlist.strings` per `.lproj`. XcodeGen needs `knownRegions` patching after generate.

## Architecture

- `Sources/App/` — Entry point, AppDelegate
- `Sources/Services/` — BrewManager, SchedulerService, IdleDetector, SleepWakeObserver, NotificationManager, LoginItemManager, UpdaterService, BrewProcess
- `Sources/Views/` — MenuBarView, SettingsView, OnboardingView, LogView, MenuBarIcon
- `Sources/ViewModels/` — SettingsStore
- `Sources/Models/` — TriggerMode, BrewStage, BrewError, SchedulerState, ProcessResult, OutdatedPackage

## Key Decisions

- No App Sandbox (needs to execute `/opt/homebrew/bin/brew`)
- BrewProcess executes brew binary directly with argument arrays (no shell interpolation)
- 10-minute timeout per brew command with process termination
- Onboarding on first launch (Launch at Login toggle + Homebrew check)
- Icon generated via CoreGraphics script (`scripts/generate-final-icon.swift`)
