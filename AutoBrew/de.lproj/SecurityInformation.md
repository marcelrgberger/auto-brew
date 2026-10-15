<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.3, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.3 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# SICHERHEITSINFORMATIONEN ZU DIESEM PRODUKT

## Informationen und Anleitungen für den Nutzer — Anhang II der Verordnung (EU) 2024/2847 (Cyber Resilience Act)

**Produkt:** AutoBrew, Version 2.5.3 und neuer
**Gilt ab:** Anhang II des Cyber Resilience Act gilt für Produkte, die ab dem **11. Dezember 2027** auf dem
EU-Markt in Verkehr gebracht werden, und früher für jedes bestehende Produkt, das einer wesentlichen Änderung
unterzogen wird. Diese Informationen werden für AutoBrew bereits vor diesem Datum bereitgestellt.

---

## 1. Hersteller

DigitalFreedom — eine Marke der DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Zentrale Anlaufstelle: hello@digitalfreedom.co.za

## 2. Wo Sie eine Schwachstelle melden

Sicherheitsmeldungen: <https://security.digitalfreedom.co.za> oder `security@digitalfreedom.co.za`.
Das vollständige Verfahren einschließlich Safe Harbour ist in der Richtlinie zur koordinierten Offenlegung von Schwachstellen beschrieben (Einstellungen → Rechtliches → Offenlegung von Schwachstellen);
maschinenlesbar: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Produktidentifikation

AutoBrew — `za.co.digitalfreedom.AutoBrew` — eine macOS-Anwendung (macOS 14 oder neuer), die direkt als notarisierter Download über GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) und über den Homebrew-Tap `marcelrgberger/homebrew-tap` vertrieben wird.
Die installierte Version wird in den Einstellungen der App im Bereich „Über“ oberhalb des Bereichs „Rechtliches“ angezeigt.

## 4. Bestimmungsgemäßer Zweck und wesentliche Cybersicherheitseigenschaften

AutoBrew hält die Homebrew-Pakete auf einem Mac entsprechend der vom Nutzer festgelegten Update-Richtlinie aktuell, bietet eine grafische Oberfläche zum Durchsuchen, Installieren, Aktualisieren und Entfernen von Homebrew-Casks und erstellt, wiederherstellt und migriert Snapshots der Nutzerdaten von Anwendungen. Sicherheitseigenschaften: kein Werbe-SDK und keine Werbekennung; ausschließlich lokale Mitteilungen;
Authentifizierung: keine — die App arbeitet ausschließlich lokal; Datenspeicherung: ausschließlich auf dem Gerät.

Für AutoBrew im Besonderen gilt: Die Verbindungen, die AutoBrew selbst aufbaut, verwenden HTTPS; die Download-Adressen der Pakete, die Homebrew installiert, werden von deren Herausgebern und vom Homebrew-Projekt festgelegt. Jedes Release ist mit einem Apple-Developer-ID-Zertifikat signiert, von Apple notarisiert und mit der Hardened Runtime erstellt. Über den integrierten Updater (Sparkle) bereitgestellte Updates werden vor der Installation anhand einer EdDSA-Signatur (Ed25519) geprüft. AutoBrew speichert seine Daten auf dem Mac oder an dem vom Nutzer gewählten Snapshot-Speicherort; es sendet keine Daten an den Hersteller.

## 5. Bekannte oder vorhersehbare Umstände mit erheblichem Cybersicherheitsrisiko

- **AutoBrew läuft außerhalb der App Sandbox**, weil es `brew`, `ditto` und andere Systemwerkzeuge ausführen muss. Es handelt mit den Rechten des angemeldeten Nutzers.
- **Über Homebrew installierte oder aktualisierte Software** wird von Dritten veröffentlicht und läuft mit den Rechten des Nutzers. Bei aktivierten automatischen Upgrades werden neue Versionen entsprechend der vom Nutzer festgelegten Update-Richtlinie installiert, ohne gesonderte Bestätigung für jedes Update in der Kategorie „automatisch installieren“.
- **Snapshots enthalten Kopien von Anwendungsdaten**, die Zugangsdaten, Tokens oder andere sensible Informationen umfassen können, die eine Anwendung in ihren Nutzerdatenordnern speichert. Snapshots und exportierte Snapshot-Dateien werden von AutoBrew nicht verschlüsselt; jeder, der Zugriff auf den Snapshot-Speicherort, ein dafür verwendetes externes Laufwerk oder eine exportierte Datei hat, kann sie lesen. Automatische Snapshots vor Upgrades sind standardmäßig aktiviert (Einstellungen → Snapshots).
- **Die Installation von Homebrew** aus AutoBrew heraus führt das offizielle, von GitHub heruntergeladene Homebrew-Installationsskript aus.

