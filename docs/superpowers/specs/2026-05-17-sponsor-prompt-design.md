# Sponsor- & Star-Prompt — Design

**Datum:** 2026-05-17
**Status:** Approved (Design-Phase)
**Bereich:** AutoBrew Menübar-App, Engagement / Funding

## Ziel

Nutzer, die AutoBrew tatsächlich verwenden, einmalig nach einer Woche und erneut nach drei Monaten bitten,

1. dem Repository einen GitHub-Stern zu geben (`https://github.com/marcelrgberger/auto-brew`) und
2. den Entwickler auf GitHub Sponsors zu unterstützen (`https://github.com/sponsors/marcelrgberger`).

AutoBrew wird ausschließlich über GitHub und Sparkle verteilt — es gibt keine App-Store-Bewertung. Der GitHub-Stern ersetzt das App-Store-Rating; Sponsoring ist die einzige Funding-Quelle für das Projekt.

## Anforderungen

- **Trigger 1:** Genau 7 Kalendertage nach erstem App-Start (`installDate`).
- **Trigger 2:** Genau 90 Kalendertage nach `installDate` (unabhängig davon, ob der User auf Trigger 1 reagiert hat).
- **Self-Reported-Supporter:** Wenn der User klickt „Hab ich schon gemacht", werden alle weiteren Prompts permanent unterdrückt. AutoBrew kann nicht prüfen, ob jemand wirklich gestarred / gesponsort hat — daher Selbstauskunft.
- **UI:** Eigenes Sheet vor dem Menübar-Popover, beim nächsten Öffnen.
- **Buttons:** „Stern auf GitHub geben" | „Auf GitHub Sponsors unterstützen" | „Vielleicht später" + sekundärer Link „Hab ich schon gemacht".
- **Visuell:** Herz-Icon (`heart.fill`) in Pink/Rot als zentrales Element.
- **Sprache:** Deutsch, kein Gendern (generisches Maskulinum).

## Architektur

Zwei neue Dateien, ein minimaler Hook in `MenuBarView`:

```
Sources/
  ViewModels/
    SupportPromptStore.swift     [NEU]   @Observable @MainActor — State + Eligibility-Logik
  Views/
    SupportPromptView.swift      [NEU]   SwiftUI-Sheet mit Heart-Header + Buttons
  Views/MenuBarView.swift        [EDIT]  .sheet(isPresented:) + Trigger-Check via .task
  App/AppDelegate.swift          [EDIT]  Beim App-Launch: installDate sicherstellen
```

Pattern matched bestehende Stores (`CatalogStore`, `SnapshotsStore`, `InstalledAppsStore`, `SettingsStore`): `@Observable @MainActor`, `static let shared`, Persistenz über `UserDefaults.standard`.

## State

`SupportPromptStore` hält drei persistierte Werte:

| UserDefaults-Key | Typ | Beschreibung |
|---|---|---|
| `supportPrompt.installDate` | `Date` | Beim ersten App-Launch gesetzt; danach unveränderlich. |
| `supportPrompt.dismissedStages` | `[String]` (Array von Raw-Values) | Welche Stufen wurden angezeigt + weggeklickt: `"week"`, `"quarter"`. |
| `supportPrompt.userHasSupported` | `Bool` | Self-Reported über „Hab ich schon gemacht". Wenn `true`, kein weiterer Prompt. |

```swift
enum SupportStage: String {
    case week     // 7 Tage nach Install
    case quarter  // 90 Tage nach Install
}
```

### Eligibility-Logik

```
var pendingStage: SupportStage? {
    if userHasSupported { return nil }
    let days = Calendar.current.dateComponents([.day], from: installDate, to: now()).day ?? 0
    if days >= 90 && !dismissedStages.contains(.quarter) { return .quarter }
    if days >=  7 && !dismissedStages.contains(.week)    { return .week }
    return nil
}
```

`.quarter` priorisiert über `.week`, falls beide gleichzeitig fällig sind (z. B. User installiert AutoBrew, öffnet das Menü aber erst 100 Tage später zum ersten Mal — dann direkt `.quarter`, `.week` wird übersprungen und als dismissed markiert).

## UI

```
┌─────────────────────────────────────────┐
│                                         │
│              ♥  (pink/rot)              │
│                                         │
│         Gefällt dir AutoBrew?           │
│                                         │
│   AutoBrew ist kostenlos und Open       │
│   Source. Wenn dir die App hilft,       │
│   freue ich mich über deine             │
│   Unterstützung — kostet dich nichts.   │
│                                         │
│   [ ★ Stern auf GitHub geben ]          │
│   [ ♥ Auf GitHub Sponsors unterstützen ]│
│   [        Vielleicht später         ]  │
│                                         │
│           Hab ich schon gemacht         │
│                                         │
└─────────────────────────────────────────┘
```

**Komponenten:**

