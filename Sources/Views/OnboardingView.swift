import SwiftUI

struct OnboardingView: View {
    @State private var brewManager = BrewManager.shared
    @State private var isInstalling = false
    @State private var installError: String?
    @State private var installComplete = false
    var onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: "mug.fill")
                .font(.system(size: 40))
                .foregroundStyle(.brown)
                .padding(.top, 8)

            Text("Welcome to AutoBrew")
                .font(.headline)

            Text("AutoBrew keeps your Homebrew packages up to date automatically in the background.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Divider()

            if installComplete {
                // Success state
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: installComplete)

                    Text("Homebrew installed successfully!")
                        .font(.callout)
                        .foregroundStyle(.green)

                    Button {
                        onComplete()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Get Started")
                                .font(.system(.body, weight: .semibold))
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .transition(.push(from: .bottom).combined(with: .opacity))

            } else if isInstalling {
                // Installing state
                VStack(spacing: 12) {
                    ProgressView()
                        .controlSize(.large)

                    if let stage = brewManager.currentStage {
                        Text(stage.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .contentTransition(.numericText())
                    }

                    Text("This may take a few minutes...")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .transition(.opacity)

            } else if let error = installError {
                // Error state
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.red)

                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .lineLimit(3)

                    Button {
                        installError = nil
                    } label: {
                        Label("Try Again", systemImage: "arrow.clockwise")
                    }
                }
                .transition(.opacity)

            } else {
                // Initial state — Homebrew not found
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.orange)
                        Text("Homebrew is not installed")
                            .font(.callout)
                    }

                    Text("AutoBrew needs Homebrew to manage your packages. Click below to install it automatically.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)

                    Button {
                        install()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Install Homebrew", systemImage: "arrow.down.circle")
                                .font(.system(.body, weight: .semibold))
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Link(destination: URL(string: "https://brew.sh")!) {
                        Text("What is Homebrew?")
                            .font(.caption2)
                    }
                }
            }

            Divider()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
            }
        }
        .padding()
        .frame(width: 280)
        .animation(.easeInOut(duration: 0.3), value: isInstalling)
        .animation(.easeInOut(duration: 0.3), value: installComplete)
        .animation(.easeInOut(duration: 0.3), value: installError != nil)
    }

    private func install() {
        isInstalling = true
        installError = nil
        Task {
            do {
                try await brewManager.installHomebrew()
                installComplete = true
            } catch {
                installError = error.localizedDescription
            }
            isInstalling = false
        }
    }
}
