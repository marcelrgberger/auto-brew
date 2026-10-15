<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.4, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.4 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# INFORMAZIONI SULLA SICUREZZA DI QUESTO PRODOTTO

## Informazioni e istruzioni per l'utente — Allegato II, Regolamento (UE) 2024/2847 (Cyber Resilience Act)

**Prodotto:** AutoBrew, versione 2.5.4 e successive
**Applicabile dal:** l'Allegato II del Cyber Resilience Act si applica ai prodotti immessi sul mercato dell'UE a partire
dall'**11 dicembre 2027** e, anticipatamente, a qualsiasi prodotto esistente che subisca una modifica sostanziale.
Le presenti informazioni sono fornite per AutoBrew in anticipo rispetto a tale data.

---

## 1. Fabbricante

DigitalFreedom, un marchio di DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Punto di contatto unico: hello@digitalfreedom.co.za

## 2. Dove segnalare una vulnerabilità

Segnalazioni di sicurezza: <https://security.digitalfreedom.co.za> oppure `security@digitalfreedom.co.za`.
La procedura completa, compreso il safe harbour, è descritta nella Politica di divulgazione coordinata delle vulnerabilità (Impostazioni → Note legali → Divulgazione delle vulnerabilità);
in formato leggibile da macchina: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Identificazione del prodotto

AutoBrew — `za.co.digitalfreedom.AutoBrew` — un'applicazione per macOS (macOS 14 o successivo), distribuita direttamente come download notarizzato da GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) e tramite il tap Homebrew `marcelrgberger/homebrew-tap`.
La versione installata è indicata nelle impostazioni dell'app, nella sezione Informazioni, sopra l'area delle note legali.

## 4. Destinazione d'uso e proprietà essenziali di cibersicurezza

AutoBrew mantiene aggiornati i pacchetti Homebrew su un Mac secondo la politica di aggiornamento impostata dall'utente, fornisce un'interfaccia grafica per sfogliare, installare, aggiornare e rimuovere i cask di Homebrew, e crea, ripristina e migra snapshot dei dati utente delle applicazioni. Proprietà di sicurezza: nessun SDK pubblicitario e nessun identificatore pubblicitario; solo notifiche locali;
autenticazione: nessuna, l'app funziona esclusivamente in locale; archiviazione dei dati: solo sul dispositivo.

Per AutoBrew in particolare: le connessioni aperte da AutoBrew stessa utilizzano HTTPS; gli indirizzi di download dei pacchetti installati da Homebrew sono stabiliti dai rispettivi editori e dal progetto Homebrew. Ogni release è firmata con un certificato Apple Developer ID, notarizzata da Apple e compilata con l'Hardened Runtime. Gli aggiornamenti forniti tramite il sistema di aggiornamento integrato (Sparkle) sono verificati mediante una firma EdDSA (Ed25519) prima di essere installati. AutoBrew memorizza i propri dati sul Mac, oppure nella posizione di archiviazione degli snapshot scelta dall'utente; non invia alcun dato al fabbricante.

## 5. Circostanze note o prevedibili che comportano rischi significativi di cibersicurezza

- **AutoBrew funziona al di fuori della App Sandbox** perché deve eseguire `brew`, `ditto` e altri strumenti di sistema. Agisce con i diritti dell'utente che ha effettuato l'accesso.
- **Il software installato o aggiornato tramite Homebrew** è pubblicato da terzi e viene eseguito con i diritti dell'utente. Con gli aggiornamenti automatici attivati, le nuove versioni sono installate secondo la politica di aggiornamento impostata dall'utente, senza una conferma separata per ciascun aggiornamento della categoria "installa automaticamente".
- **Gli snapshot contengono copie dei dati delle applicazioni**, che possono includere credenziali, token o altre informazioni sensibili che un'applicazione conserva nelle proprie cartelle di dati utente. Gli snapshot e i file di snapshot esportati non sono cifrati da AutoBrew; chiunque abbia accesso alla posizione degli snapshot, a un'unità esterna utilizzata a tal fine o a un file esportato può leggerli. Gli snapshot automatici prima degli aggiornamenti sono attivi per impostazione predefinita (Impostazioni → Snapshot).
- **L'installazione di Homebrew** da AutoBrew esegue lo script di installazione ufficiale di Homebrew scaricato da GitHub.

