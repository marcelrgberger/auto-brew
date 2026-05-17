# AutoBrew

A native macOS menu bar app that automatically keeps Homebrew and all installed packages up to date — silently, in the background.

## Features

- **Automatic Updates** — Runs `brew update → brew upgrade → brew upgrade --cask --greedy → brew cleanup` once daily
- **Idle-Based Trigger** — Waits for configurable idle time before running (default: 30 min)
- **Scheduled Trigger** — Alternatively, run at a fixed time of day
- **Works While Locked** — Uses IOKit idle detection, independent of screen lock state
- **Missed Run Recovery** — If the Mac was asleep during a scheduled run, prompts the user on wake
- **Outdated Package List** — Shows outdated formulae and casks with current and available versions
- **Homebrew Auto-Install** — Installs Homebrew automatically if not present (guided onboarding)
- **Login Item** — Starts automatically with the system via SMAppService
- **Auto-Updates** — Keeps itself up to date via Sparkle
- **8 Languages** — English, German, French, Italian, Dutch, Polish, Portuguese (Brazil), Spanish

## BrewStore

Starting with version 2.0.0, AutoBrew ships a full Homebrew GUI and an AppSnapshot engine.

### Browse
Full Homebrew cask catalog (`formulae.brew.sh`) with search, Top-100 list based on install statistics, and a direct-install button.

### Installed
List of all third-party apps in the `/Applications` folder with cask-token mapping. Per app: create snapshot, upgrade via Brew, or uninstall.

### Snapshots
Capture complete app state: `Library/Preferences`, `Library/Application Support`, `Library/Containers`, `Library/Saved Application State`, `Library/Group Containers`, `Library/Caches`. Stored under `~/Library/Application Support/AutoBrew/Snapshots/`. Restore with optional app quit.

### Cross-Mac Migration
- **Export a single snapshot** as an `.autobrewsnapshot` file (ZIP bundle with JSON manifest containing SHA-256 component hashes).
- **Bulk export** all snapshots as an `.autobrewbundle` directory with `restore_list.json`.
- **Restore wizard**: open a file or bundle, pick the apps to restore, automatically install missing casks via Homebrew (with search fallback for renamed casks), and replay the data.

### URL Scheme
- `autobrew://open` — open the main window.
- `autobrew://install/<cask-token>` — install a cask in the background (token validated against `[a-zA-Z0-9][a-zA-Z0-9._-]*`).

### Auto-Cleanup
In Settings: automatically remove old snapshots after N days (default 90). Cleanup runs after each successful Brew update.

## Install

### Via Homebrew (recommended)

```bash
brew tap marcelrgberger/tap
brew install --cask autobrew
```

### Manual Download

