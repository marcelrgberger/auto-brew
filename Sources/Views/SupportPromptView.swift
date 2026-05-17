import AppKit
import SwiftUI

struct SupportPromptView: View {
    let stage: SupportStage
    let onStar: () -> Void
    let onSponsor: () -> Void
    let onLater: () -> Void
    let onAlreadyDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.pink)
                .padding(.top, 8)

            Text("Gefällt dir AutoBrew?")
                .font(.title2)
                .fontWeight(.semibold)

            Text("AutoBrew ist kostenlos und Open Source. Wenn dir die App hilft, freue ich mich über deine Unterstützung — kostet dich nichts.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            VStack(spacing: 10) {
                Button(action: onStar) {
                    Label("Stern auf GitHub geben", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button(action: onSponsor) {
                    Label("Auf GitHub Sponsors unterstützen", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.pink)

                Button("Vielleicht später", action: onLater)
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(.top, 4)

            Button("Hab ich schon gemacht", action: onAlreadyDone)
                .buttonStyle(.link)
                .font(.caption)
                .padding(.top, 2)
        }
        .padding(28)
        .frame(width: 380)
        .interactiveDismissDisabled(true)
        .accessibilityIdentifier("SupportPromptView.\(stage.rawValue)")
    }
}

#Preview {
    SupportPromptView(
        stage: .week,
        onStar: {},
        onSponsor: {},
        onLater: {},
        onAlreadyDone: {}
    )
}
