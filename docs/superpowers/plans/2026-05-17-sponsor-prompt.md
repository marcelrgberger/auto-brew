# Sponsor- & Star-Prompt Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Den Nutzer nach 7 Tagen und nach 90 Tagen seit erstem App-Start in einem Sheet bitten, AutoBrew auf GitHub einen Stern zu geben (`github.com/marcelrgberger/auto-brew`) und/oder per GitHub Sponsors (`github.com/sponsors/marcelrgberger`) zu unterstützen.

**Architecture:** Neuer `SupportPromptStore` (`@Observable @MainActor`, `static let shared`) speichert `installDate`, `dismissedStages` und `userHasSupported` in `UserDefaults`. `AppDelegate` setzt das Install-Datum beim Launch. `MenuBarView` zeigt ein nicht-dismissierbares SwiftUI-Sheet, wenn `pendingStage` ≠ nil ist. Aktionen (Star / Sponsor / Später / Hab ich schon) öffnen Browser via `NSWorkspace.shared.open` und aktualisieren den State.

**Tech Stack:** Swift 6, SwiftUI, XCTest, XcodeGen, `UserDefaults`, `NSWorkspace`. Build via `xcodebuild` gegen `AutoBrew.xcodeproj`.

**Specification:** `docs/superpowers/specs/2026-05-17-sponsor-prompt-design.md`

---

## File Structure

| Aktion | Pfad | Verantwortung |
|---|---|---|
| Create | `Sources/Models/SupportStage.swift` | Enum mit Stufen `.week`, `.quarter` + URL-Konstanten |
| Create | `Sources/ViewModels/SupportPromptStore.swift` | State + Eligibility-Logik + Aktionen |
| Create | `Sources/Views/SupportPromptView.swift` | SwiftUI-Sheet mit Heart-Header + 3 Buttons + Footer-Link |
| Create | `Tests/SupportPromptStoreTests.swift` | XCTest gegen isolierte `UserDefaults`-Suite mit injizierter `now`-Closure |
| Modify | `Sources/App/AppDelegate.swift` | `SupportPromptStore.shared.ensureInstallDate()` im Launch |
| Modify | `Sources/Views/MenuBarView.swift` | `.sheet(isPresented:)` + `.task { checkAndShow() }` im `mainView` |

Jede Datei hat genau eine Verantwortung. Die Trennung `Model → ViewModel → View` matched das bestehende Pattern in `Sources/`.

---

## Task 1: SupportStage Enum

**Files:**
- Create: `Sources/Models/SupportStage.swift`

- [ ] **Step 1: Datei anlegen**

```swift
// Sources/Models/SupportStage.swift
import Foundation

enum SupportStage: String, CaseIterable, Sendable {
    case week
    case quarter

    /// Tage seit Installation, nach denen diese Stage fällig wird.
    var thresholdDays: Int {
        switch self {
        case .week: return 7
        case .quarter: return 90
        }
    }
}

enum SupportLinks {
    static let starURL = URL(string: "https://github.com/marcelrgberger/auto-brew")!
    static let sponsorURL = URL(string: "https://github.com/sponsors/marcelrgberger")!
}
```

- [ ] **Step 2: Build prüfen**

Run: `xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' build -quiet`
Expected: BUILD SUCCEEDED (kein Output bei Erfolg dank `-quiet`; bei Fehler erscheinen Diagnostics).

- [ ] **Step 3: Commit**

```bash
git add Sources/Models/SupportStage.swift
git commit -m "Add SupportStage enum and GitHub URLs"
```

---

## Task 2: SupportPromptStore — Tests zuerst (TDD)

**Files:**
- Create: `Tests/SupportPromptStoreTests.swift`

Diese Tests werden geschrieben, bevor der Store existiert. Sie sollen alle scheitern (Compile-Error: Symbol nicht gefunden).

- [ ] **Step 1: Test-Datei mit allen Tests anlegen**

