# AutoBrew

A native macOS menu bar app that automatically keeps Homebrew and all installed packages up to date — silently, in the background.

## Features

- **Automatic Updates** — Runs `brew update && brew upgrade && brew cleanup` once daily
- **Idle-Based Trigger** — Waits for configurable idle time before running (default: 30 min)
- **Scheduled Trigger** — Alternatively, run at a fixed time of day
- **Works While Locked** — Uses IOKit idle detection, independent of screen lock state
- **Missed Run Recovery** — If the Mac was asleep during a scheduled run, prompts the user on wake
- **Homebrew Auto-Install** — Installs Homebrew automatically if not present
- **Login Item** — Starts automatically with the system via SMAppService
- **Zero Dependencies** — Built entirely with Apple frameworks (SwiftUI, IOKit, UserNotifications, ServiceManagement)

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
        +brewPath: String?
        +isHomebrewInstalled: Bool
        +installHomebrew()
        +runFullUpdate()
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

    class BrewProcess {
        +run(command, brewPath): ProcessResult
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
    MenuBarView --> SchedulerService
    MenuBarView --> BrewManager
    MenuBarView --> SettingsStore
    SettingsView --> SettingsStore
    SettingsView --> LoginItemManager
```

### Application Flow

```mermaid
flowchart TD
    A[App Launch] --> B[AppDelegate.didFinishLaunching]
    B --> C[Request Notification Permission]
    B --> D[Start SchedulerService]
    D --> E{Trigger Mode?}

    E -->|Idle| F[Poll System Idle Time Every 60s]
    E -->|Scheduled| G[Calculate Time Until Next Run]

    F --> H{Idle >= Threshold?}
    H -->|No| F
    H -->|Yes| I{Already Ran Today?}
    I -->|Yes| F
    I -->|No| J[Run Brew Update]

    G --> K[Sleep Until Scheduled Time]
    K --> L{Already Ran Today?}
    L -->|Yes| M[Wait Until Tomorrow]
    L -->|No| J
    M --> G

    J --> N[brew update]
    N --> O[brew upgrade]
    O --> P[brew cleanup]
    P --> Q{Success?}

    Q -->|Yes| R[Save Last Run Date]
    R --> S[Show Success Notification]

    Q -->|No| T[Show Error Notification]

    subgraph Sleep/Wake Recovery
        U[System Sleep] --> V[Record Sleep Time]
        W[System Wake] --> X{Missed Run?}
        X -->|Yes| Y[Show Missed Run Notification]
        Y --> Z{User Action}
        Z -->|Run Now| J
        Z -->|Skip| F
        X -->|No| F
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
├── AutoBrew/
│   ├── Info.plist                       # App metadata (LSUIElement = true)
│   ├── AutoBrew.entitlements            # Sandbox + network
│   ├── Assets.xcassets                  # App icon
│   └── Localizable.xcstrings            # Localization (de/en)
├── Sources/
│   ├── App/
│   │   ├── AutoBrewApp.swift            # @main entry point with MenuBarExtra
│   │   └── AppDelegate.swift            # Lifecycle, activation policy
│   ├── Models/
│   │   ├── TriggerMode.swift            # .idle / .scheduled
│   │   ├── BrewStage.swift              # Update pipeline stages
│   │   ├── BrewError.swift              # Typed errors
│   │   ├── ProcessResult.swift          # Shell command result
│   │   └── SchedulerState.swift         # State machine states
│   ├── Services/
│   │   ├── BrewManager.swift            # Homebrew detection + execution
│   │   ├── BrewProcess.swift            # Process wrapper (async/await)
│   │   ├── SchedulerService.swift       # Central orchestrator
│   │   ├── IdleDetector.swift           # IOKit idle time
│   │   ├── SleepWakeObserver.swift      # NSWorkspace sleep/wake
│   │   ├── LoginItemManager.swift       # SMAppService wrapper
│   │   └── NotificationManager.swift    # UNUserNotificationCenter
│   ├── ViewModels/
│   │   └── SettingsStore.swift          # UserDefaults bridge
│   ├── Views/
│   │   ├── MenuBarView.swift            # Menu bar popover
│   │   └── SettingsView.swift           # Settings panel
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
