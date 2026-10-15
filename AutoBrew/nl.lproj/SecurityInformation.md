<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.3, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.3 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# BEVEILIGINGSINFORMATIE VOOR DIT PRODUCT

## Informatie en instructies voor de gebruiker — bijlage II, Verordening (EU) 2024/2847 (Cyberweerbaarheidsverordening)

**Product:** AutoBrew, versie 2.5.3 en later
**Van toepassing vanaf:** bijlage II van de Cyberweerbaarheidsverordening is van toepassing op producten die vanaf
**11 december 2027** in de EU in de handel worden gebracht, en eerder op elk bestaand product dat een substantiële wijziging ondergaat.
Deze informatie wordt voor AutoBrew al vóór die datum verstrekt.

---

## 1. Fabrikant

DigitalFreedom — een merk van DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Centraal contactpunt: hello@digitalfreedom.co.za

## 2. Waar u een kwetsbaarheid kunt melden

Beveiligingsmeldingen: <https://security.digitalfreedom.co.za> of `security@digitalfreedom.co.za`.
Het volledige proces, met inbegrip van de safe harbour, staat in het beleid voor gecoördineerde openbaarmaking van kwetsbaarheden (Instellingen → Juridisch → Melden van kwetsbaarheden);
machineleesbaar: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Productidentificatie

AutoBrew — `za.co.digitalfreedom.AutoBrew` — een macOS-applicatie (macOS 14 of later), rechtstreeks verspreid als genotariseerde download via GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) en via de Homebrew-tap `marcelrgberger/homebrew-tap`.
De geïnstalleerde versie wordt in de instellingen van de app getoond in het gedeelte Over, boven het juridische overzicht.

## 4. Beoogd doel en essentiële cyberbeveiligingseigenschappen

AutoBrew houdt de Homebrew-pakketten op een Mac up-to-date volgens het door de gebruiker ingestelde updatebeleid, biedt een grafische interface om Homebrew-casks te bekijken, te installeren, bij te werken en te verwijderen, en maakt snapshots van gebruikersgegevens van applicaties aan, herstelt en migreert deze. Beveiligingseigenschappen: geen advertentie-SDK en geen advertentie-ID; uitsluitend lokale meldingen;
authenticatie: geen — de app werkt uitsluitend lokaal; gegevensopslag: uitsluitend op het apparaat.

Specifiek voor AutoBrew: de verbindingen die AutoBrew zelf opent, gebruiken HTTPS; de downloadadressen van de pakketten die Homebrew installeert, worden bepaald door hun uitgevers en het Homebrew-project. Elke release is ondertekend met een Apple Developer ID-certificaat, door Apple genotariseerd en gebouwd met de Hardened Runtime. Updates die via de ingebouwde updater (Sparkle) worden geleverd, worden vóór installatie geverifieerd aan de hand van een EdDSA-handtekening (Ed25519). AutoBrew slaat zijn gegevens op de Mac op, of op de door de gebruiker gekozen opslaglocatie voor snapshots; het stuurt geen gegevens naar de fabrikant.

## 5. Bekende of voorzienbare omstandigheden met een aanzienlijk cyberbeveiligingsrisico

- **AutoBrew draait buiten de App Sandbox**, omdat het `brew`, `ditto` en andere systeemhulpmiddelen moet uitvoeren. Het handelt met de rechten van de aangemelde gebruiker.
- **Software die via Homebrew wordt geïnstalleerd of bijgewerkt**, wordt door derden gepubliceerd en draait met de rechten van de gebruiker. Wanneer automatische upgrades zijn ingeschakeld, worden nieuwe versies geïnstalleerd volgens het door de gebruiker ingestelde updatebeleid, zonder afzonderlijke bevestiging voor elke update in de categorie "automatisch installeren".
- **Snapshots bevatten kopieën van applicatiegegevens**, die inloggegevens, tokens of andere gevoelige informatie kunnen omvatten die een applicatie in haar mappen met gebruikersgegevens bewaart. Snapshots en geëxporteerde snapshotbestanden worden door AutoBrew niet versleuteld; iedereen met toegang tot de snapshotlocatie, een daarvoor gebruikte externe schijf of een geëxporteerd bestand kan ze lezen. Automatische snapshots vóór upgrades zijn standaard ingeschakeld (Instellingen → Snapshots).
- **Het installeren van Homebrew** vanuit AutoBrew voert het officiële, van GitHub gedownloade installatiescript van Homebrew uit.

