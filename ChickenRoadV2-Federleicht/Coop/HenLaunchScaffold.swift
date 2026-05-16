import SwiftUI

struct HenLaunchScaffold<Yard: View>: View {
    @AppStorage("cc.coop.latched") private var latched = false
    @State private var pulse: Pulse = .roosting
    @State private var coopOpen = false
    @ViewBuilder var yard: () -> Yard

    var body: some View {
        Group {
            if latched {
                yard()
            } else {
                switch pulse {
                case .roosting:
                    ZStack {
                        AppColor.cream.ignoresSafeArea()
                        ProgressView()
                            .tint(AppColor.warmOrange)
                            .scaleEffect(1.3)
                    }
                    .task { await wake() }
                case .roused(let url):
                    HenFrame(perch: url, hatchling: false)
                        .ignoresSafeArea()
                case .nesting:
                    AppColor.cream.ignoresSafeArea()
                        .fullScreenCover(isPresented: $coopOpen) {
                            HenConsentPanel(perch: AppConfig.policyURL) {
                                latched = true
                                coopOpen = false
                                pulse = .free
                            }
                        }
                case .free:
                    yard()
                }
            }
        }
    }

    @MainActor
    private func wake() async {
        async let nap: Void = { try? await Task.sleep(nanoseconds: 1_500_000_000) }()
        async let signal = CoopLedger.cluck()
        let read = await signal
        _ = await nap
        switch read {
        case .roused(let url):
            pulse = .roused(url)
        case .nesting:
            pulse = .nesting
            Task { @MainActor in coopOpen = true }
        case .dusk:
            pulse = .free
        }
    }

    private enum Pulse: Equatable {
        case roosting
        case roused(URL)
        case nesting
        case free
    }
}