- **Header-Icon:** `Image(systemName: "heart.fill")` in `.pink`, Größe ~64 pt.
- **Titel:** „Gefällt dir AutoBrew?" (`.title2`, `.semibold`).
- **Body:** Zwei kurze Sätze, max. ~30 Wörter.
- **Primärer Button:** „Stern auf GitHub geben" mit `star.fill`-Icon → öffnet `https://github.com/marcelrgberger/auto-brew`.
- **Sekundärer Button:** „Auf GitHub Sponsors unterstützen" mit `heart.fill`-Icon → öffnet `https://github.com/sponsors/marcelrgberger`.
- **Tertiärer Button:** „Vielleicht später" (`.plain` style) — schließt Sheet, markiert aktuelle Stage als dismissed.
- **Footer-Link:** „Hab ich schon gemacht" (`.link` style, klein) — setzt `userHasSupported = true`, schließt Sheet permanent.
- **Sheet-Verhalten:** nicht dismissable per Background-Tap; nur über Button. Verhindert versehentliches Wegklicken.

## Datenfluss

```
App-Launch (AppDelegate.applicationDidFinishLaunching)
   │
   └─► SupportPromptStore.shared.ensureInstallDate()
         setzt installDate auf Date.now falls nil

Menübar-Popover öffnet (MenuBarView.mainView via .task)
   │
   └─► supportPromptStore.checkAndShow()
         berechnet pendingStage
         wenn ≠ nil → @State showSheet = true → SupportPromptView

User-Aktion im Sheet
   │
   ├─► Star geben      → NSWorkspace.shared.open(starURL) + dismiss(currentStage)
   ├─► Sponsor werden  → NSWorkspace.shared.open(sponsorURL) + dismiss(currentStage)
   ├─► Vielleicht später → dismiss(currentStage)
   └─► Hab ich schon   → markAsSupporter()
```

**Wichtig:** Klick auf Action-Button (Star/Sponsor) bestätigt nicht, dass der User wirklich gestarred / gesponsort hat — er bekommt aber den zweiten Prompt nach 3 Monaten trotzdem, weil nur die aktuelle Stage dismissed wird, nicht `userHasSupported`. Das ist gewollt: Wer wirklich unterstützt hat, klickt am Ende „Hab ich schon gemacht", um zukünftige Prompts zu unterdrücken.

## API — SupportPromptStore

```swift
@Observable @MainActor
final class SupportPromptStore {
    static let shared = SupportPromptStore()

    private(set) var installDate: Date?
    private(set) var dismissedStages: Set<SupportStage>
    private(set) var userHasSupported: Bool

    private let defaults: UserDefaults
    private let now: () -> Date

    init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init)

    func ensureInstallDate()
    var pendingStage: SupportStage? { get }
    func dismiss(_ stage: SupportStage)
    func markAsSupporter()
}
```

Der Closure-Parameter `now` erlaubt deterministisches Testen ohne `Date.now`-Magie.

## Error-Handling

Minimal. `NSWorkspace.shared.open(_:)` returnt `Bool`; Fehlschlag (kein Standard-Browser konfiguriert) ist auf macOS extrem selten. Kein Retry, kein User-Feedback bei Fehlschlag — der User kann den Button erneut klicken oder URL manuell kopieren (zukünftige Erweiterung: Copy-URL-Button als Fallback, nicht jetzt).

## Testing

Neue Datei `Tests/SupportPromptStoreTests.swift`:

- `installDate` wird beim ersten `ensureInstallDate()` gesetzt.
- Wiederholtes `ensureInstallDate()` überschreibt das Datum nicht.
- `pendingStage == nil` direkt nach Install (Tag 0).
- `pendingStage == .week` nach exakt 7 Tagen.
- `pendingStage == .quarter` nach exakt 90 Tagen.
- Nach `markAsSupporter()` immer `nil`, auch nach >90 Tagen.
- Nach `dismiss(.week)` weiter `nil` bis Tag 90, dann `.quarter`.
- Bei spätem Erst-Launch (Install-Datum >90 Tage in der Vergangenheit, beide Stages fällig): `pendingStage == .quarter` (Priorität über `.week`).
- Nach `dismiss(.quarter)` immer `nil`, auch wenn `.week` noch nicht dismissed war.

Datums-Mocking via injizierter `now: () -> Date` Closure. Isolierte `UserDefaults`-Suite pro Test (`UserDefaults(suiteName: "test-\(UUID().uuidString)")!`), damit Tests sich nicht beeinflussen.

## Out of Scope

- Tracking, ob der User wirklich gestarred / gesponsort hat (kein GitHub-OAuth in der App).
- Push-Notifications außerhalb der App.
- Lokalisierung (AutoBrew ist aktuell nur Deutsch; bei späterer i18n separat angehen).
- Weitere Trigger jenseits 7 Tage / 3 Monate (z. B. nach 10 erfolgreichen Updates) — bewusst minimal gehalten.
- A/B-Testing der Prompt-Texte — keine Analytics in AutoBrew.

## Build-Sequenz

1. `SupportStage` enum + `SupportPromptStore` ViewModel mit Persistenz + Eligibility-Logik.
2. `SupportPromptStoreTests` — alle Tests grün, bevor UI gebaut wird.
3. `SupportPromptView` SwiftUI-Sheet.
4. `AppDelegate`-Hook: `SupportPromptStore.shared.ensureInstallDate()` beim Launch.
5. `MenuBarView` integriert: `.task { check }`, `.sheet(isPresented:)`.
6. Manueller Smoke-Test: UserDefaults-Werte per `defaults write`-Manipulation auf 7 / 90 Tage zurückdatieren, Sheet erscheint.