Geen van deze omstandigheden is een bekende kwetsbaarheid. Later ontdekte omstandigheden worden aangepakt met beveiligingsupdates en, wanneer zij de drempels van art. 14 bereiken, zoals vereist gemeld.

## 6. EU-conformiteitsverklaring

De EU-conformiteitsverklaring is vereist vanaf 11 december 2027 en is voor AutoBrew nog niet afgegeven. Zodra zij is afgegeven, is zij op verzoek verkrijgbaar via hello@digitalfreedom.co.za en wordt hier vermeld waar zij te vinden is.

## 7. Technische ondersteuning en ondersteuningsperiode

Beveiligingskwetsbaarheden worden behandeld en beveiligingsupdates worden geleverd **ten minste tot en met oktober 2031 voor versie 2.5.3** (gepubliceerd op GitHub Releases op 15 oktober 2026), en voor elke latere versie ten minste tot en met dezelfde maand vijf jaar nadat die versie op GitHub Releases is gepubliceerd.
De algemene toezegging en wat "support" omvat, staan in het Support- en updatebeleid (Instellingen → Juridisch → Support- en updatebeleid). Supportverzoeken:
<https://support.apps.digitalfreedom.co.za>.

## 8. Veilig gebruik gedurende de levensduur van het product

- **Installatie en eerste gebruik:** installeer uitsluitend via GitHub Releases op https://github.com/marcelrgberger/auto-brew/releases of via de Homebrew-tap `marcelrgberger/homebrew-tap`; macOS controleert de Developer ID-handtekening en de notarisatie wanneer de app voor het eerst wordt geopend. Voor een veilige standaardconfiguratie is geen instelling nodig — de app heeft geen optionele gegevensstroom naar de fabrikant.
- **Beveiligingsupdates** worden geleverd via de ingebouwde updater van AutoBrew (Instellingen → Updates → Controleer op updates), via de Homebrew-tap of als nieuwe download via GitHub Releases. Laat automatische updatecontroles ingeschakeld; schakelt u ze uit, controleer dan regelmatig op updates — een verouderde versie ontvangt geen correcties meer.
- **Wijzigingen die de beveiliging beïnvloeden:** het verlenen van besturingssysteemmachtigingen breidt uit waartoe de app toegang heeft; AutoBrew vraagt toestemming om meldingen te tonen, en elke machtiging kan op elk moment worden ingetrokken in Systeeminstellingen. Het kiezen van een externe opslaglocatie voor snapshots, het inschakelen van automatische installatie voor een pakketcategorie en het uitvoeren van opdrachten per pakket vóór een snapshot breiden uit wat AutoBrew namens u doet.
- **Buitengebruikstelling:** door de app te verwijderen, wordt de app verwijderd. Om de lokale gegevens te verwijderen, verwijdert u de mappen die in het Privacybeleid, artikel 3.6, worden vermeld, met inbegrip van een door u gekozen externe snapshotlocatie en eventuele geëxporteerde snapshotbestanden. AutoBrew heeft geen account en bewaart geen gegevens op de servers van de fabrikant.

## 9. Softwarestuklijst (SBOM)

Voor AutoBrew wordt geen SBOM gepubliceerd. Componenten van derden en hun licenties worden vermeld in het document Open-source-licenties (Instellingen → Juridisch → Open-source-licenties).
