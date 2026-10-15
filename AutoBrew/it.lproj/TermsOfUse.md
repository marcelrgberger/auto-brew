<!-- doc-id: TERMS_OF_SERVICE | lang: en | area: shared | version: 2.0.1 | valid-from: 2026-10-13 | supersedes: TERMS_OF_SERVICE 2.0.0 (telephone number removed from § 14.7), 1.x; absorbs EU_CONSUMER_ANNEX, ANZ_CONSUMER_ANNEX (consumer parts, 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/TERMS_OF_SERVICE.en.md | adaptations: direct distribution instead of app stores (§ 1.1.1, § 14.1, § 14.5-14.7), AutoBrew description, Homebrew and updates (§ 2.1, § 2.4, § 2.5), no accounts (§ 3), no user content sent to the Provider (§ 4), no shared resource (§ 5), free of charge (§ 7), MIT License (§ 5, § 6.1, § 12.2), sibling links replaced by in-app document names, translation count removed (§ 16.8) | translated-from: en -->
# TERMINI DI SERVIZIO

## Condizioni generali di contratto

**Applicazione:** AutoBrew

**Data di entrata in vigore:** 15 ottobre 2026

**Fornitore:**
DigitalFreedom
Un marchio di DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contatto: hello@digitalfreedom.co.za
Sito web: https://digitalfreedom.co.za

---

## 1. AMBITO DI APPLICAZIONE E ACCETTAZIONE

### 1.1 Contratto

I presenti Termini di servizio (i "Termini") disciplinano l'accesso e l'utilizzo dell'applicazione AutoBrew e dei servizi correlati, come l'assistenza (i "Servizi"), forniti con il marchio **DigitalFreedom** da DigitalFreedom Global LLC (il "Fornitore").

### 1.1.1 Ambito di applicazione globale

AutoBrew è distribuita direttamente dal Fornitore, come download notarizzato da GitHub Releases e tramite il tap Homebrew `marcelrgberger/homebrew-tap`, e non tramite l'Apple App Store o il Google Play Store. Può essere scaricata in ogni Paese dal quale tali canali sono raggiungibili. I presenti Termini si applicano a livello globale a tutti gli utenti dei Servizi, indipendentemente dal Paese di accesso o di utilizzo. Il Fornitore adotta il Regolamento generale sulla protezione dei dati dell'Unione europea (GDPR) e la normativa UE correlata come standard di riferimento e li applica come livello minimo globale; restano impregiudicati, e prevalgono ove più protettivi, i diritti imperativi di tutela dei consumatori e gli altri diritti previsti dalla legge del Paese di residenza dell'utente.

### 1.2 Accettazione

Accedendo ai Servizi o utilizzandoli, accettate di essere vincolati dai presenti Termini. Se non li accettate, non dovete utilizzare i Servizi.

### 1.3 Requisiti

Per concludere un contratto con noi dovete avere la capacità di agire necessaria ai sensi della legge del vostro luogo di residenza: di norma 18 anni, 19 in Corea del Sud. I minori possono utilizzare i Servizi solo con il coinvolgimento di un genitore o tutore che accetti i presenti Termini per loro conto.

Si tratta di una questione distinta dall'età a partire dalla quale si può prestare il consenso al trattamento dei propri dati personali, che è fissata tra 13 e 16 anni a seconda dello Stato membro ed è trattata nell'Informativa sulla privacy. Nessuno dei due limiti determina l'altro: il § 110 BGB, che consente a un minore di concludere alcuni contratti con mezzi propri, non riguarda un'obbligazione di durata come un abbonamento.

### 1.4 Uso professionale

Se utilizzate i Servizi per conto di un'organizzazione, dichiarate di avere il potere di vincolare tale organizzazione ai presenti Termini.

---

## 2. SERVIZI

### 2.1 Descrizione

AutoBrew è un'applicazione per la barra dei menu di macOS che mantiene aggiornati i pacchetti Homebrew secondo la politica di aggiornamento da voi impostata, fornisce un'interfaccia grafica per sfogliare, installare, aggiornare e rimuovere i cask di Homebrew, e crea, ripristina e migra snapshot dei dati utente delle applicazioni sul vostro Mac. È:

- **Open source** secondo la MIT License; codice sorgente all'indirizzo https://github.com/marcelrgberger/auto-brew
- **Gratuita**: nessun acquisto in-app, nessun abbonamento, nessuna versione a pagamento
- **Locale**: funziona sul vostro Mac e non richiede alcun account né alcun servizio di backend del Fornitore

### 2.2 Modifiche

Il Fornitore si riserva il diritto di modificare, sospendere o cessare qualsiasi Servizio. **Per i consumatori nell'UE e nel SEE tale diritto è limitato:** oltre a quanto necessario per mantenere la conformità del Servizio, il Servizio è modificato solo per un giustificato motivo qui indicato (adeguamento a un nuovo ambiente tecnico, a requisiti della piattaforma modificati, a requisiti di legge, oppure cessazione di un servizio di terzi da cui la funzione dipende) e una modifica che incida in misura non trascurabile sul vostro accesso o sul vostro utilizzo vi è comunicata in anticipo su un supporto durevole, unitamente al vostro diritto di recedere gratuitamente entro 30 giorni qualora la modifica vi arrechi pregiudizio (art. 19 Direttiva (UE) 2019/770 / § 327r BGB). Le modifiche sostanziali sono comunicate a tutti ove possibile.

### 2.3 Disponibilità

I Servizi sono forniti "secondo disponibilità". Il Fornitore non garantisce un accesso o una disponibilità ininterrotti.

### 2.4 Homebrew

AutoBrew richiede un'installazione funzionante di Homebrew ed esegue il comando `brew` sul vostro Mac. Il Fornitore non è affiliato al progetto Homebrew e non controlla quali pacchetti siano disponibili, quando vengano rilasciate le versioni né che cosa facciano gli editori dei singoli pacchetti con i propri programmi di installazione. L'installazione, l'aggiornamento o la rimozione di un pacchetto tramite AutoBrew costituiscono un'operazione di Homebrew e del pacchetto interessato (si vedano le Sezioni da 8 a 10).

### 2.5 Aggiornamenti

AutoBrew si aggiorna tramite il framework Sparkle a partire dall'appcast di AutoBrew pubblicato su GitHub. Ogni aggiornamento è firmato con una chiave EdDSA (Ed25519) e verificato prima di essere installato. In alternativa potete aggiornare tramite il tap Homebrew o scaricando manualmente una release più recente.

---

## 3. ACCOUNT

AutoBrew non prevede account. Non è richiesta alcuna registrazione e il Fornitore non conserva nulla per vostro conto in un account; le Sezioni da 3.1 a 3.3 delle condizioni generali (registrazione, sicurezza delle credenziali, sospensione dell'account) non trovano pertanto applicazione.

---

## 4. CONTENUTI DELL'UTENTE

AutoBrew non invia al Fornitore nulla di ciò che create o memorizzate con essa: impostazioni, politiche di aggiornamento, raccolte e snapshot restano sul vostro Mac. Siete gli unici responsabili dei file di cui create uno snapshot, che ripristinate, esportate o importate, nonché di avere il diritto di farlo. Ciò che inviate al Fornitore in una richiesta di assistenza è utilizzato esclusivamente per rispondervi, come descritto nell'Informativa sulla privacy.

---

## 5. USO CONSENTITO

Non dovete:

- Violare leggi o regolamenti applicabili
- Violare diritti di proprietà intellettuale o altri diritti di terzi
- Trasmettere malware, spam o contenuti dannosi
- Tentare di ottenere un accesso non autorizzato ai Servizi o ai sistemi correlati
- Interferire con il funzionamento o la sicurezza dei Servizi
- Utilizzare i Servizi per finalità fraudolente o ingannevoli
- Ridistribuire AutoBrew in modo non conforme alla MIT License, presentare un fork come distribuzione ufficiale di AutoBrew o utilizzare i marchi AutoBrew o DigitalFreedom in violazione del § 6.2

---

## 6. PROPRIETÀ INTELLETTUALE

### 6.1 Proprietà intellettuale del Fornitore

I Servizi, compresi software, design, loghi e documentazione, sono protetti dalle leggi sulla proprietà intellettuale. Il codice sorgente di AutoBrew è pubblicato secondo la MIT License, che conferisce i diritti in essa indicati; tutti i diritti non espressamente concessi restano in capo al Fornitore.

### 6.2 Marchi

I marchi e le denominazioni commerciali del Fornitore non possono essere utilizzati senza previo consenso scritto. **AutoBrew** e **DigitalFreedom** sono marchi di DigitalFreedom Global LLC; la MIT License non conferisce alcun diritto su di essi. I fork e le opere derivate possono fare riferimento ad AutoBrew in modo descrittivo (ad esempio "fork of AutoBrew"), ma non possono utilizzare tali marchi come nome del proprio prodotto, per un prodotto o servizio a pagamento concorrente o in modo tale da suggerire un'approvazione da parte del Fornitore. I dettagli sono indicati nella Dichiarazione sui marchi fornita con AutoBrew, Sezione 4.

### 6.3 Feedback

Qualsiasi feedback o suggerimento da voi fornito può essere utilizzato dal Fornitore senza alcun obbligo nei vostri confronti.

---

## 7. PAGAMENTI E ABBONAMENTI

AutoBrew è gratuita. Non sono previsti acquisti in-app né abbonamenti; pertanto le disposizioni delle condizioni generali relative a prezzi, elaborazione dei pagamenti, abbonamenti, California Automatic Renewal Law, rimborsi e diritto di recesso UE per i contenuti digitali a pagamento sono prive di oggetto finché AutoBrew è gratuita.

Il link **Sponsor** in AutoBrew conduce a GitHub Sponsors ed è del tutto facoltativo. Un contributo costituisce una donazione, è gestito da GitHub secondo le proprie condizioni e non dà diritto ad alcuna funzione né ad alcuna assistenza.

Il Fornitore può introdurre in versioni future funzioni a pagamento facoltative, edizioni a pagamento o servizi aggiuntivi a pagamento. Le condizioni di tali offerte, comprese le informazioni per i consumatori da esse richieste, sono pubblicate prima che siano offerte; resta impregiudicato il vostro diritto di continuare a utilizzare una versione gratuita già installata.

---

## 8. SERVIZI DI TERZI

### 8.1 Integrazione

I Servizi possono integrarsi con servizi di terzi o contenere link a essi. Il Fornitore non approva né controlla tali servizi.

### 8.2 Condizioni

L'utilizzo di servizi di terzi è soggetto alle rispettive condizioni e informative sulla privacy.

### 8.3 Responsabilità

Il Fornitore non risponde di alcun danno derivante dal vostro utilizzo di servizi di terzi.

---

## 9. ESCLUSIONE DI GARANZIE

NELLA MISURA MASSIMA CONSENTITA DALLA LEGGE:

- I Servizi sono forniti "NELLO STATO IN CUI SI TROVANO" e "SECONDO DISPONIBILITÀ"
- Il Fornitore esclude qualsiasi garanzia, espressa o implicita
- Nessuna garanzia di esattezza, completezza, affidabilità o idoneità a uno scopo particolare
- Nessuna garanzia che i Servizi siano ininterrotti, sicuri o privi di errori

Nulla nella presente sezione esclude o limita alcuna garanzia o responsabilità che non possa essere esclusa o limitata ai sensi delle norme imperative applicabili, compresi i diritti di garanzia legale imperativi dei consumatori. **Per i consumatori in Australia e Nuova Zelanda si applica il § 14.5, che prevale sulla presente sezione.**

---

## 10. LIMITAZIONE DI RESPONSABILITÀ

NELLA MISURA MASSIMA CONSENTITA DALLA LEGGE:

- Il Fornitore non risponde di danni indiretti, incidentali, speciali, consequenziali o punitivi
- Il Fornitore non risponde della perdita di dati, profitti, ricavi od opportunità commerciali
- La responsabilità complessiva non può superare il maggiore tra (a) l'importo da voi pagato nei 12 mesi precedenti la pretesa e (b) EUR 100

**Eccezioni imperative.** Le esclusioni e limitazioni di cui sopra **non** si applicano, e il Fornitore resta pienamente responsabile, per: (a) danni derivanti da dolo o colpa grave; (b) lesioni alla vita, all'integrità fisica o alla salute; (c) responsabilità ai sensi della normativa imperativa sulla responsabilità per danno da prodotti difettosi (compresa la legge tedesca sulla responsabilità per danno da prodotti / Produkthaftungsgesetz); (d) la violazione colpevole di un obbligo contrattuale essenziale (obbligo cardinale / *Kardinalpflicht*); in tal caso la responsabilità per colpa lieve è limitata al danno prevedibile e tipico del contratto; e (e) qualsiasi altra responsabilità che non possa essere limitata o esclusa ai sensi delle norme imperative applicabili. Restano impregiudicati i diritti imperativi dei consumatori previsti dalla legge. **Per i consumatori in Australia e Nuova Zelanda si applica il § 14.5, che prevale sulla presente sezione.**

---

## 11. MANLEVA

Nella misura consentita dalla legge applicabile, vi impegnate a tenere indenne e manlevare il Fornitore da pretese di terzi, danni, perdite e spese (comprese ragionevoli spese legali) nella misura in cui siano causati da una vostra condotta colpevole (dolosa o colposa), in particolare:

- Il vostro utilizzo illecito dei Servizi
- La vostra violazione colpevole dei presenti Termini
- La vostra violazione di qualsiasi legge o di diritti di terzi
- I file di cui create uno snapshot, che ripristinate, esportate o importate con AutoBrew

Tale obbligo non si applica laddove e nella misura in cui non siate responsabili della violazione in questione, e non pregiudica né riduce i vostri diritti imperativi di consumatori previsti dalla legge.

---

## 12. RECESSO E RISOLUZIONE

### 12.1 Da parte vostra

Potete cessare di utilizzare i Servizi in qualsiasi momento disinstallando AutoBrew. La rimozione di AutoBrew, della sua cartella `~/Library/Application Support/AutoBrew/`, della cartella `AutoBrew/Snapshots/` in un'eventuale posizione esterna degli snapshot da voi scelta e del suo file delle impostazioni `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist` elimina i dati conservati da AutoBrew; l'Informativa sulla privacy, Sezione 3.6, elenca tutte le posizioni.

### 12.2 Da parte del Fornitore

Il Fornitore può sospendere o revocare il vostro accesso per giusta causa, compresi una violazione sostanziale dei presenti Termini, un uso improprio dei Servizi, oppure ove ciò sia richiesto dalla legge, da un giudice o da un'autorità, o da un gestore di piattaforma. Una violazione sostanziale può comportare la revoca immediata. Qualora il Fornitore receda senza giusta causa, darà un ragionevole preavviso ove richiesto dalla legge. Restano impregiudicati i diritti imperativi di recesso previsti dalla legge a favore vostro e del Fornitore. I diritti di cui siete titolari ai sensi della MIT License non sono pregiudicati.

### 12.3 Effetti della cessazione

Alla cessazione:

- Il vostro diritto di utilizzare i Servizi cessa, salvo quanto consentito dalla MIT License
- Le disposizioni che per loro natura sono destinate a sopravvivere restano in vigore (comprese le limitazioni di responsabilità, la manleva e la legge applicabile)

---

## 13. LEGGE APPLICABILE E RISOLUZIONE DELLE CONTROVERSIE

### 13.1 Legge applicabile

I presenti Termini sono disciplinati dal diritto dello Stato del Wyoming, Stati Uniti d'America, con esclusione delle sue norme di conflitto e della Convenzione delle Nazioni Unite sui contratti di compravendita internazionale di merci. Se siete consumatori, tale scelta della legge applicabile non vi priva della protezione assicuratavi dalle disposizioni imperative della legge del Paese in cui avete la residenza abituale (art. 6(2) Regolamento Roma I e norme equivalenti).

### 13.2 Foro competente

Per gli utenti che non sono consumatori, sono competenti in via esclusiva i tribunali della Sheridan County, Wyoming, Stati Uniti. I consumatori possono agire dinanzi ai giudici del Paese in cui hanno la residenza abituale e possono essere convenuti dal Fornitore solo dinanzi a tali giudici.

### 13.3 Controversie con i consumatori (UE)

La piattaforma per la risoluzione delle controversie online della Commissione europea ha cessato la propria attività il 20 luglio 2025 a seguito dell'abrogazione del Regolamento (UE) n. 524/2013 da parte del Regolamento (UE) 2024/3228. I consumatori possono contattare direttamente il Fornitore all'indirizzo hello@digitalfreedom.co.za. Il Fornitore non è obbligato né disposto a partecipare a procedure di risoluzione delle controversie dinanzi a un organismo di conciliazione dei consumatori, salvo che ciò sia imposto dalla legge.

---

## 14. DISPOSIZIONI REGIONALI

### 14.1 Unione europea e SEE

**Si applica a:** consumatori con residenza abituale nell'UE o nel SEE (compresi Norvegia, Islanda e Liechtenstein).

**Chi fornisce AutoBrew.** AutoBrew è fornita gratuitamente e direttamente dal Fornitore. Non è coinvolto alcun app store e non vi è alcun acquisto.

**Recesso.** Le disposizioni sul recesso di cui al § 7 riguardano i contenuti digitali a pagamento; finché AutoBrew è gratuita, esse sono prive di oggetto. Le informazioni sul recesso per eventuali future offerte a pagamento sono fornite unitamente a tali offerte.

**Conformità e aggiornamenti.** La Direttiva (UE) 2019/770 disciplina la fornitura del contenuto digitale e del servizio digitale tra voi e il Fornitore. I requisiti di conformità di cui agli artt. da 6 a 8 e l'obbligo di aggiornamento di cui all'art. 8(2) sono imperativi ai sensi dell'art. 22 e non sono esclusi da alcuna disposizione dei presenti Termini; si veda la Politica di assistenza e aggiornamenti (Impostazioni → Note legali → Politica di assistenza e aggiornamenti).

**Per i consumatori nell'UE/SEE non si applicano:**

- qualsiasi esclusione o limitazione di responsabilità che vada oltre le eccezioni imperative indicate al § 10;
- qualsiasi modifica del Servizio che vada oltre quanto il § 2.2 consente nei vostri confronti;
- qualsiasi accettazione presunta di condizioni modificate in base al solo silenzio o al solo uso continuato;
- il rinnovo automatico di un periodo annuale per un ulteriore anno intero;
- qualsiasi scelta della legge applicabile che escluda le tutele imperative del luogo della vostra residenza abituale (art. 6(2) Roma I);
- qualsiasi clausola che renda vincolante la versione inglese laddove la legge del vostro Stato membro richieda la lingua locale (il § 16.8 stabilisce la regola sulla lingua prevalente).

**Specificità nazionali.**

- **Germania:** gli obblighi relativi alle note legali ai sensi del § 5 DDG e del § 18(2) MStV sono adempiuti nelle Note legali (in AutoBrew in Impostazioni → Note legali → Editore). Il § 308 n. 5 e il § 309 n. 9 BGB si applicano ai presenti Termini in quanto condizioni rivolte ai consumatori. Il pulsante di disdetta di cui al § 312k BGB riguarda i contratti che i consumatori possono concludere tramite un sito web; per AutoBrew il Fornitore attualmente non ne conclude alcuno con tale modalità.
- **Francia:** le informazioni per i consumatori sono fornite in francese; per un consumatore residente in Francia prevale la versione francese (Loi Toubon; § 16.8).
- **Belgio, Polonia:** requisiti relativi alla lingua locale analoghi alla regola francese; si applica il § 16.8.
- **Italia, Spagna, Austria:** per l'età del consenso digitale (14 anni), si veda l'Informativa sulla privacy.

### 14.2 Stati Uniti

- Ove vietato dalla legge statale, le limitazioni di responsabilità o di garanzia non si applicano

### 14.3 Regno Unito

- Si applicano le tutele del Consumer Rights Act 2015
- La responsabilità per morte o lesioni personali causate da negligenza non è esclusa

### 14.4 Canada

- La legislazione provinciale a tutela dei consumatori può prevalere su determinate disposizioni
- Per i residenti in Québec, prevale la versione francese laddove il diritto del Québec lo richieda (§ 16.8)

### 14.5 Australia e Nuova Zelanda

<!-- verbatim: ACL-prescribed-form | no-translate -->
> Our goods and services come with guarantees that cannot be excluded under the Australian Consumer Law. For major failures with the service, you are entitled:
>
> - to cancel your service contract with us; and
> - to a refund for the unused portion, or to compensation for its reduced value.
>
> You are also entitled to choose a refund or replacement for major failures with goods. If a failure with the goods or a service does not amount to a major failure, you are entitled to have the failure rectified in a reasonable time. If this is not done you are entitled to a refund for the goods and to cancel the contract for the service and obtain a refund of any unused portion. You are also entitled to be compensated for any other reasonably foreseeable loss or damage from a failure in the goods or service.
<!-- /verbatim -->

L'avviso di cui sopra integra e delimita i §§ 9 e 10 dei presenti Termini e prevale su di essi.

**Le garanzie.** Per i prodotti e servizi digitali forniti a un consumatore, l'Australian Consumer Law garantisce la qualità accettabile (s. 54), l'idoneità a qualsiasi scopo comunicato (s. 55), la conformità alla descrizione (s. 56), la dovuta cura e competenza (s. 60) e l'idoneità dei servizi allo scopo specificato (s. 61); il Consumer Guarantees Act 1993 della Nuova Zelanda prevede garanzie equivalenti (ss. 6, 8, 9, 28, 29). In caso di difetto **grave**, siete voi, e non il fornitore, a scegliere tra rimborso e sostituzione. Se il difetto non è grave, il fornitore può ripararlo entro un termine ragionevole. La sezione 64 ACL rende nullo qualsiasi tentativo di escludere, restringere o modificare tali garanzie; la s. 43 CGA prevede lo stesso in Nuova Zelanda.

**Chi ne è debitore.** Il fornitore è il **Fornitore**: AutoBrew è fornita direttamente da DigitalFreedom Global LLC, senza che uno store agisca come venditore o agente, e le garanzie, i rimedi per i difetti gravi e l'avviso di cui sopra sono dovuti direttamente dal Fornitore. Il canale da utilizzare è il contatto di assistenza (§ 16).

### 14.6 Türkiye

AutoBrew è fornita gratuitamente e direttamente dal Fornitore; nessuno store agisce come venditore. Qualora venisse introdotta un'offerta a pagamento, gli obblighi di informazione precontrattuale e di recesso entro 14 giorni previsti dalla Legge sulla tutela dei consumatori (n. 6502) e dal Regolamento sui contratti a distanza graverebbero sul Fornitore. Le controversie dei consumatori di valore inferiore alla soglia di legge devono essere sottoposte a una **Commissione arbitrale per i consumatori** prima di adire un giudice; ciò è obbligatorio, nessuna disposizione dei presenti Termini vi deroga, e ciò integra la formula "salvo che ciò sia imposto dalla legge" di cui al § 13.3.

### 14.7 Giappone

Per le vendite a consumatori in Giappone, lo Specified Commercial Transactions Act (特定商取引法) richiede che il nome, l'indirizzo e i dati di contatto del venditore, il prezzo e le condizioni di recesso siano facilmente accessibili. AutoBrew è fornita direttamente dal Fornitore, pertanto tali obblighi di indicazione gravano sul Fornitore e sono adempiuti nelle Note legali (in AutoBrew in Impostazioni → Note legali → Editore).

### 14.8 Altre giurisdizioni

- Laddove una norma imperativa locale limiti una disposizione, tale disposizione si applica solo nella misura consentita
- Le tutele imperative dei consumatori del luogo della vostra residenza abituale restano ovunque impregiudicate

## 15. FORZA MAGGIORE

Nessuna delle parti risponde del ritardo o dell'inadempimento di un obbligo derivante dai presenti Termini nella misura in cui il ritardo o l'inadempimento siano causati da eventi al di fuori del ragionevole controllo, compresi, a titolo esemplificativo e non esaustivo, eventi naturali, guerre, disordini civili, terrorismo, attacchi informatici, provvedimenti delle autorità, pandemie, incendi, inondazioni, interruzioni prolungate dell'energia elettrica o delle telecomunicazioni, o guasti dell'infrastruttura di sub-responsabili del trattamento a monte. La parte interessata ne informa l'altra senza ingiustificato ritardo e compie sforzi ragionevoli per attenuarne gli effetti.

La presente Sezione non pregiudica l'obbligo di pagare importi già dovuti, né alcun diritto imperativo di tutela dei consumatori previsto dalla legge del Paese di residenza dell'utente.

---

## 16. DISPOSIZIONI GENERALI

### 16.1 Clausola di salvaguardia

Qualora una disposizione sia ritenuta invalida, le restanti disposizioni restano pienamente efficaci.

### 16.2 Rinuncia

Il mancato esercizio di una disposizione non costituisce rinuncia.

### 16.3 Cessione

Il Fornitore può cedere i presenti Termini in relazione a una fusione, un'acquisizione, una riorganizzazione societaria o una cessione di beni. Gli utenti saranno informati con almeno 30 giorni di anticipo di qualsiasi cambiamento del soggetto contraente e, ove richiesto dalla legge, sarà richiesto un nuovo consenso. Non potete cedere il contratto senza previo consenso scritto.

### 16.4 Intero accordo

I presenti Termini, unitamente all'Informativa sulla privacy, all'EULA, alla Panoramica del quadro giuridico, alla Politica di assistenza e aggiornamenti, alla Politica di divulgazione delle vulnerabilità, alla Dichiarazione sui marchi e alle Licenze open source forniti con AutoBrew (Impostazioni → Note legali), nonché alla MIT License con cui è pubblicato il codice sorgente di AutoBrew, costituiscono l'intero accordo tra voi e il Fornitore.

### 16.5 Modifiche

Il Fornitore può aggiornare i presenti Termini. Le modifiche sostanziali sono comunicate con almeno 30 giorni di anticipo tramite i Servizi o per e-mail e, ove la normativa applicabile a tutela dei consumatori lo richieda, hanno effetto solo previa nuova accettazione. L'uso continuato dopo modifiche non sostanziali costituisce accettazione.

### 16.6 Prescrizione

Le pretese derivanti dai presenti Termini sono soggette ai termini di prescrizione previsti dalla legge applicabile. Ciò non pregiudica alcun termine di prescrizione imperativo del Paese di residenza dell'utente.

### 16.7 Comunicazioni

Le comunicazioni al Fornitore devono essere inviate a `hello@digitalfreedom.co.za` (generali) o a `data-protection@digitalfreedom.co.za` (privacy / DSGVO). Le comunicazioni a voi possono essere effettuate in AutoBrew o nelle relative note di rilascio, oppure per e-mail qualora abbiate contattato il Fornitore per e-mail.

### 16.8 Lingua

I presenti Termini sono pubblicati in più lingue. **Per un consumatore prevale la versione redatta in una lingua ufficiale del luogo della sua residenza abituale**, ove tale versione esista. La versione inglese prevale per i clienti professionali e per le lingue in cui non esiste alcuna versione. Si tratta dell'inverso della clausola abituale ed è voluto: una clausola che renda vincolante l'inglese non è valida in Francia, Belgio, Polonia, Italia, Québec o Türkiye, e dichiarare non vincolanti le traduzioni svaluterebbe la ragione stessa per cui vengono redatte.

---

Assistenza: support@digitalfreedom.co.za · https://support.apps.digitalfreedom.co.za

(c) 2025-2026 DigitalFreedom Global LLC. Tutti i diritti riservati.
