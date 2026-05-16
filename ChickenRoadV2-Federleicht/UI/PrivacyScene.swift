import SwiftUI

struct PrivacyScene: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HenFrame(perch: AppConfig.policyURL, hatchling: true)

            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.black.opacity(0.55)))
            }
            .padding(.top, 8)
            .padding(.trailing, 12)
        }
    }
}
