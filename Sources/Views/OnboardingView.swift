import SwiftUI

struct OnboardingView: View {
    @State private var brewManager = BrewManager.shared
    @State private var settings = SettingsStore.shared
    @State private var step: OnboardingStep = .welcome
    @State private var launchAtLogin = true
    @State private var isInstalling = false
    @State private var installError: String?
    var onComplete: () -> Void

    enum OnboardingStep {
        case welcome
        case brewCheck
        case done
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "mug.fill")
                .font(.system(size: 40))
                .foregroundStyle(.brown)
                .padding(.top, 8)

            Text("Welcome to AutoBrew")
                .font(.headline)

            Divider()

            Group {
                switch step {
                case .welcome:
                    welcomeStep
                case .brewCheck:
                    brewCheckStep
                case .done:
                    doneStep
                }
            }
            .animation(.easeInOut(duration: 0.3), value: step)

            Divider()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
            }
        }
        .padding()
        .frame(width: 280)
    }

    // MARK: - Step 1: Welcome

    private var welcomeStep: some View {
        VStack(spacing: 12) {
            Text("AutoBrew keeps your Homebrew packages up to date automatically in the background.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)

            Toggle("Launch at Login", isOn: $launchAtLogin)
                .padding(.horizontal, 4)

            Text("You can change this later in Settings.")
                .font(.caption2)
                .foregroundStyle(.tertiary)

            Button {
                LoginItemManager.setEnabled(launchAtLogin)
                settings.loginItemEnabled = launchAtLogin
                step = .brewCheck
            } label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.system(.body, weight: .semibold))
                    Spacer()
                }
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
        }
        .transition(.push(from: .trailing))
    }

    // MARK: - Step 2: Homebrew Check

    private var brewCheckStep: some View {
        VStack(spacing: 12) {
            if brewManager.isHomebrewInstalled {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.green)

                Text("Homebrew is installed")
                    .font(.callout)

                if let path = brewManager.brewExecutable {
                    Text(path)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Button {
                    step = .done
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.system(.body, weight: .semibold))
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)

            } else if isInstalling {
                ProgressView()
                    .controlSize(.large)

                if let stage = brewManager.currentStage {
                    Text(stage.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text("This may take a few minutes...")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

            } else if let error = installError {
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

            } else {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28))
                    .foregroundStyle(.orange)

                Text("Homebrew is not installed")
                    .font(.callout)

                Text("AutoBrew needs Homebrew to manage your packages.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

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
        .transition(.push(from: .trailing))
        .animation(.easeInOut(duration: 0.3), value: isInstalling)
        .animation(.easeInOut(duration: 0.3), value: installError != nil)
        .animation(.easeInOut(duration: 0.3), value: brewManager.isHomebrewInstalled)
    }

    // MARK: - Step 3: Done

    private var doneStep: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.green)
                .symbolEffect(.bounce, value: step)

            Text("You're all set!")
                .font(.callout)
                .fontWeight(.semibold)

            Text("AutoBrew will run in the background and keep your packages up to date.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                settings.onboardingCompleted = true
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
        .transition(.push(from: .trailing))
    }

    private func install() {
        isInstalling = true
        installError = nil
        Task {
            do {
                try await brewManager.installHomebrew()
                step = .done
            } catch {
                installError = error.localizedDescription
            }
            isInstalling = false
        }
    }
}