```swift
// Tests/SupportPromptStoreTests.swift
import XCTest
@testable import AutoBrew

final class SupportPromptStoreTests: XCTestCase {

    // MARK: - Helpers

    private func isolatedDefaults() -> UserDefaults {
        let name = "SupportPromptStoreTests.\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return d
    }

    private func makeStore(
        defaults: UserDefaults,
        nowOffsetDays: Int = 0,
        baseDate: Date = Date(timeIntervalSince1970: 1_700_000_000)
    ) -> SupportPromptStore {
        let now = baseDate.addingTimeInterval(TimeInterval(nowOffsetDays) * 86_400)
        return SupportPromptStore(defaults: defaults, now: { now })
    }

    // MARK: - ensureInstallDate

    @MainActor
    func test_ensureInstallDate_setsDateOnFirstCall() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults)
        XCTAssertNil(store.installDate)

        store.ensureInstallDate()

        XCTAssertNotNil(store.installDate)
    }

    @MainActor
    func test_ensureInstallDate_doesNotOverwrite() {
        let defaults = isolatedDefaults()
        let store1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        store1.ensureInstallDate()
        let firstDate = store1.installDate

        let store2 = makeStore(defaults: defaults, nowOffsetDays: 5)
        store2.ensureInstallDate()

        XCTAssertEqual(store2.installDate, firstDate)
    }

    // MARK: - pendingStage

    @MainActor
    func test_pendingStage_isNilImmediatelyAfterInstall() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults, nowOffsetDays: 0)
        store.ensureInstallDate()

        XCTAssertNil(store.pendingStage)
    }

    @MainActor
    func test_pendingStage_isWeekAfterSevenDays() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 7)

        XCTAssertEqual(later.pendingStage, .week)
    }

    @MainActor
    func test_pendingStage_isQuarterAfterNinetyDays() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()
        installer.dismiss(.week)

        let later = makeStore(defaults: defaults, nowOffsetDays: 90)

        XCTAssertEqual(later.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_prefersQuarterOverWeekWhenBothDue() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 100)

        XCTAssertEqual(later.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_isNilAfterMarkAsSupporter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 200)
        later.markAsSupporter()

        XCTAssertNil(later.pendingStage)
    }

    @MainActor
    func test_pendingStage_isNilAfterDismissingWeek_untilQuarter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let weekTime = makeStore(defaults: defaults, nowOffsetDays: 7)
        weekTime.dismiss(.week)
        XCTAssertNil(weekTime.pendingStage)

        let day89 = makeStore(defaults: defaults, nowOffsetDays: 89)
        XCTAssertNil(day89.pendingStage)

        let day90 = makeStore(defaults: defaults, nowOffsetDays: 90)
        XCTAssertEqual(day90.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_isNilAfterDismissingQuarter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 91)
        later.dismiss(.quarter)

        XCTAssertNil(later.pendingStage)
    }

    @MainActor
    func test_pendingStage_isNilWhenInstallDateMissing() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults, nowOffsetDays: 0)
        // ensureInstallDate wurde NICHT aufgerufen
        XCTAssertNil(store.pendingStage)
    }

    // MARK: - persistence

    @MainActor
    func test_dismissedStages_persistAcrossInstances() {
        let defaults = isolatedDefaults()
        let s1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        s1.ensureInstallDate()
        s1.dismiss(.week)

        let s2 = makeStore(defaults: defaults, nowOffsetDays: 10)
        XCTAssertNil(s2.pendingStage) // .week dismissed, .quarter noch nicht fällig
    }

    @MainActor
    func test_userHasSupported_persistsAcrossInstances() {
        let defaults = isolatedDefaults()
        let s1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        s1.ensureInstallDate()
        s1.markAsSupporter()

        let s2 = makeStore(defaults: defaults, nowOffsetDays: 200)
        XCTAssertTrue(s2.userHasSupported)
        XCTAssertNil(s2.pendingStage)
    }
}
```

- [ ] **Step 2: Tests müssen fehlschlagen (Compile-Fehler)**

Run:
```bash
xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' test -quiet 2>&1 | tail -20
```

Expected: BUILD FAILED mit Fehlern wie `cannot find 'SupportPromptStore' in scope`. Das ist gewünscht — die Implementierung folgt in Task 3.

---

## Task 3: SupportPromptStore — Implementierung

**Files:**
- Create: `Sources/ViewModels/SupportPromptStore.swift`

- [ ] **Step 1: Store anlegen mit minimaler Logik, damit alle Tests grün werden**

