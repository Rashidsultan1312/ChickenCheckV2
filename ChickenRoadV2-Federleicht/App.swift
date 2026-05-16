import SwiftUI

@main
struct CompanionApp: App {
    @StateObject private var coop = CoopJournal.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coop)
                .preferredColorScheme(.light)
                .tint(AppColor.warmOrange)
        }
    }
}
