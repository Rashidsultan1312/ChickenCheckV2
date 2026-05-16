import SwiftUI

struct HenConsentPanel: View {
    let perch: URL
    let onLatch: () -> Void
    @State private var locked = false

    var body: some View {
        ZStack {
            AppColor.cream.ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColor.navyText)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.navyText.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                }
                .padding(.top, 30)

                HenFrame(perch: perch, hatchling: true)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AppColor.warmOrange.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)

                Button(action: { locked.toggle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: locked ? "checkmark.seal.fill" : "seal")
                            .font(.system(size: 22))
                            .foregroundStyle(locked ? AppColor.warmOrange : AppColor.navyText.opacity(0.5))
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppColor.navyText)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppColor.warmOrange.opacity(0.18), lineWidth: 0.5)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 18)

                Button(action: onLatch) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(AppColor.warmOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!locked)
                .opacity(locked ? 1 : 0.4)
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