```swift
// Sources/ViewModels/SupportPromptStore.swift
import Foundation
import Observation

@Observable
@MainActor
final class SupportPromptStore {

    static let shared = SupportPromptStore()

    private enum Keys {
        static let installDate = "supportPrompt.installDate"
        static let dismissedStages = "supportPrompt.dismissedStages"
        static let userHasSupported = "supportPrompt.userHasSupported"
    }

    private let defaults: UserDefaults
    private let now: () -> Date

    private(set) var installDate: Date?
    private(set) var dismissedStages: Set<SupportStage>
    private(set) var userHasSupported: Bool

    init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
        self.defaults = defaults
        self.now = now
        self.installDate = defaults.object(forKey: Keys.installDate) as? Date
        let raw = defaults.stringArray(forKey: Keys.dismissedStages) ?? []
        self.dismissedStages = Set(raw.compactMap { SupportStage(rawValue: $0) })
        self.userHasSupported = defaults.bool(forKey: Keys.userHasSupported)
    }

    func ensureInstallDate() {
        guard installDate == nil else { return }
        let date = now()
        installDate = date
        defaults.set(date, forKey: Keys.installDate)
    }

    var pendingStage: SupportStage? {
        guard !userHasSupported, let installDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: installDate, to: now()).day ?? 0
        if days >= SupportStage.quarter.thresholdDays, !dismissedStages.contains(.quarter) {
            return .quarter
        }
        if days >= SupportStage.week.thresholdDays, !dismissedStages.contains(.week) {
            return .week
        }
        return nil
    }

    func dismiss(_ stage: SupportStage) {
        dismissedStages.insert(stage)
        persistDismissed()
    }

    func markAsSupporter() {
        userHasSupported = true
        defaults.set(true, forKey: Keys.userHasSupported)
    }

    private func persistDismissed() {
        let raw = dismissedStages.map(\.rawValue).sorted()
        defaults.set(raw, forKey: Keys.dismissedStages)
    }
}
```

- [ ] **Step 2: Tests laufen lassen — alle müssen grün sein**

Run:
```bash
xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' test -only-testing:AutoBrewTests/SupportPromptStoreTests -quiet 2>&1 | tail -20
```

Expected: `Test Suite 'SupportPromptStoreTests' passed` mit 12 Tests grün.

- [ ] **Step 3: Commit**

```bash
git add Sources/Models/SupportStage.swift \
        Sources/ViewModels/SupportPromptStore.swift \
        Tests/SupportPromptStoreTests.swift
git commit -m "Add SupportPromptStore with eligibility logic and tests"
```

---

## Task 4: SupportPromptView — Sheet-UI

**Files:**
- Create: `Sources/Views/SupportPromptView.swift`

- [ ] **Step 1: View anlegen**

```swift
// Sources/Views/SupportPromptView.swift
import AppKit
import SwiftUI

struct SupportPromptView: View {
    let stage: SupportStage
    let onStar: () -> Void
    let onSponsor: () -> Void
    let onLater: () -> Void
    let onAlreadyDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.pink)
                .padding(.top, 8)

            Text("Gefällt dir AutoBrew?")
                .font(.title2)
                .fontWeight(.semibold)

            Text("AutoBrew ist kostenlos und Open Source. Wenn dir die App hilft, freue ich mich über deine Unterstützung — kostet dich nichts.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            VStack(spacing: 10) {
                Button(action: onStar) {
                    Label("Stern auf GitHub geben", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button(action: onSponsor) {
                    Label("Auf GitHub Sponsors unterstützen", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.pink)

                Button("Vielleicht später", action: onLater)
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(.top, 4)

            Button("Hab ich schon gemacht", action: onAlreadyDone)
                .buttonStyle(.link)
                .font(.caption)
                .padding(.top, 2)
        }
        .padding(28)
        .frame(width: 380)
        .interactiveDismissDisabled(true)
        .accessibilityIdentifier("SupportPromptView.\(stage.rawValue)")
    }
}

#Preview {
    SupportPromptView(
        stage: .week,
        onStar: {},
        onSponsor: {},
        onLater: {},
        onAlreadyDone: {}
    )
}
```

- [ ] **Step 2: Build prüfen**

Run: `xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' build -quiet`
Expected: BUILD SUCCEEDED.

- [ ] **Step 3: Commit**

```bash
git add Sources/Views/SupportPromptView.swift
git commit -m "Add SupportPromptView sheet"
```

---

## Task 5: AppDelegate — Install-Datum setzen

**Files:**
- Modify: `Sources/App/AppDelegate.swift`

- [ ] **Step 1: `ensureInstallDate()` im Launch ergänzen**

Im `applicationDidFinishLaunching(_:)` direkt nach dem `Task { @MainActor in`-Block, vor `NotificationManager.shared.requestAuthorization()`, eine Zeile einfügen.

Exakte Änderung — die Zeile

```swift
        Task { @MainActor in
            await NotificationManager.shared.requestAuthorization()
```

wird zu

```swift
        SupportPromptStore.shared.ensureInstallDate()

        Task { @MainActor in
            await NotificationManager.shared.requestAuthorization()
```