Keiner dieser Umstände ist eine bekannte Schwachstelle. Später entdeckte Umstände werden durch Sicherheitsupdates behoben und, soweit sie die Schwellenwerte des Art. 14 erreichen, wie vorgeschrieben gemeldet.

## 6. EU-Konformitätserklärung

Die EU-Konformitätserklärung ist ab dem 11. Dezember 2027 erforderlich und wurde für AutoBrew noch nicht ausgestellt. Sobald sie ausgestellt ist, ist sie auf Anfrage unter hello@digitalfreedom.co.za erhältlich, und ihr Fundort wird hier angegeben.

## 7. Technischer Support und Supportzeitraum

Sicherheitslücken werden behandelt und Sicherheitsupdates bereitgestellt, **mindestens bis Oktober 2031 für Version 2.5.3** (veröffentlicht auf GitHub Releases am 15. Oktober 2026) und für jede spätere Version mindestens bis zum selben Monat fünf Jahre nach der Veröffentlichung dieser Version auf GitHub Releases.
Die allgemeine Zusage und was „Support“ umfasst, ist in der Support- und Update-Richtlinie beschrieben (Einstellungen → Rechtliches → Support- und Update-Richtlinie). Supportanfragen:
<https://support.apps.digitalfreedom.co.za>.

## 8. Sichere Nutzung während der Lebensdauer des Produkts

- **Installation und erste Nutzung:** Installieren Sie ausschließlich über GitHub Releases unter https://github.com/marcelrgberger/auto-brew/releases oder über den Homebrew-Tap `marcelrgberger/homebrew-tap`; macOS prüft beim ersten Öffnen der App die Developer-ID-Signatur und die Notarisierung. Für eine sichere Grundeinstellung ist keine Konfiguration erforderlich — die App hat keinen optionalen Datenfluss zum Hersteller.
- **Sicherheitsupdates** werden über den integrierten Updater von AutoBrew (Einstellungen → Aktualisierungen → Nach Updates suchen), über den Homebrew-Tap oder als neuer Download über GitHub Releases bereitgestellt. Lassen Sie die automatische Updateprüfung aktiviert; wenn Sie sie deaktivieren, suchen Sie regelmäßig nach Updates — eine veraltete Version erhält keine Korrekturen mehr.
- **Sicherheitsrelevante Änderungen:** Die Erteilung von Betriebssystemberechtigungen erweitert, worauf die App zugreifen kann; AutoBrew bittet um die Berechtigung, Mitteilungen anzuzeigen, und jede Berechtigung kann jederzeit in den Systemeinstellungen widerrufen werden. Die Wahl eines externen Snapshot-Speicherorts, die Aktivierung der automatischen Installation für eine Paketkategorie und die Ausführung paketbezogener Befehle vor einem Snapshot erweitern, was AutoBrew in Ihrem Namen tut.
- **Außerbetriebnahme:** Durch die Deinstallation wird die App entfernt. Um ihre lokalen Daten zu entfernen, löschen Sie die in der Datenschutzerklärung, Abschnitt 3.6, aufgeführten Ordner, einschließlich eines von Ihnen gewählten externen Snapshot-Speicherorts und aller exportierten Snapshot-Dateien. AutoBrew hat kein Konto und speichert keine Daten auf den Servern des Herstellers.

## 9. Software-Stückliste (SBOM)

Für AutoBrew wird keine SBOM veröffentlicht. Komponenten Dritter und ihre Lizenzen sind im Dokument Open-Source-Lizenzen aufgeführt (Einstellungen → Rechtliches → Open-Source-Lizenzen).
