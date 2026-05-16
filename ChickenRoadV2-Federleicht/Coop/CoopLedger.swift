import Foundation
import UIKit
@preconcurrency import WebKit

enum HenSignal: Equatable {
    case roused(URL)
    case nesting
    case dusk
}

enum CoopLedger {
    @MainActor
    static func cluck() async -> HenSignal {
        await PerchProbe().peep()
    }

    static func strip(_ url: URL) -> String {
        var bag = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
        bag.fragment = nil
        if let s = bag.scheme { bag.scheme = s.lowercased() }
        if let h = bag.host { bag.host = h.lowercased() }
        var p = bag.path
        while p.count > 1 && p.hasSuffix("/") { p.removeLast() }
        bag.path = p
        return bag.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class PerchProbe: NSObject, WKNavigationDelegate {
    private var hatch: CheckedContinuation<HenSignal, Never>?
    private var nest: WKWebView?
    private var fastened = false
    private var sundial: Task<Void, Never>?

    func peep() async -> HenSignal {
        await withCheckedContinuation { box in
            hatch = box
            let setup = WKWebViewConfiguration()
            setup.websiteDataStore = .nonPersistent()
            let pane = WKWebView(frame: CGRect(x: 0, y: 0, width: 4, height: 4), configuration: setup)
            pane.alpha = 0.02
            pane.navigationDelegate = self
            pane.load(URLRequest(url: AppConfig.coopAnchor))
            nest = pane
            sundial = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                await MainActor.run { self?.settle(.dusk) }
            }
        }
    }

    private func settle(_ signal: HenSignal) {
        if fastened { return }
        fastened = true
        sundial?.cancel()
        nest?.navigationDelegate = nil
        nest?.stopLoading()
        nest = nil
        hatch?.resume(returning: signal)
        hatch = nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = navigationAction.request.url else {
            decisionHandler(.allow); return
        }
        let origin = AppConfig.coopAnchor
        if CoopLedger.strip(target) != CoopLedger.strip(origin) {
            decisionHandler(.cancel)
            settle(.roused(target))
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            guard let self = self, !self.fastened else { return }
            self.settle(.nesting)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error; settle(.dusk)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error; settle(.dusk)
    }
}