(Direkt vor dem `Task`-Block, weil `ensureInstallDate()` synchron und `@MainActor`-isoliert ist — der `AppDelegate` selbst ist bereits `@MainActor`.)

- [ ] **Step 2: Build prüfen**

Run: `xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' build -quiet`
Expected: BUILD SUCCEEDED.

- [ ] **Step 3: Commit**

```bash
git add Sources/App/AppDelegate.swift
git commit -m "Record install date on app launch for support prompt"
```

---

## Task 6: MenuBarView — Sheet integrieren

**Files:**
- Modify: `Sources/Views/MenuBarView.swift`

- [ ] **Step 1: State + Store-Referenz hinzufügen**

In `struct MenuBarView: View` direkt nach

```swift
    @State private var needsOnboarding: Bool = !SettingsStore.shared.onboardingCompleted
```

einfügen:

```swift
    @State private var supportPrompt = SupportPromptStore.shared
    @State private var supportSheetStage: SupportStage?
```

- [ ] **Step 2: Sheet-Modifier + Trigger in `mainView` hinzufügen**

Den existierenden `private var mainView: some View {` Block am Ende (nach dem letzten `.padding`/`.frame`/etc. — je nach aktuellem Zustand der Datei) um folgende Modifier ergänzen:

```swift
        .task {
            if let stage = supportPrompt.pendingStage {
                supportSheetStage = stage
            }
        }
        .sheet(item: $supportSheetStage) { stage in
            SupportPromptView(
                stage: stage,
                onStar: {
                    NSWorkspace.shared.open(SupportLinks.starURL)
                    supportPrompt.dismiss(stage)
                    supportSheetStage = nil
                },
                onSponsor: {
                    NSWorkspace.shared.open(SupportLinks.sponsorURL)
                    supportPrompt.dismiss(stage)
                    supportSheetStage = nil
                },
                onLater: {
                    supportPrompt.dismiss(stage)
                    supportSheetStage = nil
                },
                onAlreadyDone: {
                    supportPrompt.markAsSupporter()
                    supportSheetStage = nil
                }
            )
        }
```

Falls `mainView` mehrere `VStack`/`Group`-Modifier am Ende hat: die zwei Modifier (`.task` und `.sheet`) müssen auf dem **äußersten** View in `mainView` liegen — direkt vor dem schließenden `}` der `private var mainView: some View { ... }` Property.

- [ ] **Step 3: SupportStage Identifiable machen, damit `.sheet(item:)` funktioniert**

`SupportStage` muss `Identifiable` sein. In `Sources/Models/SupportStage.swift` Conformance ergänzen:

```swift
enum SupportStage: String, CaseIterable, Sendable, Identifiable {
    case week
    case quarter

    var id: String { rawValue }

    var thresholdDays: Int {
        switch self {
        case .week: return 7
        case .quarter: return 90
        }
    }
}
```

(Nur die `Identifiable`-Conformance und die `id`-Property sind neu; Rest unverändert.)

- [ ] **Step 4: Build prüfen**

Run: `xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' build -quiet`
Expected: BUILD SUCCEEDED.

- [ ] **Step 5: Alle Tests laufen lassen**

Run: `xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -destination 'platform=macOS' test -quiet 2>&1 | tail -10`
Expected: `** TEST SUCCEEDED **`. Insbesondere SupportPromptStoreTests bleiben grün, weil die `Identifiable`-Conformance keine Logik ändert.

- [ ] **Step 6: Commit**

```bash
git add Sources/Models/SupportStage.swift Sources/Views/MenuBarView.swift
git commit -m "Show support prompt sheet from menu bar when due"
```

---

## Task 7: Manueller Smoke-Test

**Files:** (keine)

- [ ] **Step 1: App im Debug-Build starten**

```bash
xcodebuild -project AutoBrew.xcodeproj -scheme AutoBrew -configuration Debug -destination 'platform=macOS' build
open ~/Library/Developer/Xcode/DerivedData/AutoBrew-*/Build/Products/Debug/AutoBrew.app
```

(Falls die App bereits über Sparkle installiert ist, vorher beenden, damit der Debug-Build nicht mit der installierten Version kollidiert.)

- [ ] **Step 2: Aktuellen State löschen und Install-Datum auf vor 7 Tagen zurückdatieren**

App beenden, dann:

```bash
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.dismissedStages 2>/dev/null
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.userHasSupported 2>/dev/null
# Install-Datum auf 8 Tage vor jetzt setzen:
defaults write za.co.digitalfreedom.AutoBrew supportPrompt.installDate -date "$(date -v-8d '+%Y-%m-%d %H:%M:%S +0000')"
```

