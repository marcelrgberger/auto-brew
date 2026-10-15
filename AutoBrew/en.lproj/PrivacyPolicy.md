<!-- doc-id: PRIVACY_POLICY | lang: en | area: shared | version: 2.1.1 | valid-from: 2026-10-14 | supersedes: PRIVACY_POLICY 2.1.0 (2.1.0 superseded 2.0.0; 2.0.0 superseded PRIVACY_POLICY 1.x and absorbed US_STATE_PRIVACY_NOTICE, CCPA_NOTICE_AT_COLLECTION, CANADIAN_PRIVACY_NOTICE, LGPD_BRAZIL_NOTICE, DPDP_INDIA_NOTICE, JP_APPI, KR_PIPA, KVKK_NOTICE, POPIA_NOTICE, CH_NOTICE, all 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/PRIVACY_POLICY.en.md | adaptations: direct distribution (§ 1.1), AutoBrew data and network facts incl. automatic pre-upgrade snapshots (§ 3, § 5, § 6.1.2, § 6.5, § 7, § 8, § 8b, § 9), no accounts, analytics, crash reporting, attribution, purchases, AI or health data (§ 4, § 8a, § 9.1, § 13), sub-processors limited to those processing data of AutoBrew users (§ 6.1.1, § 7), APP_DOMAIN replaced by the in-app location (§ 17.4), sibling links replaced by document names; all country sections retained -->
# PRIVACY POLICY

## Global Data Protection and Privacy Notice

**Application:** AutoBrew

**Effective Date:** 15 October 2026

**Service operated by:** DigitalFreedom — a brand of DigitalFreedom Global LLC

**Data Controller (legal entity):**
DigitalFreedom Global LLC (trading as DigitalFreedom)
30 N Gould St, Ste N
Sheridan, WY 82801
United States

Contact (general): hello@digitalfreedom.co.za
Contact (data protection): data-protection@digitalfreedom.co.za
Data protection request form: https://data-protection.digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

## 1. INTRODUCTION

This Privacy Policy explains how DigitalFreedom (a brand of DigitalFreedom Global LLC, collectively "we", "us", "our") collects, uses, stores, and protects your personal data when you use the AutoBrew application for macOS ("AutoBrew") and related services, such as support ("the Services").

In short: AutoBrew runs on your Mac. It has no account, no analytics, no crash reporting, no advertising and no tracking, and it sends nothing about you to us. The only personal data we process in connection with AutoBrew is what you send us yourself, for example in a support request. AutoBrew does contact a number of third-party services directly from your Mac to do its work; Sections 3.2 and 6.5 list them.

### 1.1 Global scope

AutoBrew is distributed directly by us — as a notarized download from GitHub Releases and through the Homebrew tap `marcelrgberger/homebrew-tap` — and not through the Apple App Store or the Google Play Store. It can be downloaded in every country from which these channels can be reached. This Privacy Policy applies globally to all users of the Services, regardless of the country in which AutoBrew is downloaded, accessed or used.

### 1.2 GDPR as the global baseline

We adopt the **European Union General Data Protection Regulation (GDPR)** and related EU data-protection law as the baseline and apply it as a **global floor** — every user, in every country, benefits from at least the GDPR-level protections set out in this Policy. We additionally respect and comply with any applicable local data-protection law of the user's jurisdiction, and where that local law is more protective for the user, the more protective standard applies.

We are committed to protecting your privacy and complying with applicable data-protection laws, including but not limited to:

- EU General Data Protection Regulation (GDPR) — applied as the global baseline
- German Federal Data Protection Act (BDSG)
- UK General Data Protection Regulation (UK GDPR) and Data Protection Act 2018
- Swiss Federal Act on Data Protection (FADP)
- California Consumer Privacy Act (CCPA) / California Privacy Rights Act (CPRA) and other US state privacy laws
- Canadian Personal Information Protection and Electronic Documents Act (PIPEDA)
- Australian Privacy Act 1988
- Brazilian General Data Protection Law (LGPD)
- Japanese Act on the Protection of Personal Information (APPI)
- South Korean Personal Information Protection Act (PIPA)
- Indian Digital Personal Data Protection Act (DPDP Act) and IT Act
- South African Protection of Personal Information Act (POPIA)
- All other applicable national data-protection regimes in jurisdictions in which AutoBrew is made available

---

## 2. DATA CONTROLLER

The Services are offered under the **DigitalFreedom** brand. The legal entity responsible for processing your personal data (the "data controller" under Art. 4(7) GDPR) is:

DigitalFreedom Global LLC (trading as DigitalFreedom)
30 N Gould St, Ste N
Sheridan, WY 82801
United States

For data protection inquiries (GDPR Art. 13/14, access, rectification, erasure, portability, objection requests):
Request form: https://data-protection.digitalfreedom.co.za
Email: data-protection@digitalfreedom.co.za

You may use either route, and you are free to reach us by any other channel — we act on your request however it arrives.

For general inquiries:
Email: hello@digitalfreedom.co.za

Website: https://digitalfreedom.co.za

---

## 3. DATA WE COLLECT

### 3.1 Data You Provide

- Communication data (support requests and feedback you send by email or through the support form at https://support.apps.digitalfreedom.co.za), including the name and email address you give us and anything you choose to include

AutoBrew has no account, no payment and no feature that uploads content to us, so no account information, payment information or user-generated content is collected.

### 3.2 Data Collected Automatically

We collect no data automatically through AutoBrew: no device information, no usage data, no analytics and no error logs reach us.

To do its work, AutoBrew connects from your Mac directly to the third-party services listed in Section 6.5 — for example to download the Homebrew catalog, look up app icons, check for AutoBrew updates and run Homebrew. Like any internet connection, each of these requests discloses your IP address and ordinary request data (such as the time and a user-agent string) to the service contacted. We do not receive these requests or their data.

AutoBrew writes diagnostic messages to the macOS unified logging system on your Mac. They are visible in the Console app and are not transmitted.

### 3.3 Data from Third Parties

None. We receive no data about you from third parties in connection with AutoBrew.

### 3.4 Sensor, Device and Biometric Data

- **Biometric authentication, camera, microphone, location, photos, contacts, calendar, motion, health:** AutoBrew uses none of them.
- **Idle time:** in idle mode, AutoBrew reads the system idle time that macOS reports, on your Mac only, to decide when to run its daily update check. The value is not stored beyond that decision and is not transmitted.
- **Application data for snapshots:** to create a snapshot of an application, AutoBrew reads that application's user-data folders and files in your Library folder and copies them into a snapshot folder on your Mac or on the storage location you chose (Section 3.6). This happens when you create a snapshot yourself and, unless you turn it off, automatically right before AutoBrew upgrades a cask: the setting "Snapshot apps before auto-upgrade" (Settings → Snapshots) is on by default and covers both scheduled upgrades and upgrades you start in the BrewStore. The automatic snapshot is skipped when free disk space is below the threshold set there (10 GiB by default). Snapshots are never sent to us.
- **Notifications:** AutoBrew schedules notifications locally on your Mac. It registers no push token and receives no notifications from a server.
- **App Tracking Transparency / advertising identifiers:** AutoBrew does not track you across other companies' apps and websites and reads no advertising identifier.

### 3.5 Data NOT Collected

We do **not** collect:

- precise location in the background
- contacts / address book
- SMS / email contents from your device
- browsing history outside the app
- behavioural-advertising identifiers
- payment-card data

### 3.6 Data stored locally on your Mac

AutoBrew keeps the following data on your Mac. None of it is sent to us.

- **Settings** in `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist`: trigger mode, idle threshold, scheduled time, last run, launch-at-login, notification, snapshot and icon-cache preferences, update policy defaults and per-package overrides, onboarding state
- **Update state** in `~/Library/Application Support/AutoBrew/`: `UpdateLedger.json` (when each package version was first seen as outdated, to measure the waiting period), `PendingUpdates.json` (updates awaiting your approval), `UpgradeHistory.json` (upgrades performed) and `Collections.json` (your collections)
- **Caches** in `~/Library/Application Support/AutoBrew/`: the Homebrew catalog and install statistics (`Catalog/`), app icons (`IconCache/`) and release notes (`ReleaseNotes/`)
- **Snapshots** in `~/Library/Application Support/AutoBrew/Snapshots/` or, if you chose an external storage location in Settings → Snapshots, in `AutoBrew/Snapshots/` inside the folder you chose: copies of the user data of applications you snapshotted and of applications AutoBrew snapshotted automatically before an upgrade. Snapshots are kept until you delete them. If you turn on "Auto-clean up old snapshots" (off by default), AutoBrew deletes snapshots older than the period set there (90 days by default, adjustable from 7 to 365 days) during its update runs. Snapshot files you export are stored wherever you save them
- **Widget state** in `~/Library/Group Containers/group.za.co.digitalfreedom.AutoBrew/WidgetState.json`, read by the AutoBrew widget

You can delete all of it by removing AutoBrew, the folder `~/Library/Application Support/AutoBrew/`, the folder `AutoBrew/Snapshots/` in an external storage location you chose, any snapshot files you exported, the widget folder above and the settings file.

---

## 4. LEGAL BASIS FOR PROCESSING (GDPR)

We process your personal data based on the following legal grounds:

| Legal Basis | Purpose |
|---|---|
| **Contract performance** (Art. 6(1)(b) GDPR) | Answering your support request about AutoBrew |
| **Legitimate interests** (Art. 6(1)(f) GDPR) | Security of our support systems, handling enquiries that are not part of a contract |
| **Consent** (Art. 6(1)(a) GDPR) | Not used — AutoBrew has no optional analytics and we send no marketing |
| **Legal obligation** (Art. 6(1)(c) GDPR) | Regulatory compliance |

---

## 5. HOW WE USE YOUR DATA

We use your personal data to:

- Communicate with you (support, answers to your enquiries, notices)
- Ensure the security of our support systems and prevent abuse
- Comply with legal obligations

We do not use any data for analytics, personalisation, profiling or advertising.

---

## 6. DATA SHARING AND DISCLOSURE

We may share your data with:

### 6.1 Service Providers

Third-party providers who assist in operating the Services, namely:

- Cloud hosting providers
- Customer support tools

### 6.1.1 Named Sub-processors

The following sub-processors are currently engaged for processing personal data of AutoBrew users, which in practice means support correspondence:

| Processor | Role | Location |
|---|---|---|
| Civo Ltd. | Cloud infrastructure (Kubernetes, virtual machines, object storage, DNS) — primary infrastructure provider, hosting our helpdesk; workloads distributed across both regions | Frankfurt am Main, Germany (`fra1`) and London, United Kingdom (`lon1`) |
| Migadu-Mail GmbH | Email hosting (inbound/outbound mail for support and contact addresses) | Servers in France (EU); company established in Switzerland |
| Storj (Storj Labs Inc.) | Off-provider copy of our server backups (helpdesk, file storage and document management data), stored through Storj's hosted gateway | United States (company); encrypted pieces on storage nodes in the EU (EU-placed bucket); location of Storj's hosted gateway not verified |

Workloads on Civo are distributed across the `fra1` and `lon1` regions for redundancy and migration purposes. Sub-processors that DigitalFreedom engages for other applications (for in-app purchases or AI features) receive no data of AutoBrew users. The list of sub-processors may change; the current list is maintained in our internal sub-processor register and is available on request via the data protection contact below.

### 6.1.2 Platform and Distribution Channels

The following party acts as an **independent controller** for processing carried out in connection with the distribution of AutoBrew — not as our processor under Art. 28 GDPR. It is disclosed here for transparency:

| Party | Role | Location |
|---|---|---|
| GitHub, Inc. | Hosts the AutoBrew source code, the release downloads, the Homebrew tap and the update feed (appcast); receives your requests when you download AutoBrew or when AutoBrew checks for updates; runs GitHub Sponsors if you choose to donate. | United States |

For data GitHub processes under its own controllership, GitHub's Privacy Statement applies: <https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement>.

### 6.2 Legal Requirements

We may disclose data when required by law, legal process, or government request.

### 6.3 Business Transfers

In the event of a merger, acquisition, or sale of assets, your data may be transferred.

### 6.4 No Sale of Personal Data

We do not sell your personal data to third parties.

### 6.5 Services AutoBrew contacts directly from your Mac

These services are contacted by AutoBrew on your Mac, not by us. They receive your IP address and ordinary request data under their own terms; we do not receive or control this data.

| Service | When and why | Operator |
|---|---|---|
| `formulae.brew.sh` | Downloading the public Homebrew cask catalog and the 365-day install statistics for the BrewStore | Homebrew project |
| Homebrew (`brew`) | Every Homebrew operation AutoBrew runs (update, upgrade, install, uninstall, search, cleanup) is performed by the Homebrew installation on your Mac, which contacts the Homebrew servers, GitHub and the download servers of the packages concerned. Homebrew collects its own anonymous analytics unless you turn them off (`brew analytics off`) — see <https://docs.brew.sh/Analytics>. If you ask AutoBrew to install Homebrew, it runs the official installation script from `raw.githubusercontent.com`. | Homebrew project; package publishers; GitHub, Inc. |
| `itunes.apple.com` (iTunes Search API) | Looking up an app icon by the application's name; the icon image is then loaded from Apple's servers | Apple Inc. — <https://www.apple.com/legal/privacy/> |
| `icon.horse` | Fallback icon lookup by the host name of a cask's homepage | icon.horse |
| `api.github.com` | Loading release notes for casks whose homepage is a GitHub repository | GitHub, Inc. |
| Download servers of casks | A request for the file size (HTTP HEAD) of a cask's download before you install it | The publisher of the cask concerned |
| GitHub (appcast and releases) | Checking for and downloading AutoBrew updates through Sparkle | GitHub, Inc. |

Links you open from AutoBrew — Help & Support, Sponsor this Project, Source Code — open in your browser and are governed by the website you visit.

---

## 7. INTERNATIONAL DATA TRANSFERS

Your data may be transferred to and processed in countries outside your country of residence.

Specifically with regard to our named sub-processors:

- **Civo `fra1` (Frankfurt am Main, Germany)** — within the EU, no transfer outside the EEA.
- **Civo `lon1` (London, United Kingdom)** — covered by the EU Commission adequacy decision for the UK pursuant to Art. 45 GDPR.
- **Migadu-Mail GmbH** — mail is stored on servers in France (EU), so storage involves no transfer outside the EEA. Migadu is established in Switzerland; access by the Swiss company is covered by the EU Commission adequacy decision for Switzerland pursuant to Art. 45 GDPR.
- **Storj (United States company; storage in the EU)** — a nightly copy of our server backups is uploaded through Storj's hosted gateway, which encrypts it on Storj's side with keys handed to Storj, so Storj can access the data in readable form there; the location of that gateway is not verified. The encrypted pieces are stored on storage nodes in the EU, because our bucket is placed in Storj's EU region. As Storj is a US company with access to the data, this is a transfer to a third country. **No data processing agreement and no Standard Contractual Clauses with Storj are in place at the date of this Policy**, and we do not rely on an adequacy decision for it. A request to Storj for a data processing agreement, the EU Standard Contractual Clauses (Module Two) and the UK Addendum was prepared on 14 October 2026.

The Controller is established outside the EEA. Where personal data of users in the EEA is processed by the Controller itself, that processing takes place outside the EEA; the Controller applies the GDPR standard to it as a global baseline, as set out in section 1.2. For onward transfers to the sub-processors named above that are not covered by an adequacy decision, other than Storj (see above):

- We rely on EU Standard Contractual Clauses (SCCs)
- We ensure adequate safeguards under GDPR Chapter V
- We assess the data protection laws of the recipient country (Transfer Impact Assessment)

For transfers from other jurisdictions, we comply with applicable cross-border transfer requirements.

The services listed in Section 6.5 and GitHub (Section 6.1.2) are contacted directly by your Mac or your browser. They may be located in the United States or elsewhere; these connections are between you and those services, not transfers made by us.

---

## 8. DATA RETENTION

We retain personal data only as long as necessary for the purposes described in this Policy.

Criteria for retention periods:

- Duration of your use of the Services
- Legal obligations — **the retention periods of the law that actually binds the Controller and the transaction**, not the longest period found anywhere; where an EU-law retention duty attaches to a specific record, that duty; never a foreign period applied to a user it does not cover
- Legitimate interests (e.g., dispute resolution)

Concrete periods per category: support tickets — 3 years from closure; logs — 30 days hot, 90 days cold. AutoBrew involves no account data, billing records or marketing subscriber data. Upon expiration, data is securely deleted or anonymized. Data stored on your Mac or in the snapshot location you chose (Section 3.6) stays there until you delete it, except snapshots removed by the optional automatic clean-up described in Section 3.6. Jurisdiction-specific retention statements are in § 17.

---

## 8a. SPECIAL CATEGORIES — HEALTH AND FITNESS DATA

AutoBrew offers no health or fitness feature and processes no data about your body or condition.

---

## 8b. ACCESS TO INFORMATION ON YOUR DEVICE (APPS)

Independently of data protection law, § 25(1) TDDDG and Art. 5(3) of Directive 2002/58/EC require your consent for storing information on your device or reading information already stored there — regardless of whether that information is personal data.

| What | When it happens | Basis |
|---|---|---|
| Local storage the app needs to work — your settings, update state, caches and snapshots (Section 3.6) | Always | Strictly necessary; § 25(2) no. 2 TDDDG |
| Reading the system idle time | Only in idle mode, which you select | Strictly necessary for the function you selected; § 25(2) no. 2 TDDDG |
| Reading application user data for a snapshot | When you create a snapshot, and before a cask upgrade while "Snapshot apps before auto-upgrade" is on (default: on; can be turned off in Settings → Snapshots) | Strictly necessary for the snapshot function; § 25(2) no. 2 TDDDG |

**No advertising identifier is read.** AutoBrew contains no analytics, crash reporting or install attribution, so there is no device access that requires consent and no consent switch.

---

## 9. DATA SECURITY

We implement appropriate technical and organizational measures to protect your data, including:

- Encryption in transit (TLS 1.3) and at rest (AES-256 or equivalent)
- Access controls (RBAC, MFA for administrative access, principle of least privilege)
- Regular security assessments and sub-processor audits
- Audit logging restricted to authorised personnel
- Daily backups with off-site replicas
- Documented incident response per our internal Breach Response Plan (Art. 33/34 GDPR)

For AutoBrew itself: every release is signed with an Apple Developer ID certificate, notarized by Apple and built with the Hardened Runtime; updates delivered through Sparkle are verified against an EdDSA (Ed25519) signature before they are installed; the source code is public at https://github.com/marcelrgberger/auto-brew.

No system is completely secure. We cannot guarantee absolute data security.

### 9.1 Breach Notification to You

In the event of a personal data breach **likely to result in a high risk** to your rights and freedoms (Art. 34 GDPR), we will notify you without undue delay using the email address you used to contact us, including:

- nature of the breach
- categories and approximate number of records concerned
- likely consequences
- measures taken or proposed to address the breach and mitigate adverse effects
- contact details for further information

If individual notification would involve disproportionate effort, we make a public communication on https://digitalfreedom.co.za/.

---

## 10. YOUR RIGHTS

### 10.1 The GDPR catalogue, as the global floor

Wherever you live, you can exercise at least:

- **Access** to your personal data (Art. 15 GDPR)
- **Rectification** of inaccurate data (Art. 16)
- **Erasure** ("right to be forgotten") (Art. 17)
- **Restriction** of processing (Art. 18)
- **Data portability** (Art. 20)
- **Objection** to processing (Art. 21)
- **Withdrawal of consent** at any time, as easily as it was given (Art. 7(3))
- **A complaint** to a supervisory authority

### 10.2 What your jurisdiction adds

Several jurisdictions grant rights beyond this floor or attach different deadlines and procedures — appeal routes, shorter response periods, named officers. **§ 17 is the single place where those are stated, per jurisdiction.** Nothing in § 17 reduces the floor above.

### 10.3 How to exercise any of them

Email `data-protection@digitalfreedom.co.za` or use the request form at <https://data-protection.digitalfreedom.co.za>. We respond within one month (Art. 12(3) GDPR) — or within the shorter period your jurisdiction prescribes, as stated in § 17.

---

## 11. CHILDREN'S PRIVACY

Our Services are not directed to children under the age of 16 (or the applicable age of consent in your jurisdiction).

We do not knowingly collect personal data from children. If we become aware that we have collected data from a child, we will take steps to delete it promptly.

---

## 12. COOKIES AND TRACKING

AutoBrew uses no cookies and no tracking technologies. The use of cookies on our website is described in the privacy information at https://digitalfreedom.co.za/privacy/.

---

## 13. AUTOMATED DECISION-MAKING AND AI

### 13.1 Automated decisions with legal or similarly significant effect

We do not engage in automated decision-making or profiling that produces legal effects concerning you or similarly significantly affects you, unless:

- You have given explicit consent
- It is necessary for contract performance
- It is authorized by applicable law

Where any such processing occurs, you have the right under Art. 22(3) GDPR to obtain human intervention, to express your point of view, and to contest the decision.

### 13.2 AI-assisted features

AutoBrew has no AI-assisted feature and sends no content to an AI provider.

### 13.3 Fair Use enforcement

AutoBrew uses no shared resource of ours that would be rationed, and no telemetry is collected, so no fair-use monitoring takes place.

### 13.4 Marketing communications

We send no marketing in connection with AutoBrew. Marketing emails would be sent only with your **explicit, separate opt-in**, which you could withdraw at any time without affecting the rest of the Services. There are no marketing push notifications: AutoBrew schedules notifications locally on your Mac and nothing is sent to it from a server. For recipients in Australia, the Spam Act 2003 standard applies to every commercial electronic message: prior consent, accurate sender identification, and a functional unsubscribe.

### 13.5 Deletion

AutoBrew has no account. To delete the data AutoBrew keeps on your Mac, follow Section 3.6. To have your support correspondence or any other data we hold erased, email data-protection@digitalfreedom.co.za or use the request form at https://data-protection.digitalfreedom.co.za.

---

## 14. THIRD-PARTY LINKS AND SERVICES

The Services may contain links to third-party websites or services. We are not responsible for the privacy practices of third parties.

---

## 15. CHANGES TO THIS POLICY

We may update this Privacy Policy from time to time.

- Material changes will be communicated in AutoBrew or its release notes, or by email where you have contacted us
- Where a change to the processing requires your consent under applicable law, we will obtain that consent before the change applies to you; we do not rely on continued use alone as consent
- The "Effective Date" at the top reflects the latest revision

---

## 16. CONTACT

For privacy-related inquiries or to exercise your rights:

DigitalFreedom
A brand of DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States

Data protection: data-protection@digitalfreedom.co.za
Data protection request form: https://data-protection.digitalfreedom.co.za
General inquiries: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

For EU residents, you may also contact the competent supervisory authority in your member state.

---

## 17. REGIONAL PROVISIONS

What each jurisdiction adds to the global baseline of this Policy. § 10.1 states the floor that applies
everywhere; nothing below reduces it. Requests for any of the rights in this section:
`data-protection@digitalfreedom.co.za` or <https://data-protection.digitalfreedom.co.za>.

### 17.1 European Union and EEA

- Processing complies with the GDPR, which also applies in Norway, Iceland and Liechtenstein through the EEA Agreement.
- No lead supervisory authority applies: the Controller is not established in the Union, so the one-stop-shop under Art. 56 GDPR does not apply.
- You may lodge a complaint with the supervisory authority of your habitual residence, your place of work, or the place of the alleged infringement (Art. 77 GDPR) — in the EEA states that is Datatilsynet (Norway), Persónuvernd (Iceland) or the Datenschutzstelle (Liechtenstein).
- Data Protection Impact Assessments are conducted where required.
- The age of digital consent is set by the Member States between 13 and 16, so this Policy states no single number because none exists. AutoBrew asks for no consent (§ 4).

### 17.2 United Kingdom

- Processing complies with the UK GDPR and the Data Protection Act 2018.
- The supervisory authority is the Information Commissioner's Office (ICO).

### 17.3 Switzerland

- The revised Federal Act on Data Protection (revFADP) applies to circumstances that have an effect in Switzerland regardless of where the Controller sits. The GDPR baseline of this Policy covers its substance.
- **Right to information (Art. 25 revFADP):** substantially the access right of Art. 15 GDPR; we respond within 30 days.
- **Breach notification (Art. 24 revFADP):** owed to the FDPIC "as soon as possible". Our internal plan runs on the shorter of the applicable periods, so the GDPR's 72-hour clock governs in practice.
- Switzerland is recognised as adequate by the EU and recognises the EEA; transfers between them need no additional safeguard.
- The competent authority is the Federal Data Protection and Information Commissioner (FDPIC).

### 17.4 United States

**The state-law common core.** The comprehensive state statutes (Virginia, Colorado, Connecticut, Texas, Oregon and the wider family) grant substantially the rights in § 10.1, and add two things:

- **Appeal.** If we deny your request, you may appeal to us; our appeal response tells you how to complain to your State Attorney General. **Exception: Utah** (Utah Code § 13-61-203 provides no appeal process).
- **Deadlines.** We respond within **45 days**, extendable once by a further 45 with notice. **Exception: Iowa**, where the statute allows 90 days plus a 45-day extension (Iowa Code § 715D.3(3)) — in practice we apply the shorter period.

**Biometrics (Illinois BIPA).** No biometric identifier is collected. AutoBrew uses no biometric feature. If a feature ever collects a biometric identifier, BIPA's written-release, retention-schedule and destruction duties apply **before** the first collection.

**Consumer health data (Washington, Nevada).** AutoBrew touches no health data, so no consumer health data policy applies to it.

**"Do Not Sell or Share" link.** Not required here: no personal information is sold or shared for cross-context behavioural advertising — AutoBrew runs no advertising and no install attribution. If that changes, the link becomes mandatory.

<!-- extract-as: CCPA_NOTICE_AT_COLLECTION | emit: standalone-page -->
#### California — Notice at Collection (CCPA/CPRA)

Provided to California residents at or before the point of collection, as required by Cal. Civ. Code §§ 1798.100(a) and 1798.130(a)(5)(A). The full Privacy Policy this notice belongs to is the AutoBrew Privacy Policy, shipped with AutoBrew (Settings → Legal → Privacy Policy).

**Categories collected in the past 12 months:**

| Category (CCPA § 1798.140(v)) | Examples we collect | Purpose | Disclosed for business purpose? | Sold or shared? |
|---|---|---|---|---|
| A. Identifiers | Email address and IP address, only when you contact support | Support, security | Yes — to sub-processors per § 6 of the Privacy Policy | **No** |
| B. Customer records (Cal. Civ. Code § 1798.80(e)) | Name, only if you give it in a support request | Support | Yes | **No** |
| C. Characteristics of protected classifications | None | — | — | — |
| D. Commercial information | None (AutoBrew is free; no purchase history) | — | — | — |
| E. Biometric information | None | — | — | — |
| F. Internet / electronic network activity | None (no analytics or telemetry) | — | — | — |
| G. Geolocation | None | — | — | — |
| H. Sensory information | None | — | — | — |
| I. Professional / employment information | None (unless you include it in a support request) | — | — | — |
| J. Education information | None | — | — | — |
| K. Inferences from the above | None | — | — | — |
| L. Sensitive personal information (CCPA § 1798.140(ae)) | None | — | — | — |

We have **not** sold or shared personal information of California residents in the past 12 months and do not intend to. The opt-out of sale or sharing therefore has no operative effect — but is available on request.

**Retention per category:** support tickets — 3 years from closure; logs — 30 days hot, 90 days cold. AutoBrew involves no account data, billing records or marketing subscriber data.

**Sensitive personal information — limit of use (§ 1798.121).** We collect no sensitive personal information through AutoBrew. Were any received, we would use it only for the purposes permitted under CPRA Regs § 7027(m) — performing the services, security, fraud prevention, service quality. Not for inferring characteristics, not for targeted advertising. The opt-out therefore has no operative effect — but is available on request.

**Your CCPA/CPRA rights:**

| Right | How to exercise |
|---|---|
| Know | Email `data-protection@digitalfreedom.co.za`, subject "CCPA Right to Know" |
| Delete | Same address; data on your Mac you delete yourself (Privacy Policy § 3.6) |
| Correct | Email the same address |
| Opt out of sale/sharing | Not applicable (we do neither) — confirmation on request |
| Limit sensitive-PI use | Not applicable (use is already limited) — confirmation on request |
| Non-discrimination | We do not discriminate for exercising rights |
| Portability | Included in the Right-to-Know response, machine-readable |
| Authorized agent | Accepted with proof of authorisation and your written permission |

We verify requests proportionate to sensitivity and risk (CCPA Regs §§ 7060–7063) and respond within **45 days**, extendable once by 45 with notice.

**Shine the Light (§ 1798.83):** we disclose no personal information to third parties for their direct-marketing purposes; the annual response is "none disclosed".

**Global Privacy Control:** honoured as a valid opt-out signal (CPRA Regs § 7025). Because we neither sell nor share, it does not change our processing, but it is acknowledged.

**Complaints:** California Privacy Protection Agency, 2101 Arena Boulevard, Sacramento, CA 95834 — <https://cppa.ca.gov/webapplications/complaint> — or the California Attorney General.
<!-- /extract-as -->

### 17.5 Canada

- **Consent (PIPEDA Principle 3):** express consent where information is sensitive or the purpose not obvious; implied consent where it is obvious and not sensitive. Withdrawal at any time, subject to legal or contractual restrictions and reasonable notice.
- **Your PIPEDA rights:** access and a copy, accuracy challenge and correction, withdrawal of consent, and complaint to the Office of the Privacy Commissioner of Canada (<https://www.priv.gc.ca>). Response generally within 30 days (PIPEDA § 8(4)).
- **Quebec (Law 25):**
  - Person responsible for the protection of personal information: **Marcel R. G. Berger**, `data-protection@digitalfreedom.co.za`, 30 N Gould St, Ste N, Sheridan, WY 82801, United States.
  - Before personal information of Quebec residents is transferred outside Quebec, a privacy impact assessment (EFVP) is conducted (Law 25 § 17). Destinations: EEA, UK and Switzerland (adequate), and the US under EU SCCs, the UK Addendum and, where applicable, the EU-US DPF.
  - You may request your data in a structured, commonly used technological format (§ 27), request cessation of dissemination or de-indexing where dissemination seriously injures your reputation or privacy, and are informed of any decision based exclusively on automated processing with the right to human review — no such decisions are currently made.
  - Confidentiality incidents presenting a risk of serious injury are notified to the Commission d'accès à l'information and to you without delay.
  - A French version of any document is available on request; for Quebec residents the French version governs where Quebec law so requires.
- **CASL:** commercial electronic messages only with express opt-in, sender identification and a working unsubscribe processed within 10 business days.
- Provincial laws (BC PIPA, Alberta PIPA) apply where more protective. Complaints also to the OIPC BC and OIPC Alberta.

### 17.6 Australia and New Zealand

- **Australia:** the Privacy Act 1988 and the Australian Privacy Principles apply to an overseas entity carrying on business in Australia. APP 12 sets a **30-day** response period for access. APP 8 makes us accountable for an overseas recipient's handling of your data — stricter than a transfer analysis, and part of why recipients are named in § 6. Complaints: Office of the Australian Information Commissioner (OAIC).
- **New Zealand:** the Privacy Act 2020 applies to an overseas agency carrying on business in New Zealand. IPP 12 restricts disclosure outside New Zealand; access requests are answered within **20 working days**. Complaints: Office of the Privacy Commissioner (NZ).

### 17.7 Brazil (LGPD)

- **Encarregado (Art. 41 LGPD):** **Marcel R. G. Berger**, `data-protection@digitalfreedom.co.za`, 30 N Gould St, Ste N, Sheridan, WY 82801, United States. ANPD Resolution CD/ANPD No. 18/2024 permits the role to be performed for a foreign controller through the channels above; this Policy is the public publication of the Encarregado's contact details it requires.
- **Legal bases (Art. 7 and 11):** contract performance (V) for answering support requests; legal obligation (II) for the retention duties that bind the Controller under the law applicable to it; legitimate interest (IX) for security and fraud prevention. AutoBrew relies on no consent and processes no sensitive data.
- **Your Art. 18 rights:** confirmation, access, correction, anonymisation/blocking/deletion of unnecessary or non-compliant data, portability, deletion of consent-based data, information about sharing and about the consequences of refusing consent, and revocation of consent. Response within **15 days** (Art. 19 § 3).
- **Transfers (Chapter V, Art. 33):** adequacy (EEA, UK, Switzerland) or contractual safeguards for the legs outside them, as set out in § 7.
- **Children (Art. 14):** processing of a child's data (under 12) requires specific and prominent parental consent; no such mechanism is operated — consent-based processing is withheld instead. AutoBrew is not directed at children (§ 11).
- **Incidents (Art. 48):** the ANPD and affected data subjects are notified; our target is 72 hours, aligned with Art. 33 GDPR.
- **Complaints:** Autoridade Nacional de Proteção de Dados — <https://www.gov.br/anpd>. A Portuguese version of this section is available on request.

### 17.8 India (DPDP Act, 2023)

- DigitalFreedom Global LLC is the Data Fiduciary; it is not designated a Significant Data Fiduciary.
- **Consent (§ 6):** free, specific, informed, unconditional and unambiguous, by clear affirmative action, limited to what the purpose needs, withdrawable as easily as given. Service is not conditioned on consent the purpose does not need.
- **Your rights (§§ 11–14):** access to what is processed and with whom it is shared; correction, completion and erasure; grievance redressal; and nomination of another person to exercise your rights in case of death or incapacity.
- **Grievance Officer (§ 8(10), IT Rules 2021):** **Marcel R. G. Berger**, `data-protection@digitalfreedom.co.za`. Acknowledgement within 24 hours; resolution within 15 days, extended to 30 for complex grievances with explanation. Escalation: the Data Protection Board of India, once constituted.
- **Children (§ 9):** data of a person under 18 is processed only with verifiable parental or guardian consent; no tracking, behavioural monitoring or targeted advertising directed at children.
- **Transfers (§ 16):** permitted save to destinations notified as restricted; none of the destinations used (EEA, UK, Switzerland, US) is currently restricted.
- Notices are available in English; a Hindi or other Eighth-Schedule-language version can be requested at `hello@digitalfreedom.co.za`.

### 17.9 Japan (APPI)

- The APPI applies to a foreign operator that acquires personal information in connection with supplying goods or services to persons in Japan; this Service is therefore covered.
- **Purpose specification:** the purpose of use is specified as narrowly as possible and notified or published at acquisition. A change of purpose is limited to what remains relevantly connected to the original purpose; a larger change requires fresh consent.
- **Third-party provision, and provision to third parties in a foreign country:** provision to a third party requires your consent as a rule. For a third party in a foreign country, consent is obtained only after providing you with **(1) the name of the country, (2) information on that country's personal-information protection system, and (3) the measures the recipient takes to protect personal information.** AutoBrew provides no personal information to a third party; it has no AI feature and sends nothing to OpenAI or any other recipient.
- **Publicly available matters (Art. 32):** the operator's name and address and its representative's name, the purposes of use, the procedures for disclosure requests and the complaint contact are kept in your reach — through this Policy and the Imprint (in AutoBrew under Settings → Legal → Imprint). Representative: **Marcel R. G. Berger**.
- **Breach reporting:** for the reportable categories, a preliminary report to the Personal Information Protection Commission within roughly 3–5 days and a final report within 30 days (60 for breaches caused by wrongful access); you are notified. Our internal plan runs on the shortest applicable deadline.
- No advertising email is sent (特定電子メール法 — opt-in, sender identification, unsubscribe — would otherwise apply).

### 17.10 Korea (PIPA)

- PIPA applies to a foreign operator processing personal information in the course of offering goods or services to data subjects in Korea; this Service is therefore covered.
- **Itemised, separated consent:** consent is obtained separately per item, with required and optional items distinguished; refusing an optional item never blocks the service; each request states the items collected, the purpose, the retention period, your right to refuse and the consequence of refusal. AutoBrew currently asks for no consent, because it collects no optional item.
- **Cross-border transfer:** transferring personal information abroad requires notice of **the recipient, the destination country, the date and method of transfer, the items transferred, the recipient's purpose and retention period**, and your separate consent. AutoBrew has no AI feature and makes no such transfer to OpenAI or any other recipient; what you send to support is processed as set out in § 6 and § 7.
- **Under 14:** processing a child's data requires the legal representative's consent, with only the minimum information collected to verify it. No app is directed at children; AutoBrew collects no data from its users other than what they send to support.
- **Response period:** access, correction/deletion and suspension requests are acted on within **10 days**, or you are told the reason and schedule. That is shorter than the GDPR month, and the shorter period governs.
- **Breach:** you are notified without delay; above the statutory scale, the Personal Information Protection Commission or the designated agency is notified within **72 hours**.

### 17.11 Türkiye (KVKK)

- The KVKK (Law No. 6698) resembles the GDPR in concept but leans harder on explicit consent as the general basis; each processing activity is assessed against Turkish law separately rather than assumed to carry over from an Art. 6(1)(f) analysis.
- **Transfers abroad:** AutoBrew has no AI feature and no transfer that relies on your explicit consent; any transfer abroad would be made only on a basis the KVKK recognises, which for a transfer resting on consent is your **explicit consent**, given after the transfer is disclosed to you.
- **Response period:** requests are answered within **30 days**. You may complain to the Kişisel Verileri Koruma Kurumu after applying to us first — within 30 days of our response or 60 days of your application.
- The Turkish version of the published documents governs for consumers resident in Türkiye.

### 17.12 South Africa (POPIA)

POPIA § 3(1) applies to a responsible party domiciled in the Republic, or processing by means located there. Neither is the case — the Controller is domiciled in Wyoming and processes on servers in Frankfurt and London, with an off-provider backup copy on Storj storage nodes in the EU (§ 7), and a `.co.za` domain name is a name, not a processing means. **The Act therefore does not apply on the present facts.** Every POPIA-style enquiry is nonetheless answered through the same channels and on the same clock as everywhere else — a service commitment, not an admission that the Act applies. Two points where POPIA would differ from the GDPR floor, stated rather than papered over: POPIA treats everyone under 18 as a child, and § 22(1) requires breach notification without the GDPR's high-risk threshold — the breach plan operates on the GDPR standard. The Information Regulator: JD House, 27 Stiemens Street, Braamfontein, Johannesburg, 2001 — <https://inforegulator.org.za>.

### 17.13 All other countries

Everywhere AutoBrew is available and no section above applies: the GDPR baseline of this Policy is your floor (§ 1.2), any more protective mandatory local law prevails over it, and every request goes through `data-protection@digitalfreedom.co.za` or <https://data-protection.digitalfreedom.co.za>.

---

(c) 2025-2026 DigitalFreedom Global LLC. All rights reserved.
