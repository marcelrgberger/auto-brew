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

### Class Diagram

```mermaid
classDiagram
    class AutoBrewApp {
        +body: Scene
        -delegate: AppDelegate
    }

    class AppDelegate {
        +applicationDidFinishLaunching()
    }

    class SchedulerService {
        -state: SchedulerState
        -pollingTask: Task
        -scheduledTask: Task
        +start()
        +restartScheduling()
        +triggerManualRun()
        -startIdlePolling()
        -startScheduledTimer()
        -runBrewUpdate()
        -handleMissedRun()
    }

    class BrewManager {
        -isRunning: Bool
        -currentStage: BrewStage
        -lastOutput: String
        -outdatedPackages: OutdatedPackage[]
        +brewPath: String?
        +isHomebrewInstalled: Bool
        +installHomebrew()
        +runFullUpdate()
        +fetchOutdated()
    }

    class OutdatedPackage {
        +name: String
        +currentVersion: String
        +newVersion: String
        +isCask: Bool
    }

    class SettingsStore {
        +triggerMode: TriggerMode
        +idleMinutes: Int
        +scheduledHour: Int
        +scheduledMinute: Int
        +lastRunDate: Date?
        +loginItemEnabled: Bool
        +showNotifications: Bool
        +didRunToday: Bool
    }

    class IdleDetector {
        +systemIdleTime(): TimeInterval?
    }

    class SleepWakeObserver {
        -lastSleepDate: Date?
        -missedRun: Bool
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

    class BrewProcess {
        +run(executable, arguments, brewPath): ProcessResult
    }

    AutoBrewApp --> AppDelegate
    AutoBrewApp --> MenuBarView
    AppDelegate --> SchedulerService
    AppDelegate --> NotificationManager
    SchedulerService --> BrewManager
    SchedulerService --> SettingsStore
    SchedulerService --> SleepWakeObserver
    SchedulerService --> NotificationManager
    SchedulerService --> IdleDetector
    BrewManager --> BrewProcess
    BrewManager --> OutdatedPackage
    MenuBarView --> SchedulerService
    MenuBarView --> BrewManager
    MenuBarView --> SettingsStore
    MenuBarView --> MenuBarIcon
    MenuBarView --> LogView
    MenuBarView --> OnboardingView
    SettingsView --> SettingsStore
    SettingsView --> LoginItemManager
    SettingsView --> UpdaterService
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
├── AutoBrew/
│   ├── Info.plist                       # App metadata (LSUIElement = true)
│   ├── AutoBrew.entitlements            # Empty (no sandbox)
│   ├── Assets.xcassets                  # App icon
│   └── Localizable.xcstrings            # Localization (8 languages)
├── Sources/
│   ├── App/
│   │   ├── AutoBrewApp.swift            # @main entry point with MenuBarExtra
│   │   └── AppDelegate.swift            # Lifecycle, activation policy
│   ├── Models/
│   │   ├── TriggerMode.swift            # .idle / .scheduled
│   │   ├── BrewStage.swift              # Update pipeline stages
│   │   ├── BrewError.swift              # Typed errors
│   │   ├── ProcessResult.swift          # Shell command result
│   │   ├── SchedulerState.swift         # State machine states
│   │   └── OutdatedPackage.swift        # Outdated formula/cask model
│   ├── Services/
│   │   ├── BrewManager.swift            # Homebrew detection + execution
│   │   ├── BrewProcess.swift            # Process wrapper (async/await, 600s timeout)
│   │   ├── SchedulerService.swift       # Central orchestrator
│   │   ├── IdleDetector.swift           # IOKit idle time
│   │   ├── SleepWakeObserver.swift      # NSWorkspace sleep/wake
│   │   ├── LoginItemManager.swift       # SMAppService wrapper
│   │   ├── NotificationManager.swift    # UNUserNotificationCenter
│   │   └── UpdaterService.swift         # Sparkle SPUUpdater wrapper
│   ├── ViewModels/
│   │   └── SettingsStore.swift          # UserDefaults bridge
│   ├── Views/
│   │   ├── MenuBarView.swift            # Menu bar popover
│   │   ├── MenuBarIcon.swift            # Dynamic menu bar icon with state badge
│   │   ├── SettingsView.swift           # Settings panel
│   │   ├── OnboardingView.swift         # First-launch Homebrew setup wizard
│   │   └── LogView.swift                # Brew command output viewer
│   └── Utilities/
│       └── AppLogger.swift              # Unified os.Logger
└── Tests/
    ├── BrewManagerTests.swift
    ├── IdleDetectorTests.swift
    └── SettingsStoreTests.swift
```

## Support

If you find AutoBrew useful, consider [sponsoring the project](https://github.com/sponsors/marcelrgberger).

## License

MIT License — see [LICENSE](LICENSE) for details.

Copyright 2026 Marcel R. G. Berger.
