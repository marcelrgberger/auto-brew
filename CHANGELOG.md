# Changelog

All notable changes to AutoBrew are recorded here, newest first. Format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); version
numbers follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
with the project-specific convention that new macOS major-version
support counts as a **minor** bump (not a patch).

The release workflow extracts the section matching the current
`MARKETING_VERSION` from this file and uses it as the GitHub Release body
and the Sparkle update dialog's release notes — keep entries short,
user-facing, and free of internal jargon.

## [Unreleased]

## [2.5.1] — 2026-05-26

### Fixed
- **Collections view layout.** The Collections sidebar entry rendered with a second, nested sidebar inside the BrewStore detail pane — on narrow window widths the inner list was squashed to a few pixels and the "No collection selected" placeholder got clipped. Replaced the inner `NavigationSplitView` with a flat `HStack` split so Collections now looks consistent with the other BrewStore sections (Orphans, Doctor, Update History).
- **Homebrew tap cask** declares `uninstall delete: "#{HOMEBREW_PREFIX}/bin/autobrew"` so upgrades and reinstalls clean up the `autobrew` CLI symlink even when the source `.app` has already been moved to the Caskroom backup. Before this fix, brew aborted mid-upgrade with `It seems the symlink source '/Applications/AutoBrew.app/Contents/Helpers/autobrew' is not there`. The change is in the [tap repo](https://github.com/marcelrgberger/homebrew-tap) and reached users on the next `brew update`.

## [2.5.0] — 2026-05-26

### Added
- Pre-upgrade snapshots are now disk-pressure-aware: when the home-directory volume has less than the configured threshold (default 10 GiB) free, the snapshot is skipped for that cask and a notification surfaces the reason. The upgrade itself still runs — only the History row's rollback button is unavailable for that single run.
- Widget large family now carries a **Run Now** link that triggers an immediate `brew update → upgrade → cleanup` cycle through the host app, alongside the existing Roll Back link. Uses the new `autobrew://run-now` URL scheme.
- **Selective restore per component.** The Roll Back action in the Update History view now opens a sheet with a checkbox list of every component the snapshot recorded (Preferences, Containers, Application Support, etc.) with its size. Restore exactly the folders you want; the rest of the live state stays untouched. Defaults to "everything selected" so the previous all-or-nothing behaviour is one Roll Back click away when that's what you want.
- **CHANGELOG-aware Pending Approvals.** Each pending-approval row for a cask whose `homepage` is on github.com now ships with an expandable section showing the upstream GitHub release notes for the incoming version. The fetch is rate-limit-friendly (per-cask disk cache, 7-day TTL, fallback to `/releases/latest` when no version-tagged release exists). Decisions stop being blind.
- **Pre-snapshot hooks per cask.** The per-package override sheet now carries an optional shell command (`/bin/bash -c <command>`, 30 s timeout) that runs right before AutoBrew takes the pre-upgrade snapshot of that cask. Use it to flush in-memory state — `osascript -e 'tell application "X" to save'`, quitting a daemon, syncing a sandbox — so the snapshot captures a quiescent on-disk state. The UI carries a clear warning that the command runs with your user permissions; failure logs but never blocks the upgrade.
- **External snapshot storage.** Settings → Snapshots → **External storage** opens a folder picker; AutoBrew then writes new snapshots into `<picked>/AutoBrew/Snapshots/` instead of the default Application Support path. Handy for parking big snapshots on an external drive or NAS mount. Stored as a security-scoped bookmark so the choice survives unplug/replug.
- **Cask collections.** A new BrewStore sidebar section lets you define named sets of cask tokens ("Dev Setup", "Gaming Setup", "New Laptop") and install or uninstall the whole set with one click. Failures inside a bulk run don't abort the rest — failed tokens get collected and surfaced at the end. Export/import as `.autobrewcollection` JSON for cross-Mac sharing.
- **`autobrew` CLI helper.** A thin terminal command shipped inside `AutoBrew.app/Contents/Helpers/autobrew` and symlinked into the user's PATH by the cask. Subcommands `open`, `install <token>`, `rollback`, `run-now`, `version`, `help` — each one routes through the existing `autobrew://` URL scheme so the running menu-bar app applies the same security checks the URL handler enforces. Out of scope for this first iteration: direct service reuse (would need its own event loop + file locking against the GUI stores).
- **Snapshot diff viewer.** SnapshotDetailView grew a **Compare…** button that opens a picker of other snapshots for the same bundle id, then a side-by-side diff sheet showing added/removed/changed components with size deltas (negative when something shrank). The diff runs straight off the manifest SHA-256 hashes — no extra disk reads against the live filesystem — so it is fast even on multi-GB snapshots.
- **Orphaned formulae cleanup.** A new BrewStore sidebar section **Orphans** runs `brew autoremove --dry-run` to surface dependencies whose parents are gone, then offers a one-click **Remove All** that actually drops them. After the removal it re-runs the probe in case the first pass lifted further orphans (chain dependencies). Your explicit installs are never touched.
- **Brew Doctor section.** New BrewStore sidebar entry **Doctor** runs `brew doctor`, parses its `Warning:` / `Error:` blocks into discrete findings, and renders them grouped by severity with expandable bodies. Surfaces broken installs and missing dependencies *before* they trip the next upgrade.
- **Automatic retry for failed upgrades.** When `brew upgrade --cask <token>` fails inside an auto-update run, the row in Update History now carries an exponential backoff: AutoBrew retries the same cask after **1 h**, then **4 h**, then **12 h** — up to three attempts before the row becomes sticky-failed and only a manual run picks it up again. A 30-minute polling task scans the history for due retries, captures a fresh pre-upgrade snapshot, and runs only the affected casks. The History view shows the next-retry ETA inline and switches to a red "Retries exhausted" badge once the budget is used up. Transient failures (mirror hiccups, brief network blips) now self-heal without you noticing them.

## [2.4.0] — 2026-05-24

### Added
- **Pre-upgrade auto-snapshots** — every automatic cask upgrade now captures a snapshot of the app's user data first, so a broken update can be rolled back in one click from the new Update History view.
- **Update History** sidebar entry in BrewStore lists every auto-upgrade newest-first, with per-cask outcome icons (succeeded / failed / unclear) attributed by a dedicated parser of `brew upgrade --cask` output. Each row that still has its snapshot offers a one-click rollback.
- **One-click rollback from the failed-update notification** — picks the most recent failed cask that still has its pre-upgrade snapshot on disk and offers Roll Back as a destructive notification action.
- **Manual cask upgrades from BrewStore** now take the same pre-upgrade snapshot and create a History row, just like the automatic auto-update path. Per-token in-flight guard rejects double-clicks.
- **Shortcuts.app, Siri and Spotlight** actions — **Install Cask**, **Snapshot App** and **Roll Back Last Cask Upgrade**, all via the system AppIntents framework. No helper app needed.
- **AutoBrew Status widget** for the desktop and Notification Center — three sizes show pending approvals, recent auto-upgrade outcomes with per-cask icons, and a Roll Back link on the large size that triggers the same restore path as the failed-update notification. Reads from an App Group container so the sandboxed widget extension stays decoupled from the main app.
- **Download size shown before installing a cask** — BrewStore's detail view issues a single HTTP HEAD against the DMG URL on appear and renders the size (or "unknown" when the server hides Content-Length).
- **Sparkle delta updates** — each new release ships a `BinaryDelta`-generated patch from the previous build, so the in-app upgrade downloads a fraction of the full ZIP when the user is on the immediately-prior version.
- **Release notes driven by `CHANGELOG.md`** — the same body shows up on the GitHub release page and inside Sparkle's update dialog. No more "see commits for details".
- **ETag-cached cask catalog** — BrewStore's daily background refresh now sends `If-None-Match` and returns 304 Not Modified when nothing changed, saving roughly 50 MB of redundant download per refresh.
- **Automatic Homebrew-tap bump** from the release workflow — every release on `main` updates `marcelrgberger/homebrew-tap` with the new version, sha256 and macOS minimum, so the cask never drifts behind the binary.
- **Upstream `homebrew/cask` submission material** prepared under `docs/homebrew-cask-submission/`. The cask file is linted clean against the upstream rules; the PR is queued for once the project clears the notability threshold.

### Changed
- `UpgradeHistory.json` schema stores a three-state `outcome` field. Files written by an earlier build with `succeeded: Bool` are still readable — your history is not lost on upgrade.

### Fixed
- Release workflow now `codesign`s the `.dmg` container itself with the Developer ID Application identity. Previously only the embedded `.app` was signed + notarised; the `.dmg` carried no usable signature, so Gatekeeper warned on direct double-click of the downloaded DMG and homebrew/cask's audit refused the cask. From this release on, the DMG passes `spctl -a -t open --context context:primary-signature -v` cleanly.

## [2.3.0] — 2026-05-23

### Added
- Platform-adaptive UI through a single `PlatformAdaptive.swift` helper — Liquid Glass on macOS 26, classic materials on macOS 14/15.

### Changed
- Minimum macOS version lowered to 14 (Sonoma); building still requires Xcode 26+.

## [2.2.2] — 2026-05-22

### Fixed
- Snapshots no longer abort on protected container-manager metadata files. A single locked sibling under `~/Library/Containers/` could previously kill the whole snapshot.

## [2.2.1] — 2026-05-21

### Added
- Help, Sponsor and Source Code links in the BrewStore sidebar.

### Fixed
- Bumped GitHub Actions images to v5 for the new Node.js 24 runtime.

## [2.2.0] — 2026-05-21

### Added
- Full Homebrew GUI (BrewStore) with Discover/Categories/Installed/Snapshots/Updates sections.
- AppSnapshot engine — capture, restore, export/import, transactional restore with rollback siblings.

### Changed
- CI reshaped per release channel (development / test / beta / main).

## [2.0.0] — 2025-03-25

### Added
- First public release. Menu-bar app that orchestrates `brew update → outdated → policy gate → upgrade → cleanup` with idle or scheduled triggers, sleep/wake recovery, and a selective per-bump-type update policy.

[Unreleased]: https://github.com/marcelrgberger/auto-brew/compare/v2.4.0...HEAD
[2.4.0]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.4.0
[2.3.0]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.3.0
[2.2.2]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.2.2
[2.2.1]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.2.1
[2.2.0]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.2.0
[2.0.0]: https://github.com/marcelrgberger/auto-brew/releases/tag/v2.0.0
