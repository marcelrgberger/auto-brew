<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.3, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.3 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names -->
# SECURITY INFORMATION FOR THIS PRODUCT

## Information and instructions to the user — Annex II, Regulation (EU) 2024/2847 (Cyber Resilience Act)

**Product:** AutoBrew, version 2.5.3 and later
**Applies from:** Annex II of the Cyber Resilience Act applies to products placed on the EU market from
**11 December 2027**, and earlier for any existing product that undergoes a substantial modification.
This information is provided for AutoBrew ahead of that date.

---

## 1. Manufacturer

DigitalFreedom — a brand of DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Single point of contact: hello@digitalfreedom.co.za

## 2. Where to report a vulnerability

Security reports: <https://security.digitalfreedom.co.za> or `security@digitalfreedom.co.za`.
The full process, safe harbour included, is in the Coordinated Vulnerability Disclosure Policy (Settings → Legal → Vulnerability Disclosure);
machine-readable: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Product identification

AutoBrew — `za.co.digitalfreedom.AutoBrew` — a macOS application (macOS 14 or later), distributed directly as a notarized download from GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) and through the Homebrew tap `marcelrgberger/homebrew-tap`.
The installed version is shown in the app's settings in the About section, above the legal hub.

## 4. Intended purpose and essential cybersecurity properties

AutoBrew keeps the Homebrew packages on a Mac up to date according to the update policy the user sets, provides a graphical interface to browse, install, upgrade and remove Homebrew casks, and creates, restores and migrates snapshots of applications' user data. Security properties: no advertising SDK and no advertising identifier; local notifications only;
authentication: none — the app is local-only; data storage: on the device only.

For AutoBrew in particular: the connections AutoBrew opens itself use HTTPS; the download addresses of the packages Homebrew installs are set by their publishers and the Homebrew project. Every release is signed with an Apple Developer ID certificate, notarized by Apple and built with the Hardened Runtime. Updates delivered through the built-in updater (Sparkle) are verified against an EdDSA (Ed25519) signature before they are installed. AutoBrew stores its data on the Mac, or in the snapshot storage location the user chooses; it sends no data to the manufacturer.

## 5. Known or foreseeable circumstances of significant cybersecurity risk

- **AutoBrew runs outside the App Sandbox** because it has to run `brew`, `ditto` and other system tools. It acts with the rights of the logged-in user.
- **Software installed or upgraded through Homebrew** is published by third parties and runs with the user's rights. With automatic upgrades enabled, new versions are installed according to the update policy the user set, without a separate confirmation for each update in the "install automatically" category.
- **Snapshots contain copies of application data**, which can include credentials, tokens or other sensitive information an application keeps in its user-data folders. Snapshots and exported snapshot files are not encrypted by AutoBrew; anyone with access to the snapshot location, an external drive used for it, or an exported file can read them. Automatic snapshots before upgrades are on by default (Settings → Snapshots).
- **Installing Homebrew** from AutoBrew runs the official Homebrew installation script downloaded from GitHub.

None of these is a known vulnerability. Circumstances discovered later are addressed through security updates and, where they meet the Art. 14 thresholds, reported as required.

## 6. EU declaration of conformity

The EU declaration of conformity is required from 11 December 2027 and has not yet been issued for AutoBrew. Once issued, it will be available on request at hello@digitalfreedom.co.za and its location will be stated here.

## 7. Technical support and support period

Security vulnerabilities are handled and security updates are provided **at least until October 2031 for version 2.5.3** (published on GitHub Releases on 15 October 2026), and for each later version at least until the same month five years after that version is published on GitHub Releases.
The general commitment and what "support" includes is in the Support and Update Policy (Settings → Legal → Support and Update Policy). Support requests:
<https://support.apps.digitalfreedom.co.za>.

## 8. Secure use over the product's lifetime

- **Installation and first use:** install only from GitHub Releases at https://github.com/marcelrgberger/auto-brew/releases or through the Homebrew tap `marcelrgberger/homebrew-tap`; macOS verifies the Developer ID signature and the notarization when the app is first opened. No configuration is needed for a secure default — the app has no optional data flow to the manufacturer.
- **Security updates** are delivered through AutoBrew's built-in updater (Settings → Updates → Check for Updates), through the Homebrew tap, or as a new download from GitHub Releases. Keep automatic update checks enabled; if you disable them, check for updates regularly — an outdated version no longer receives fixes.
- **Changes that affect security:** granting OS permissions extends what the app can access; AutoBrew asks for permission to show notifications, and any permission can be revoked in System Settings at any time. Choosing an external snapshot storage location, turning on automatic installation for a package category, and running per-package pre-snapshot commands extend what AutoBrew does on your behalf.
- **Decommissioning:** uninstalling removes the app. To remove its local data, delete the folders listed in the Privacy Policy, Section 3.6, including an external snapshot location you chose and any exported snapshot files. AutoBrew has no account and keeps no data on the manufacturer's servers.

## 9. Software bill of materials

No SBOM is published for AutoBrew. Third-party components and their licences are listed in the Open-Source Licenses document (Settings → Legal → Open-Source Licenses).
