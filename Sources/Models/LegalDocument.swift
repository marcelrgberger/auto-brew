import Foundation
import os

private let legalLogger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Legal")

/// Anchor used by `Bundle(for:)` in the test target. We need a reference type
/// declared in the app target so `Bundle(for: LegalBundleAnchor.self)` resolves
/// to `AutoBrew.app` (where the localized `.md` files live) instead of the
/// `xctest` bundle that hosts the tests.
final class LegalBundleAnchor {}

/// One value per legal document we ship. `filename` is matched against the
/// localized `.md` resources in each `*.lproj` — Bundle's locale fallback then
/// routes the request to the user's language (or to `en.lproj` when missing).
enum LegalDocument: String, CaseIterable, Identifiable, Sendable {
    case privacy
    case californiaNotice
    case terms
    case eula
    case legalFramework
    case supportPolicy
    case securityInformation
    case vulnerabilityDisclosure
    case impressum
    case trademark
    case openSource

    var id: String { rawValue }

    /// Human-facing title; resolved through `Localizable.xcstrings` so each
    /// locale shows its own label in the Settings list and the Legal picker.
    var titleKey: String {
        switch self {
        case .privacy: return "Privacy Policy"
        case .californiaNotice: return "California Notice at Collection"
        case .terms: return "Terms of Use"
        case .eula: return "EULA"
        case .legalFramework: return "Legal Framework Overview"
        case .supportPolicy: return "Support and Update Policy"
        case .securityInformation: return "Security Information"
        case .vulnerabilityDisclosure: return "Vulnerability Disclosure"
        case .impressum: return "Imprint"
        case .trademark: return "Trademark"
        case .openSource: return "Open-Source Licenses"
        }
    }

    /// SF Symbol shown next to the document in the Settings legal hub and
    /// in the Legal window's sidebar.
    var systemImage: String {
        switch self {
        case .privacy: return "hand.raised"
        case .californiaNotice: return "list.bullet.clipboard"
        case .terms: return "doc.text"
        case .eula: return "doc.badge.gearshape"
        case .legalFramework: return "list.number"
        case .supportPolicy: return "clock.arrow.circlepath"
        case .securityInformation: return "lock.shield"
        case .vulnerabilityDisclosure: return "ladybug"
        case .impressum: return "building.columns"
        case .trademark: return "r.square"
        case .openSource: return "shippingbox"
        }
    }

    /// Base name (without extension) under `*.lproj`. CamelCased because
    /// `Bundle.url(forResource:withExtension:)` is case-sensitive on the
    /// filesystem layer that Foundation uses.
    var filename: String {
        switch self {
        case .privacy: return "PrivacyPolicy"
        case .californiaNotice: return "CaliforniaNoticeAtCollection"
        case .terms: return "TermsOfUse"
        case .eula: return "EULA"
        case .legalFramework: return "LegalFrameworkOverview"
        case .supportPolicy: return "SupportAndUpdatePolicy"
        case .securityInformation: return "SecurityInformation"
        case .vulnerabilityDisclosure: return "VulnerabilityDisclosure"
        case .impressum: return "Impressum"
        case .trademark: return "Trademark"
        case .openSource: return "OpenSourceLicenses"
        }
    }

    /// Loads the document for the current locale. Returns a localized
    /// fallback string when the resource is missing so the UI never goes
    /// blank — the logger captures the failure for diagnostics.
    func load(bundle: Bundle = .main) -> String {
        guard let url = bundle.url(forResource: filename, withExtension: "md") else {
            legalLogger.error("LegalDocument: \(self.filename, privacy: .public).md not found in bundle")
            return String(localized: "Document not available.")
        }
        do {
            // Source/version headers and `verbatim` markers are HTML comments
            // for maintaining the documents; MarkdownParser would show them
            // as plain paragraphs, so they are removed before display. An
            // unterminated `<!--` is removed through the end of the text.
            return try String(contentsOf: url, encoding: .utf8)
                .replacingOccurrences(of: #"(?s)<!--.*?(?:-->|\z)"#, with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            legalLogger.error("LegalDocument: failed to read \(self.filename, privacy: .public).md: \(error.localizedDescription, privacy: .public)")
            return String(localized: "Document not available.")
        }
    }
}
