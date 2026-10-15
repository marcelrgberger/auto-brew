<!-- doc-id: TERMS_OF_SERVICE | lang: en | area: shared | version: 2.0.1 | valid-from: 2026-10-13 | supersedes: TERMS_OF_SERVICE 2.0.0 (telephone number removed from § 14.7), 1.x; absorbs EU_CONSUMER_ANNEX, ANZ_CONSUMER_ANNEX (consumer parts, 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/TERMS_OF_SERVICE.en.md | adaptations: direct distribution instead of app stores (§ 1.1.1, § 14.1, § 14.5-14.7), AutoBrew description, Homebrew and updates (§ 2.1, § 2.4, § 2.5), no accounts (§ 3), no user content sent to the Provider (§ 4), no shared resource (§ 5), free of charge (§ 7), MIT License (§ 5, § 6.1, § 12.2), sibling links replaced by in-app document names, translation count removed (§ 16.8) | translated-from: en -->
# GEBRUIKSVOORWAARDEN

## Algemene voorwaarden

**Applicatie:** AutoBrew

**Ingangsdatum:** 15 oktober 2026

**Aanbieder:**
DigitalFreedom
Een merk van DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contact: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

## 1. TOEPASSINGSGEBIED EN AANVAARDING

### 1.1 Overeenkomst

Deze gebruiksvoorwaarden ("Voorwaarden") regelen uw toegang tot en gebruik van de applicatie AutoBrew en daarmee samenhangende diensten, zoals support ("de Diensten"), die onder het merk **DigitalFreedom** worden aangeboden door DigitalFreedom Global LLC ("de Aanbieder").

### 1.1.1 Wereldwijde toepassing

AutoBrew wordt rechtstreeks door de Aanbieder verspreid — als genotariseerde download via GitHub Releases en via de Homebrew-tap `marcelrgberger/homebrew-tap` — en niet via de Apple App Store of de Google Play Store. AutoBrew kan worden gedownload in elk land van waaruit deze kanalen bereikbaar zijn. Deze Voorwaarden gelden wereldwijd voor alle gebruikers van de Diensten, ongeacht het land van toegang of gebruik. De Aanbieder hanteert de Algemene Verordening Gegevensbescherming van de Europese Unie (AVG) en het daarmee samenhangende EU-recht als basisnorm en past deze wereldwijd toe als minimumniveau; dwingende consumentenbeschermingsrechten en andere wettelijke rechten die het land van verblijf van de gebruiker toekent, blijven onverlet en hebben voorrang voor zover zij meer bescherming bieden.

### 1.2 Aanvaarding

Door de Diensten te openen of te gebruiken, stemt u ermee in aan deze Voorwaarden gebonden te zijn. Indien u niet akkoord gaat, mag u de Diensten niet gebruiken.

### 1.3 Bevoegdheid

Om met ons een overeenkomst te sluiten, moet u daartoe handelingsbekwaam zijn naar het recht van uw woonplaats — in de regel vanaf 18 jaar, en in Zuid-Korea vanaf 19 jaar. Minderjarigen mogen de Diensten uitsluitend gebruiken met betrokkenheid van een ouder of voogd die deze Voorwaarden namens hen aanvaardt.

Dit is een andere vraag dan de leeftijd waarop u toestemming kunt geven voor de verwerking van uw persoonsgegevens; die leeftijd ligt, afhankelijk van de lidstaat, tussen 13 en 16 jaar en wordt behandeld in het Privacybeleid. Geen van beide leeftijden bepaalt de andere: § 110 BGB, op grond waarvan een minderjarige bepaalde overeenkomsten met eigen middelen kan sluiten, is niet van toepassing op een duurverbintenis zoals een abonnement.

### 1.4 Zakelijk gebruik

Indien u de Diensten gebruikt namens een organisatie, verklaart u bevoegd te zijn die organisatie aan deze Voorwaarden te binden.

---

## 2. DIENSTEN

### 2.1 Beschrijving

AutoBrew is een macOS-menubalkapplicatie die Homebrew-pakketten up-to-date houdt volgens het door u ingestelde updatebeleid, een grafische interface biedt om Homebrew-casks te bekijken, te installeren, bij te werken en te verwijderen, en snapshots van gebruikersgegevens van applicaties op uw Mac aanmaakt, herstelt en migreert. AutoBrew is:

- **Open source** onder de MIT License — broncode op https://github.com/marcelrgberger/auto-brew
- **Kosteloos** — geen in-app-aankopen, geen abonnementen, geen betaalde versie
- **Lokaal** — het draait op uw Mac en vereist geen account en geen backenddienst van de Aanbieder

### 2.2 Wijzigingen

De Aanbieder behoudt zich het recht voor om een Dienst te wijzigen, op te schorten of te beëindigen. **Voor consumenten in de EU en de EER is dit recht beperkt:** buiten wat nodig is om de Dienst in overeenstemming met de overeenkomst te houden, wordt de Dienst uitsluitend gewijzigd om een hier vermelde geldige reden — aanpassing aan een nieuwe technische omgeving, aan gewijzigde platformvereisten of aan wettelijke vereisten, of de beëindiging van een dienst van een derde waarvan de functie afhankelijk is — en een wijziging die uw toegang of gebruik meer dan in geringe mate beïnvloedt, wordt u vooraf op een duurzame gegevensdrager meegedeeld, samen met uw recht om de overeenkomst binnen 30 dagen kosteloos te beëindigen indien de wijziging nadelig is (art. 19 Richtlijn (EU) 2019/770 / § 327r BGB). Wezenlijke wijzigingen worden waar mogelijk aan iedereen meegedeeld.

### 2.3 Beschikbaarheid

De Diensten worden aangeboden op basis van beschikbaarheid ("as available"). De Aanbieder garandeert geen ononderbroken toegang of beschikbaarheid.

### 2.4 Homebrew

AutoBrew vereist een werkende Homebrew-installatie en voert de opdracht `brew` uit op uw Mac. De Aanbieder is niet verbonden aan het Homebrew-project en heeft geen zeggenschap over welke pakketten beschikbaar zijn, wanneer versies worden uitgebracht of wat de uitgevers van afzonderlijke pakketten met hun installatieprogramma's doen. Het installeren, bijwerken of verwijderen van een pakket via AutoBrew is een handeling van Homebrew en van het betreffende pakket (zie de artikelen 8 tot en met 10).

### 2.5 Updates

AutoBrew werkt zichzelf bij via het Sparkle-framework vanuit de op GitHub gepubliceerde AutoBrew-appcast. Elke update is ondertekend met een EdDSA-sleutel (Ed25519) en wordt vóór installatie geverifieerd. U kunt in plaats daarvan ook bijwerken via de Homebrew-tap of door handmatig een nieuwere release te downloaden.

---

## 3. ACCOUNTS

AutoBrew kent geen accounts. Registratie is niet vereist en de Aanbieder bewaart niets voor u onder een account; de artikelen 3.1 tot en met 3.3 van de algemene voorwaarden (registratie, beveiliging van inloggegevens, opschorting van accounts) zijn daarom niet van toepassing.

---

## 4. GEBRUIKERSINHOUD

AutoBrew stuurt niets wat u ermee aanmaakt of opslaat naar de Aanbieder: instellingen, updatebeleid, collecties en snapshots blijven op uw Mac. U bent als enige verantwoordelijk voor de bestanden waarvan u snapshots maakt en die u herstelt, exporteert of importeert, en ervoor dat u daartoe gerechtigd bent. Wat u in een supportverzoek naar de Aanbieder stuurt, wordt uitsluitend gebruikt om dat verzoek te beantwoorden, zoals beschreven in het Privacybeleid.

---

## 5. AANVAARDBAAR GEBRUIK

Het is u niet toegestaan om:

- toepasselijke wet- of regelgeving te schenden
- intellectuele-eigendomsrechten of andere rechten van derden te schenden
- malware, spam of schadelijke inhoud te verzenden
- te proberen ongeautoriseerd toegang te verkrijgen tot de Diensten of daarmee verbonden systemen
- de werking of beveiliging van de Diensten te verstoren
- de Diensten te gebruiken voor frauduleuze of misleidende doeleinden
- AutoBrew anders dan in overeenstemming met de MIT License te herdistribueren, een fork te presenteren als de officiële AutoBrew-distributie, of de merken AutoBrew of DigitalFreedom te gebruiken in strijd met § 6.2

---

## 6. INTELLECTUEEL EIGENDOM

### 6.1 Intellectueel eigendom van de Aanbieder

De Diensten, met inbegrip van software, ontwerp, logo's en documentatie, worden beschermd door wetgeving inzake intellectueel eigendom. De broncode van AutoBrew is gepubliceerd onder de MIT License, die de daarin vermelde rechten verleent; alle niet uitdrukkelijk verleende rechten blijven bij de Aanbieder.

### 6.2 Merken

De merken en handelsnamen van de Aanbieder mogen niet zonder voorafgaande schriftelijke toestemming worden gebruikt. **AutoBrew** en **DigitalFreedom** zijn merken van DigitalFreedom Global LLC; de MIT License verleent daarop geen rechten. Forks en afgeleide werken mogen op beschrijvende wijze naar AutoBrew verwijzen (bijvoorbeeld "fork van AutoBrew"), maar mogen deze merken niet gebruiken als hun productnaam, voor een concurrerend betaald product of een concurrerende betaalde dienst, of op een wijze die de indruk wekt dat de Aanbieder hen onderschrijft. De bijzonderheden zijn uiteengezet in de met AutoBrew meegeleverde merkenverklaring (Handelsmerken), artikel 4.

### 6.3 Feedback

Feedback of suggesties die u verstrekt, mogen door de Aanbieder worden gebruikt zonder enige verplichting jegens u.

---

## 7. BETALINGEN EN ABONNEMENTEN

AutoBrew is kosteloos. Er zijn geen in-app-aankopen en geen abonnementen; de bepalingen van de algemene voorwaarden over prijzen, betalingsverwerking, abonnementen, de California Automatic Renewal Law, terugbetalingen en het EU-herroepingsrecht voor betaalde digitale inhoud hebben daarom geen voorwerp zolang AutoBrew kosteloos is.

De link **Sponsor** in AutoBrew leidt naar GitHub Sponsors en is volledig vrijwillig. Een bijdrage is een schenking, wordt door GitHub onder diens eigen voorwaarden afgehandeld en geeft geen recht op functies of support.

De Aanbieder kan in toekomstige versies optionele betaalde functies, betaalde edities of betaalde aanvullende diensten invoeren. De voorwaarden voor een dergelijk aanbod, met inbegrip van de daarvoor vereiste consumenteninformatie, worden gepubliceerd voordat het wordt aangeboden; uw recht om een reeds geïnstalleerde kosteloze versie te blijven gebruiken, blijft onverlet.

---

## 8. DIENSTEN VAN DERDEN

### 8.1 Integratie

De Diensten kunnen worden geïntegreerd met of verwijzen naar diensten van derden. De Aanbieder onderschrijft dergelijke diensten niet en heeft er geen zeggenschap over.

### 8.2 Voorwaarden

Uw gebruik van diensten van derden is onderworpen aan hun respectieve voorwaarden en privacybeleid.

### 8.3 Aansprakelijkheid

De Aanbieder is niet aansprakelijk voor schade die voortvloeit uit uw gebruik van diensten van derden.

---

## 9. UITSLUITING VAN GARANTIES

VOOR ZOVER MAXIMAAL WETTELIJK TOEGESTAAN:

- worden de Diensten aangeboden "IN DE STAAT WAARIN ZE ZICH BEVINDEN" ("AS IS") en "OP BASIS VAN BESCHIKBAARHEID" ("AS AVAILABLE")
- sluit de Aanbieder alle uitdrukkelijke of stilzwijgende garanties uit
- wordt geen garantie gegeven voor juistheid, volledigheid, betrouwbaarheid of geschiktheid voor een bepaald doel
- wordt niet gegarandeerd dat de Diensten ononderbroken, veilig of foutloos zullen zijn

Niets in dit artikel sluit een garantie, waarborg of aansprakelijkheid uit of beperkt deze, voor zover die naar dwingend toepasselijk recht niet kan worden uitgesloten of beperkt, met inbegrip van dwingende wettelijke garantierechten van consumenten. **Voor consumenten in Australië en Nieuw-Zeeland geldt § 14.5, dat voorrang heeft boven dit artikel.**

---

## 10. BEPERKING VAN AANSPRAKELIJKHEID

VOOR ZOVER MAXIMAAL WETTELIJK TOEGESTAAN:

- is de Aanbieder niet aansprakelijk voor indirecte schade, incidentele schade, bijzondere schade, gevolgschade of schadevergoeding met een punitief karakter
- is de Aanbieder niet aansprakelijk voor verlies van gegevens, winst, omzet of zakelijke kansen
- bedraagt de totale aansprakelijkheid niet meer dan het hoogste van (a) het bedrag dat u in de 12 maanden voorafgaand aan de vordering hebt betaald, of (b) EUR 100

**Dwingende uitzonderingen.** De bovenstaande uitsluitingen en beperkingen gelden **niet** voor, en de Aanbieder blijft volledig aansprakelijk voor: (a) schade als gevolg van opzet of grove nalatigheid; (b) letsel aan leven, lichaam of gezondheid; (c) aansprakelijkheid op grond van dwingend recht inzake productaansprakelijkheid (met inbegrip van de Duitse Produkthaftungsgesetz); (d) de verwijtbare schending van een wezenlijke contractuele verplichting (kernverplichting / *Kardinalpflicht*) — in dat geval is de aansprakelijkheid voor lichte nalatigheid beperkt tot de voorzienbare, voor de overeenkomst typische schade; en (e) elke andere aansprakelijkheid die naar dwingend toepasselijk recht niet kan worden beperkt of uitgesloten. Dwingende wettelijke consumentenrechten blijven onverlet. **Voor consumenten in Australië en Nieuw-Zeeland geldt § 14.5, dat voorrang heeft boven dit artikel.**

---

## 11. VRIJWARING

Voor zover toegestaan door het toepasselijke recht, stemt u ermee in de Aanbieder te vrijwaren voor en schadeloos te stellen tegen vorderingen van derden, schade, verliezen en kosten (met inbegrip van redelijke advocaatkosten), voor zover deze zijn veroorzaakt door uw verwijtbare (opzettelijke of nalatige) gedragingen, in het bijzonder:

- uw onrechtmatig gebruik van de Diensten
- uw verwijtbare schending van deze Voorwaarden
- uw schending van enige wet of van rechten van derden
- de bestanden waarvan u met AutoBrew snapshots maakt en die u herstelt, exporteert of importeert

Deze verplichting geldt niet indien en voor zover u niet verantwoordelijk bent voor de betreffende schending, en zij laat uw dwingende wettelijke rechten als consument onverlet en beperkt deze niet.

---

## 12. BEËINDIGING

### 12.1 Door u

U kunt het gebruik van de Diensten op elk moment beëindigen door AutoBrew te verwijderen. Door AutoBrew, de map `~/Library/Application Support/AutoBrew/`, de map `AutoBrew/Snapshots/` op een door u gekozen externe snapshotlocatie en het instellingenbestand `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist` te verwijderen, verwijdert u de gegevens die AutoBrew bewaart; het Privacybeleid, artikel 3.6, vermeldt alle locaties.

### 12.2 Door de Aanbieder

De Aanbieder kan uw toegang om gegronde redenen opschorten of beëindigen — onder meer bij een wezenlijke schending van deze Voorwaarden, misbruik van de Diensten, of wanneer dit vereist is door de wet, door een rechter of autoriteit, of door een platformexploitant. Een wezenlijke schending kan tot onmiddellijke beëindiging leiden. Indien de Aanbieder zonder gegronde reden beëindigt, neemt zij een redelijke opzegtermijn in acht waar dit wettelijk vereist is. Uw dwingende wettelijke opzeggingsrechten en die van de Aanbieder blijven onverlet. Rechten die u op grond van de MIT License hebt, worden niet aangetast.

### 12.3 Gevolgen van beëindiging

Bij beëindiging:

- vervalt uw recht om de Diensten te gebruiken, behalve voor zover de MIT License dit toestaat
- blijven bepalingen die naar hun aard behoren voort te duren van kracht (met inbegrip van aansprakelijkheidsbeperkingen, vrijwaring en toepasselijk recht)

---

## 13. TOEPASSELIJK RECHT EN GESCHILLENBESLECHTING

### 13.1 Toepasselijk recht

Op deze Voorwaarden is het recht van de staat Wyoming, Verenigde Staten van Amerika, van toepassing, met uitsluiting van de collisieregels daarvan en van het Weens Koopverdrag (Verdrag der Verenigde Naties inzake internationale koopovereenkomsten betreffende roerende zaken). Indien u consument bent, ontneemt deze rechtskeuze u niet de bescherming van de dwingende bepalingen van het recht van het land van uw gewone verblijfplaats (art. 6 lid 2 Rome I-Verordening en gelijkwaardige regels).

### 13.2 Bevoegde rechter

Voor gebruikers die geen consument zijn, zijn uitsluitend de rechtbanken van Sheridan County, Wyoming, Verenigde Staten, bevoegd. Consumenten kunnen een procedure aanhangig maken bij de rechter van het land van hun gewone verblijfplaats en kunnen door de Aanbieder uitsluitend voor die rechter worden gedaagd.

### 13.3 Consumentengeschillen (EU)

Het platform voor onlinegeschillenbeslechting van de Europese Commissie is op 20 juli 2025 buiten gebruik gesteld na de intrekking van Verordening (EU) nr. 524/2013 bij Verordening (EU) 2024/3228. Consumenten kunnen rechtstreeks contact opnemen met de Aanbieder via hello@digitalfreedom.co.za. De Aanbieder is niet verplicht en niet bereid deel te nemen aan geschillenbeslechtingsprocedures voor een consumentengeschillencommissie, tenzij de wet dit vereist.

---

## 14. REGIONALE BEPALINGEN

### 14.1 Europese Unie en EER

**Geldt voor:** consumenten met hun gewone verblijfplaats in de EU of de EER (met inbegrip van Noorwegen, IJsland en Liechtenstein).

**Wie levert AutoBrew.** AutoBrew wordt kosteloos rechtstreeks door de Aanbieder geleverd. Er is geen app store bij betrokken en er vindt geen aankoop plaats.

**Herroeping.** De herroepingsbepalingen van § 7 betreffen betaalde digitale inhoud; zolang AutoBrew kosteloos is, hebben zij geen voorwerp. Informatie over herroeping bij een eventueel toekomstig betaald aanbod wordt bij dat aanbod verstrekt.

**Conformiteit en updates.** Richtlijn (EU) 2019/770 regelt de levering van de digitale inhoud en dienst tussen u en de Aanbieder. De conformiteitsvereisten van de artikelen 6 tot en met 8 en de updateverplichting van art. 8 lid 2 zijn op grond van art. 22 van dwingend recht en worden door niets in deze Voorwaarden uitgesloten — zie het Support- en updatebeleid (Instellingen → Juridisch → Support- en updatebeleid).

**Voor consumenten in de EU/EER is het volgende niet van toepassing:**

- elke uitsluiting of beperking van aansprakelijkheid die verder gaat dan de in § 10 vermelde dwingende uitzonderingen;
- elke wijziging van de Dienst die verder gaat dan wat § 2.2 voor u toestaat;
- elke veronderstelde aanvaarding van gewijzigde voorwaarden enkel door stilzwijgen of voortgezet gebruik;
- automatische verlenging van een jaarlijkse looptijd met telkens een volledig jaar;
- elke rechtskeuze die de dwingende bescherming van uw gewone verblijfplaats opzijzet (art. 6 lid 2 Rome I);
- elk beding dat de Engelse versie bindend verklaart waar het recht van uw lidstaat de lokale taal voorschrijft (§ 16.8 bevat de regel over de geldende taal).

**Nationale bijzonderheden.**

- **Duitsland:** aan de colofonverplichtingen op grond van § 5 DDG en § 18 lid 2 MStV wordt voldaan in het Colofon (in AutoBrew onder Instellingen → Juridisch → Colofon). § 308 nr. 5 en § 309 nr. 9 BGB zijn op deze Voorwaarden als consumentenvoorwaarden van toepassing. De opzegknop op grond van § 312k BGB geldt voor overeenkomsten die consumenten via een website kunnen sluiten; de Aanbieder sluit voor AutoBrew momenteel geen overeenkomsten op die wijze.
- **Frankrijk:** consumenteninformatie wordt in het Frans verstrekt; voor een consument die in Frankrijk woont, is de Franse versie bepalend (Loi Toubon; § 16.8).
- **België, Polen:** taalvereisten vergelijkbaar met de Franse regel; § 16.8 is van toepassing.
- **Italië, Spanje, Oostenrijk:** voor de leeftijd van digitale toestemming (14 jaar), zie het Privacybeleid.

### 14.2 Verenigde Staten

- Waar het recht van een staat dit verbiedt, zijn beperkingen van aansprakelijkheid of garanties niet van toepassing

### 14.3 Verenigd Koninkrijk

- De bescherming van de Consumer Rights Act 2015 is van toepassing
- Aansprakelijkheid voor overlijden of letsel veroorzaakt door nalatigheid is niet uitgesloten

### 14.4 Canada

- Provinciale consumentenbeschermingswetgeving kan bepaalde bepalingen opzijzetten
- Voor inwoners van Quebec is de Franse versie bepalend waar het recht van Quebec dit vereist (§ 16.8)

### 14.5 Australië en Nieuw-Zeeland

<!-- verbatim: ACL-prescribed-form | no-translate -->
> Our goods and services come with guarantees that cannot be excluded under the Australian Consumer Law. For major failures with the service, you are entitled:
>
> - to cancel your service contract with us; and
> - to a refund for the unused portion, or to compensation for its reduced value.
>
> You are also entitled to choose a refund or replacement for major failures with goods. If a failure with the goods or a service does not amount to a major failure, you are entitled to have the failure rectified in a reasonable time. If this is not done you are entitled to a refund for the goods and to cancel the contract for the service and obtain a refund of any unused portion. You are also entitled to be compensated for any other reasonably foreseeable loss or damage from a failure in the goods or service.
<!-- /verbatim -->

De bovenstaande kennisgeving beperkt de §§ 9 en 10 van deze Voorwaarden en heeft daarboven voorrang.

**De garanties.** Voor digitale producten en diensten die aan een consument worden geleverd, garandeert de Australian Consumer Law aanvaardbare kwaliteit (s. 54), geschiktheid voor elk kenbaar gemaakt doel (s. 55), overeenstemming met de beschrijving (s. 56), de nodige zorg en vakkundigheid (s. 60) en geschiktheid van diensten voor het opgegeven doel (s. 61); de Nieuw-Zeelandse Consumer Guarantees Act 1993 voorziet in de gelijkwaardige bepalingen (ss. 6, 8, 9, 28, 29). Bij een **ernstig** gebrek kiest u tussen terugbetaling en vervanging — niet de leverancier. Bij een niet-ernstig gebrek mag de leverancier het gebrek binnen een redelijke termijn herstellen. Section 64 ACL verklaart elke poging om deze garanties uit te sluiten, te beperken of te wijzigen nietig; s. 43 CGA doet hetzelfde in Nieuw-Zeeland.

**Wie ze verschuldigd is.** De leverancier is de **Aanbieder**: AutoBrew wordt rechtstreeks geleverd door DigitalFreedom Global LLC, zonder dat een store optreedt als verkoper of tussenpersoon, en de garanties, de rechtsmiddelen bij ernstige gebreken en de bovenstaande kennisgeving zijn rechtstreeks door de Aanbieder verschuldigd. De weg daartoe is het supportcontact (§ 16).

### 14.6 Turkije

AutoBrew wordt kosteloos rechtstreeks door de Aanbieder geleverd; geen store treedt op als verkoper. Indien een betaald aanbod wordt ingevoerd, rusten de verplichtingen inzake precontractuele informatie en het herroepingsrecht van 14 dagen op grond van de Wet op de consumentenbescherming (nr. 6502) en de Verordening betreffende overeenkomsten op afstand op de Aanbieder. Consumentengeschillen onder de wettelijke drempel moeten vóór een gerechtelijke procedure worden voorgelegd aan een **Consumentenarbitragecommissie** (Consumer Arbitration Committee); dit is verplicht, niets in deze Voorwaarden wijkt daarvan af, en het nuanceert de woorden "tenzij de wet dit vereist" in § 13.3.

### 14.7 Japan

Voor verkopen aan consumenten in Japan vereist de Japanse wet op bepaalde commerciële transacties (特定商取引法) dat de naam, het adres en de contactgegevens van de verkoper, de prijs en de annuleringsvoorwaarden direct beschikbaar zijn. AutoBrew wordt rechtstreeks door de Aanbieder geleverd; deze vermeldingsplichten rusten dus op de Aanbieder en daaraan wordt voldaan in het Colofon (in AutoBrew onder Instellingen → Juridisch → Colofon).

### 14.8 Overige rechtsgebieden

- Waar dwingend lokaal recht een bepaling beperkt, is die bepaling slechts van toepassing voor zover toegestaan
- De dwingende consumentenbescherming van uw gewone verblijfplaats blijft overal onverlet

## 15. OVERMACHT

Geen van de partijen is aansprakelijk voor vertraging in of het niet nakomen van een verplichting op grond van deze Voorwaarden, voor zover de vertraging of tekortkoming wordt veroorzaakt door gebeurtenissen buiten haar redelijke invloedssfeer, waaronder maar niet beperkt tot natuurverschijnselen, oorlog, burgerlijke onrust, terrorisme, cyberaanvallen, overheidsmaatregelen, pandemieën, brand, overstromingen, langdurige uitval van stroom of telecommunicatie, of het falen van de infrastructuur van onderliggende subverwerkers. De getroffen partij stelt de andere partij zonder onnodige vertraging op de hoogte en spant zich redelijkerwijs in om de gevolgen te beperken.

Dit artikel laat de verplichting tot betaling van reeds verschuldigde bedragen onverlet, evenals elk dwingend consumentenbeschermingsrecht van het land van verblijf van de gebruiker.

---

## 16. ALGEMEEN

### 16.1 Scheidbaarheid

Indien een bepaling ongeldig wordt bevonden, blijven de overige bepalingen volledig van kracht.

### 16.2 Afstand van recht

Het niet handhaven van een bepaling houdt geen afstand van recht in.

### 16.3 Overdracht

De Aanbieder mag deze Voorwaarden overdragen in verband met een fusie, overname, herstructurering van de onderneming of verkoop van activa. Gebruikers worden ten minste 30 dagen vooraf geïnformeerd over elke wijziging van de contractpartij en, waar de wet dit vereist, wordt opnieuw toestemming gevraagd. U mag niet overdragen zonder voorafgaande schriftelijke toestemming.

### 16.4 Volledige overeenkomst

Deze Voorwaarden vormen, samen met het Privacybeleid, de EULA, het Overzicht juridisch kader, het Support- en updatebeleid, het beleid voor het Melden van kwetsbaarheden, de merkenverklaring (Handelsmerken) en de Open-source-licenties die met AutoBrew worden meegeleverd (Instellingen → Juridisch), en de MIT License waaronder de broncode van AutoBrew is gepubliceerd, de volledige overeenkomst tussen u en de Aanbieder.

### 16.5 Wijzigingen

De Aanbieder kan deze Voorwaarden bijwerken. Wezenlijke wijzigingen worden ten minste 30 dagen vooraf via de Diensten of per e-mail meegedeeld en treden, waar het toepasselijke consumentenbeschermingsrecht dit vereist, pas in werking na hernieuwde aanvaarding. Voortgezet gebruik na niet-wezenlijke wijzigingen geldt als aanvaarding.

### 16.6 Verjaringstermijn

Vorderingen op grond van deze Voorwaarden zijn onderworpen aan de wettelijke verjaringstermijnen van het toepasselijke recht. Dit laat dwingende verjaringstermijnen van het land van verblijf van de gebruiker onverlet.

### 16.7 Kennisgevingen

Kennisgevingen aan de Aanbieder dienen te worden gezonden aan `hello@digitalfreedom.co.za` (algemeen) of `data-protection@digitalfreedom.co.za` (privacy / AVG). Kennisgevingen aan u kunnen worden gedaan in AutoBrew of in de release notes daarvan, of per e-mail indien u per e-mail contact met de Aanbieder hebt opgenomen.

### 16.8 Taal

Deze Voorwaarden worden in meerdere talen gepubliceerd. **Voor een consument is de versie in een officiële taal van zijn gewone verblijfplaats bepalend**, voor zover een dergelijke versie bestaat. Voor zakelijke klanten en voor talen waarin geen versie bestaat, is de Engelse versie bepalend. Dit is het omgekeerde van het gebruikelijke beding en is bewust zo gekozen: een beding dat het Engels bindend verklaart, houdt geen stand in Frankrijk, België, Polen, Italië, Quebec of Turkije, en het onverbindend verklaren van de vertalingen zou de reden om ze op te stellen tenietdoen.

---

Support: support@digitalfreedom.co.za · https://support.apps.digitalfreedom.co.za

(c) 2025-2026 DigitalFreedom Global LLC. Alle rechten voorbehouden.