Download the latest DMG from [GitHub Releases](https://github.com/marcelrgberger/auto-brew/releases), open it, and drag AutoBrew to your Applications folder.

The app is signed and notarized by Apple — no Gatekeeper warnings.

## Requirements

- macOS 26.0+
- Xcode 26+
- Swift 6.0
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Setup

```bash
# Generate Xcode project
xcodegen generate

# Build
xcodebuild build -scheme AutoBrew -destination 'platform=macOS'

# Run tests
xcodebuild test -scheme AutoBrew -destination 'platform=macOS'
```

## Architecture

AutoBrew is structured around three responsibilities — the auto-update engine (menu bar lifecycle, scheduling, Brew execution), the BrewStore browse/install surface (catalog, installed apps, casks), and the AppSnapshot subsystem (capture, restore, cross-Mac migration). Each is shown as its own class diagram below.

### Diagram 1 — App Lifecycle & Auto-Update Engine

```mermaid
classDiagram
    class AutoBrewApp {
        +body: Scene
        -delegate: AppDelegate
    }

    class AppDelegate {
        +applicationDidFinishLaunching()
        +handleOpenURL(URL)
    }

    class SchedulerService {
        -state: SchedulerState
        -pollingTask: Task
        -scheduledTask: Task
        +start()
        +restartScheduling()
        +triggerManualRun()
        -runBrewUpdate()
        -handleMissedRun()
    }

    class BrewManager {
        +brewPath: String?
        +isHomebrewInstalled: Bool
        +installHomebrew()
        +runFullUpdate()
        +fetchOutdated()
    }

    class BrewProcess {
        +run(executable, arguments, brewPath): ProcessResult
    }

    class BrewError
    class OutdatedPackage

    class SettingsStore {
        +triggerMode: TriggerMode
        +idleMinutes: Int
        +scheduledHour: Int
        +scheduledMinute: Int
        +lastRunDate: Date?
        +loginItemEnabled: Bool
        +snapshotRetentionDays: Int
    }

    class IdleDetector {
        +systemIdleTime(): TimeInterval?
    }

    class SleepWakeObserver {
        +onWakeWithMissedRun: Callback
        +startObserving()
        +clearMissedRun()
    }

    class NotificationManager {
        +onRunNowRequested: Callback
        +requestAuthorization()
        +showMissedRunNotification()
        +showCompletionNotification()
    }

    class LoginItemManager {
        +isEnabled: Bool
        +setEnabled(Bool)
    }

    class UpdaterService {
        +canCheckForUpdates: Bool
        +checkForUpdates()
    }

    AutoBrewApp --> AppDelegate
    AutoBrewApp --> MenuBarView
    AppDelegate --> SchedulerService
    AppDelegate --> NotificationManager
    AppDelegate --> BrewInstaller : autobrew://install
    SchedulerService --> BrewManager
    SchedulerService --> SettingsStore
    SchedulerService --> SleepWakeObserver
    SchedulerService --> NotificationManager
    SchedulerService --> IdleDetector
    SchedulerService --> SnapshotService : auto-cleanup
    BrewManager --> BrewProcess
    BrewManager --> OutdatedPackage
    BrewManager ..> BrewError
    MenuBarView --> SchedulerService
    MenuBarView --> BrewManager
    MenuBarView --> SettingsStore
    MenuBarView --> MenuBarIcon
    MenuBarView --> LogView
    MenuBarView --> OnboardingView
    MenuBarView --> BrewStoreWindow
    SettingsView --> SettingsStore
    SettingsView --> LoginItemManager
    SettingsView --> UpdaterService
```

### Diagram 2 — BrewStore: Browse, Install, Manage

```mermaid
classDiagram
    class BrewStoreWindow {
        +body: View
    }
    class BrewStoreSidebar
    class DiscoverView
    class DiscoverSection
    class RankedCaskRow
    class CategoryListView
    class UpdatesView
    class BrowseDetailView
    class CaskIconView
    class InstalledAppsView
    class InstalledAppRowView

    class CatalogStore {
        +casks: [CaskCatalogEntry]
        +analytics: CaskAnalytics?
        +categories: [BrowseCategory]
        +isLoading: Bool
        +refresh()
        +replaceAll(casks, analytics)
        +topRanked(limit) [CaskCatalogEntry]
    }

    class InstalledAppsStore {
        +apps: [InstalledApp]
        +isLoading: Bool
        +refresh()
    }

    class BrewCatalogService {
        +refresh()
        +loadCache()
    }

    class BrewInstaller {
        +install(token)
        +upgrade(token)
        +uninstall(token, zap)
        +searchCask(query) String?
    }

    class AppDiscoveryService {
        +scan(directories, resolver) [InstalledApp]
        +readApp(at) InstalledApp?
    }

    class CaskNameResolver {
        +token(forAppName) String?
    }

    class RemoteIconLoader {
        +cached(token) NSImage?
        +fetch(token, displayName, homepage) NSImage?
        +diskCacheSize() Int64
        +clearCache()
    }

    class CaskCatalogEntry
    class CaskAnalytics
    class InstalledApp
    class BrowseCategory

    BrewStoreWindow --> BrewStoreSidebar
    BrewStoreWindow --> DiscoverView
    BrewStoreWindow --> CategoryListView
    BrewStoreWindow --> UpdatesView
    BrewStoreWindow --> InstalledAppsView
    DiscoverView --> DiscoverSection
    DiscoverSection --> RankedCaskRow
    RankedCaskRow --> CaskIconView
    CategoryListView --> RankedCaskRow
    RankedCaskRow --> BrowseDetailView
    BrowseDetailView --> CaskIconView
    InstalledAppsView --> InstalledAppRowView

    DiscoverView --> CatalogStore
    CategoryListView --> CatalogStore
    UpdatesView --> CatalogStore
    UpdatesView --> InstalledAppsStore
    InstalledAppsView --> InstalledAppsStore
    BrowseDetailView --> CatalogStore
    BrowseDetailView --> BrewInstaller
    InstalledAppRowView --> BrewInstaller

    CatalogStore --> BrewCatalogService
    CatalogStore --> CaskCatalogEntry
    CatalogStore --> CaskAnalytics
    CatalogStore --> BrowseCategory
    InstalledAppsStore --> AppDiscoveryService
    InstalledAppsStore --> CaskNameResolver
    InstalledAppsStore --> InstalledApp
    AppDiscoveryService --> CaskNameResolver
    CaskIconView --> RemoteIconLoader
```

### Diagram 3 — AppSnapshot Engine & Cross-Mac Restore

```mermaid
classDiagram
    class SnapshotsRootView
    class SnapshotListView
    class SnapshotDetailView
    class NewSnapshotView
    class RestoreWizardView
    class RestoreProgressView

    class SnapshotsStore {
        +snapshots: [AppSnapshot]
        +refresh()
        +createSnapshot(for app)
        +delete(snapshot)
        +restore(snapshot, terminateApp)
    }

    class RestoreWizardStore {
        +list: RestoreList?
        +imported: [AppSnapshot]
        +selection: Set~UUID~
        +loadBundle(url)
        +performRestore()
    }

    class SnapshotService {
        +createSnapshot(bundleID, displayName, caskToken, sourceAppVersion)
        +listSnapshots() [AppSnapshot]
        +deleteSnapshot(snapshot)
        +cleanup(olderThanDays)
        +restoreSnapshot(snapshot, terminateApp)
        +exportSnapshot(snapshot, destination)
        +importSnapshot(archiveURL) AppSnapshot
        +exportRestoreList(snapshots, directory)
        +importRestoreList(directory)
    }

    class SnapshotPathResolver {
        +candidatePaths() [URL]
        +groupContainerPaths() [URL]
        +existingPaths() [URL]
    }

    class SnapshotArchiver {
        +archive(snapshot, destination)
        +unarchive(archive, destination)
    }

    class AppQuitter {
        +quit(bundleID)
    }

    class Sha256Hasher {
        +hashFile(url) String
        +hashTree(url) String
    }

    class AppSnapshot
    class SnapshotManifest
    class SnapshotComponent
    class RestoreList

    SnapshotsRootView --> SnapshotListView
    SnapshotsRootView --> SnapshotDetailView
    SnapshotsRootView --> NewSnapshotView
    SnapshotsRootView --> RestoreWizardView
    NewSnapshotView --> SnapshotsStore
    SnapshotListView --> SnapshotsStore
    SnapshotDetailView --> SnapshotsStore
    RestoreWizardView --> RestoreWizardStore
    RestoreWizardView --> RestoreProgressView

    SnapshotsStore --> SnapshotService
    RestoreWizardStore --> SnapshotService
    RestoreWizardStore --> BrewInstaller : install missing casks

    SnapshotService --> SnapshotPathResolver
    SnapshotService --> SnapshotArchiver
    SnapshotService --> AppQuitter
    SnapshotService --> Sha256Hasher
    SnapshotService --> AppSnapshot
    SnapshotService --> SnapshotManifest
    SnapshotService --> RestoreList
    SnapshotManifest --> SnapshotComponent
    AppSnapshot --> SnapshotManifest
```

### Application Flow

```mermaid
flowchart TD
    A[App Launch] --> B[AppDelegate.didFinishLaunching]
    B --> C[Request Notification Permission]
    B --> D{Homebrew Installed?}

    D -->|No| E[Show Onboarding]
    E --> F[Install Homebrew]
    F --> G[Start SchedulerService]
    D -->|Yes| G

    G --> H{Trigger Mode?}

    H -->|Idle| I[Poll System Idle Time Every 60s]
    H -->|Scheduled| J[Calculate Time Until Next Run]

    I --> K{Idle >= Threshold?}
    K -->|No| I
    K -->|Yes| L{Already Ran Today?}
    L -->|Yes| I
    L -->|No| M[Run Brew Update]

    J --> N[Sleep Until Scheduled Time]
    N --> O{Already Ran Today?}
    O -->|Yes| P[Wait Until Tomorrow]
    O -->|No| M
    P --> J

    M --> Q[brew update]
    Q --> R[brew upgrade]
    R --> S[brew upgrade --cask --greedy]
    S --> T[brew cleanup --prune=7]
    T --> U{Success?}

    U -->|Yes| V[Save Last Run Date]
    V --> W[Show Success Notification]

    U -->|No| X[Show Error Notification]

    subgraph Sleep/Wake Recovery
        Y[System Sleep] --> Z[Record Sleep Time]
        AA[System Wake] --> AB{Missed Run?}
        AB -->|Yes| AC[Show Missed Run Notification]
        AC --> AD{User Action}
        AD -->|Run Now| M
        AD -->|Skip| I
        AB -->|No| I
    end
```

### State Machine

```mermaid
stateDiagram-v2
    [*] --> Idle: App Start

    Idle --> WaitingForIdle: Trigger Mode = Idle
    Idle --> WaitingForSchedule: Trigger Mode = Scheduled

    WaitingForIdle --> Running: Idle Threshold Reached
    WaitingForSchedule --> Running: Scheduled Time Reached

    WaitingForIdle --> Running: Manual Trigger
    WaitingForSchedule --> Running: Manual Trigger

    Running --> Completed: Success
    Running --> Failed: Error

    Completed --> WaitingForIdle: Next Day (Idle Mode)
    Completed --> WaitingForSchedule: Next Day (Scheduled Mode)

    Failed --> WaitingForIdle: Retry Next Cycle
    Failed --> WaitingForSchedule: Retry Next Cycle
```

## Project Structure

```
auto-brew/
├── project.yml                          # XcodeGen project definition
├── appcast.xml                          # Sparkle update feed
├── AutoBrew/                            # Bundle resources
│   ├── Info.plist                       # LSUIElement = true, autobrew:// URL scheme
│   ├── AutoBrew.entitlements            # No sandbox (direct distribution)
│   ├── Assets.xcassets                  # App icon
│   ├── Localizable.xcstrings            # 8-language string catalog
│   └── {en,de,fr,it,nl,pl,pt-BR,es}.lproj/InfoPlist.strings
├── Sources/
│   ├── App/                             # Entry point
│   │   ├── AutoBrewApp.swift            # @main, MenuBarExtra scene
│   │   └── AppDelegate.swift            # Lifecycle, autobrew:// URL handler
│   ├── Models/                          # Plain value types (Codable, Sendable)
│   │   ├── BrewError.swift, BrewStage.swift, OutdatedPackage.swift,
│   │   ├── ProcessResult.swift, SchedulerState.swift, TriggerMode.swift
│   │   ├── CaskCatalogEntry.swift       # formulae.brew.sh entry
│   │   ├── CaskAnalytics.swift          # 30-day install counts
│   │   ├── InstalledApp.swift           # /Applications scan result
│   │   ├── BrowseCategory.swift         # Discover-section taxonomy
│   │   ├── AppSnapshot.swift, SnapshotComponent.swift, SnapshotManifest.swift
│   │   └── RestoreList.swift            # Cross-Mac bundle index
│   ├── Services/                        # Stateful logic (@MainActor or Sendable)
│   │   ├── BrewProcess.swift, BrewManager.swift, SchedulerService.swift
│   │   ├── IdleDetector.swift, SleepWakeObserver.swift,
│   │   ├── NotificationManager.swift, LoginItemManager.swift, UpdaterService.swift
│   │   ├── BrewCatalogService.swift     # Catalog + analytics download/cache
│   │   ├── BrewInstaller.swift          # install / upgrade / uninstall / search
│   │   ├── AppDiscoveryService.swift    # /Applications scanner
│   │   ├── CaskNameResolver.swift       # App name -> cask token mapping
│   │   ├── SnapshotService.swift        # Create / list / restore / export / import
│   │   ├── SnapshotArchiver.swift       # ZIP bundle + manifest validation
│   │   ├── SnapshotPathResolver.swift   # Per-bundle-id Library paths
│   │   ├── AppQuitter.swift             # Quit before restore
│   │   └── RemoteIconLoader.swift       # Cask icon fetch + on-disk cache
│   ├── ViewModels/                      # @Observable @MainActor stores
│   │   ├── SettingsStore.swift          # UserDefaults bridge
│   │   ├── CatalogStore.swift           # BrewStore browse/discover state
│   │   ├── InstalledAppsStore.swift     # Installed apps + cask matching
│   │   ├── SnapshotsStore.swift         # Snapshot list + operations
│   │   └── RestoreWizardStore.swift     # Cross-Mac restore flow
│   ├── Views/                           # SwiftUI views
│   │   ├── MenuBarView.swift, MenuBarIcon.swift, SettingsView.swift
│   │   ├── LogView.swift, OnboardingView.swift
│   │   ├── BrewStoreWindow.swift        # Root window for BrewStore
│   │   ├── BrewStore/                   # Sidebar + sections
│   │   │   ├── BrewStoreSidebar.swift, DiscoverView.swift, DiscoverSection.swift
│   │   │   ├── RankedCaskRow.swift, CategoryListView.swift, UpdatesView.swift
│   │   ├── Browse/                      # Cask detail
│   │   │   ├── BrowseDetailView.swift, CaskIconView.swift
│   │   ├── Installed/
│   │   │   ├── InstalledAppsView.swift, InstalledAppRowView.swift
│   │   ├── Snapshots/
│   │   │   ├── SnapshotsRootView.swift, SnapshotListView.swift,
│   │   │   ├── SnapshotDetailView.swift, NewSnapshotView.swift
│   │   └── Restore/
│   │       ├── RestoreWizardView.swift, RestoreProgressView.swift
│   └── Utilities/                       # Pure helpers
│       ├── AppLogger.swift              # Unified os.Logger
│       ├── AppleAppFilter.swift         # Drop Apple-bundled apps from discovery
│       ├── Sha256Hasher.swift           # File + length-prefixed tree hashes
│       ├── ByteFormatter.swift          # Human-readable sizes
│       └── NSPanelAsync.swift           # async/await wrapper around NSOpenPanel
└── Tests/                               # XCTest (54 tests)
    ├── Models:   CaskCatalogEntryTests, RestoreListTests, BrowseCategoryTests
    ├── Services: BrewCatalogServiceTests, AppDiscoveryServiceTests,
    │             CaskNameResolverTests, SnapshotServiceTests,
    │             SnapshotArchiverTests, SnapshotPathResolverTests,
    │             BrewManagerTests, IdleDetectorTests
    ├── ViewModels: CatalogStoreTests, SettingsStoreTests
    └── Utilities: AppleAppFilterTests, Sha256HasherTests
```

## Tests

XCTest covers the model layer, services, view-models, and utilities — currently **54 tests** across 15 files:

| Layer | Suites |
|---|---|
| Models | `CaskCatalogEntryTests`, `RestoreListTests`, `BrowseCategoryTests` |
| Services | `BrewCatalogServiceTests`, `AppDiscoveryServiceTests`, `CaskNameResolverTests`, `SnapshotServiceTests`, `SnapshotArchiverTests`, `SnapshotPathResolverTests`, `BrewManagerTests`, `IdleDetectorTests` |
| ViewModels | `CatalogStoreTests`, `SettingsStoreTests` |
| Utilities | `AppleAppFilterTests`, `Sha256HasherTests` |

Run with:

```bash
xcodebuild test -scheme AutoBrew -destination 'platform=macOS'
```

## Security & Data Integrity

The AppSnapshot engine handles arbitrary user data. AutoBrew implements:

- **Path-traversal protection**: snapshot restore validates every path stays inside `$HOME`; archive extraction rejects symlinks and absolute paths; bundle IDs validated against `^[a-zA-Z0-9][a-zA-Z0-9._-]*$`.
- **Hash verification**: every snapshot file has a SHA-256 hash; every directory has a tree hash using length-prefixed binary framing. Mismatch aborts the restore before any data is overwritten.
- **Transactional restore**: two-phase commit — all existing destinations are moved to backups first, then copies happen, then backups are removed. Failure at any step rolls back atomically.
- **TOCTOU protection**: hashes are re-verified after copy.
- **URL-scheme CSRF**: `autobrew://install/<token>` opens an `NSAlert` requiring user confirmation; token regex blocks flag injection (`--cask`, etc.).
- **Process isolation**: `brew` invocations use a lock-protected `Process` wrapper to prevent race conditions; respects parent task cancellation.
- **Schema versioning**: imports reject unsupported schema versions.
- **Saturating arithmetic**: cumulative file sizes use overflow-reporting addition to prevent Int64 wrap.

## Support

If you find AutoBrew useful, consider [sponsoring the project](https://github.com/sponsors/marcelrgberger).

## License

MIT License — see [LICENSE](LICENSE) for details.

Copyright 2026 Marcel R. G. Berger.
