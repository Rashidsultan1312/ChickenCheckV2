import Foundation

enum AppConfig {
    static let coopAnchor = URL(string: "https://keitaro-zaglushka.com")!
    static let policyURL = URL(string: "https://hallowtommy.github.io/federleicht-privacy")!
    static let supportMail = "support@federleicht.app"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(mv) (\(bn))"
    }

    static var displayName: String {
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String { return name }
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
}
