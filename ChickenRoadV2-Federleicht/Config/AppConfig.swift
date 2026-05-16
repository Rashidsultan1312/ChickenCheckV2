import Foundation

enum AppConfig {
    static let coopAnchor = URL(string: "https://muntriva.com/F5q1xY")!
    static let policyURL = URL(string: "https://www.termsfeed.com/live/0acaa634-6236-4875-b18e-2b4e11f72cec")!
    static let supportMail = "jamnabilsi@icloud.com"

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