Nessuna di queste circostanze costituisce una vulnerabilità nota. Le circostanze scoperte successivamente sono gestite mediante aggiornamenti di sicurezza e, qualora raggiungano le soglie di cui all'art. 14, notificate come richiesto.

## 6. Dichiarazione di conformità UE

La dichiarazione di conformità UE è richiesta a partire dall'11 dicembre 2027 e non è ancora stata rilasciata per AutoBrew. Una volta rilasciata, sarà disponibile su richiesta all'indirizzo hello@digitalfreedom.co.za e la sua ubicazione sarà indicata qui.

## 7. Assistenza tecnica e periodo di assistenza

Le vulnerabilità di sicurezza sono gestite e gli aggiornamenti di sicurezza sono forniti **almeno fino a ottobre 2031 per la versione 2.5.4** (pubblicata su GitHub Releases il 15 ottobre 2026) e, per ciascuna versione successiva, almeno fino allo stesso mese di cinque anni dopo la pubblicazione di tale versione su GitHub Releases.
L'impegno generale e il contenuto dell'"assistenza" sono descritti nella Politica di assistenza e aggiornamenti (Impostazioni → Note legali → Politica di assistenza e aggiornamenti). Richieste di assistenza:
<https://support.apps.digitalfreedom.co.za>.

## 8. Uso sicuro per l'intera durata di vita del prodotto

- **Installazione e primo utilizzo:** installare esclusivamente da GitHub Releases all'indirizzo https://github.com/marcelrgberger/auto-brew/releases o tramite il tap Homebrew `marcelrgberger/homebrew-tap`; macOS verifica la firma Developer ID e la notarizzazione alla prima apertura dell'app. Non è necessaria alcuna configurazione per un'impostazione predefinita sicura: l'app non prevede alcun flusso di dati facoltativo verso il fabbricante.
- **Gli aggiornamenti di sicurezza** sono forniti tramite il sistema di aggiornamento integrato di AutoBrew (Impostazioni → Aggiornamenti → Cerca aggiornamenti), tramite il tap Homebrew oppure come nuovo download da GitHub Releases. Mantenete attivato il controllo automatico degli aggiornamenti; se lo disattivate, verificate regolarmente la disponibilità di aggiornamenti: una versione obsoleta non riceve più correzioni.
- **Modifiche che incidono sulla sicurezza:** la concessione di autorizzazioni del sistema operativo estende ciò a cui l'app può accedere; AutoBrew chiede l'autorizzazione a mostrare notifiche e qualsiasi autorizzazione può essere revocata in qualsiasi momento in Impostazioni di Sistema. La scelta di una posizione esterna per l'archiviazione degli snapshot, l'attivazione dell'installazione automatica per una categoria di pacchetti e l'esecuzione di comandi pre-snapshot per singolo pacchetto estendono ciò che AutoBrew fa per vostro conto.
- **Dismissione:** la disinstallazione rimuove l'app. Per rimuoverne i dati locali, eliminate le cartelle elencate nell'Informativa sulla privacy, Sezione 3.6, compresa un'eventuale posizione esterna degli snapshot da voi scelta e gli eventuali file di snapshot esportati. AutoBrew non prevede alcun account e non conserva dati sui server del fabbricante.

## 9. Distinta base del software (SBOM)

Per AutoBrew non è pubblicata alcuna SBOM. I componenti di terzi e le relative licenze sono elencati nel documento Licenze open source (Impostazioni → Note legali → Licenze open source).