- [ ] **Step 3: App öffnen, Menübar-Icon klicken**

Erwartung: Sheet erscheint mit Herz-Icon, Titel „Gefällt dir AutoBrew?", drei Buttons + Footer-Link.

- [ ] **Step 4: „Stern auf GitHub geben" klicken**

Erwartung: Browser öffnet `https://github.com/marcelrgberger/auto-brew`. Sheet schließt sich.

- [ ] **Step 5: Menübar erneut öffnen**

Erwartung: Sheet erscheint **nicht** mehr (week-Stage wurde dismissed).

- [ ] **Step 6: Quarter-Trigger testen — Install-Datum auf vor 91 Tagen setzen**

```bash
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.dismissedStages
defaults write za.co.digitalfreedom.AutoBrew supportPrompt.installDate -date "$(date -v-91d '+%Y-%m-%d %H:%M:%S +0000')"
```

App neu starten, Menübar öffnen. Erwartung: Sheet erscheint erneut (jetzt für `.quarter`).

- [ ] **Step 7: „Hab ich schon gemacht" klicken**

Erwartung: Sheet schließt, kein erneutes Erscheinen.

- [ ] **Step 8: Verifizieren über UserDefaults**

```bash
defaults read za.co.digitalfreedom.AutoBrew supportPrompt.userHasSupported
```

Expected output: `1`

- [ ] **Step 9: Aufräumen — Test-Werte löschen**

```bash
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.installDate
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.dismissedStages
defaults delete za.co.digitalfreedom.AutoBrew supportPrompt.userHasSupported
```

- [ ] **Step 10: README aktualisieren (optional)**

Falls `README.md` einen Abschnitt zu „Unterstützen / Sponsoring" hat: erwähnen, dass die App nach 7 Tagen / 3 Monaten einmalig fragt. Falls nicht: ein kurzer Abschnitt „Support the project" mit den beiden Links.

Wenn README angepasst: commit.

```bash
git add README.md
git commit -m "Mention sponsor prompt in README"
```

---

## Self-Review

**Spec coverage:**
- Trigger 1 (7 Tage) → Task 3, `SupportStage.week.thresholdDays = 7`, Test `test_pendingStage_isWeekAfterSevenDays`.
- Trigger 2 (90 Tage) → Task 3, `SupportStage.quarter.thresholdDays = 90`, Test `test_pendingStage_isQuarterAfterNinetyDays`.
- Self-Reported Supporter → Task 3 `markAsSupporter()`, Test `test_userHasSupported_persistsAcrossInstances` + UI in Task 4 (`onAlreadyDone`).
- UI mit Heart, drei Buttons, Footer-Link → Task 4.
- `.quarter` priorisiert über `.week` → Task 3 Logik + Test `test_pendingStage_prefersQuarterOverWeekWhenBothDue`.
- Trigger beim Öffnen des Menübars → Task 6 (`.task` Modifier).
- Install-Datum beim Launch → Task 5.
- Persistenz in UserDefaults → Task 3, Tests `test_dismissedStages_persistAcrossInstances` + `test_userHasSupported_persistsAcrossInstances`.
- Build-Sequenz aus Spec (1. Store + Tests, 2. View, 3. Hook, 4. Integration, 5. Smoke-Test) → Tasks 2/3 (Tests + Store), 4 (View), 5 (Hook), 6 (Integration), 7 (Smoke).

Keine Spec-Anforderung ohne Task.

**Placeholder scan:** Keine „TBD" / „TODO" / „Add appropriate handling" / „Similar to Task N" gefunden. Jeder Code-Step zeigt vollständigen Code.

**Type consistency:**
- `SupportStage` ist überall identisch (`week`, `quarter`, rawValues lowercase).
- `SupportPromptStore` API: `ensureInstallDate()`, `pendingStage`, `dismiss(_:)`, `markAsSupporter()` — in Tests (Task 2), Implementierung (Task 3) und View-Integration (Task 6) konsistent.
- `SupportLinks.starURL` / `SupportLinks.sponsorURL` in Task 1 definiert, in Task 6 verwendet.
- `SupportPromptView`-Init-Parameter (`stage`, `onStar`, `onSponsor`, `onLater`, `onAlreadyDone`) in Task 4 definiert, in Task 6 in der Reihenfolge übergeben.
- `Identifiable`-Conformance auf `SupportStage` (Task 6 Step 3) ist nötig für `.sheet(item:)` aus Task 6 Step 2 — Reihenfolge im Task ist korrekt: Conformance steht vor dem Build-Check.
