import SwiftUI
import WebKit

/// 全屏网页容器：WKWebView 的 SwiftUI 封装 + 加载进度 + 关闭按钮。
struct WebViewScreen: View {
    let url: URL
    let title: String

    @Environment(\.dismiss) private var dismiss
    @StateObject private var loadingState = WebViewLoadingState()

    var body: some View {
        VStack(spacing: 0) {
            if loadingState.isLoading {
                ProgressView()
                    .progressViewStyle(.linear)
                    .padding(.top, 4)
            }
            WebView(url: url, loadingState: loadingState)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("关闭", systemImage: "xmark")
                }
            }
        }
    }
}

/// WebView 加载状态（由 WKNavigationDelegate 回调驱动）。
final class WebViewLoadingState: ObservableObject {
    @Published var isLoading = true
}

/// WKWebView 的 UIViewRepresentable 封装。
/// - http(s) 链接在 App 内直接加载；
/// - mailto:、tel: 等其它 scheme 转交系统 App 处理。
struct WebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var loadingState: WebViewLoadingState

    func makeCoordinator() -> Coordinator {
        Coordinator(loadingState: loadingState)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        let loadingState: WebViewLoadingState

        init(loadingState: WebViewLoadingState) {
            self.loadingState = loadingState
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loadingState.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loadingState.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            loadingState.isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            loadingState.isLoading = false
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            let scheme = url.scheme?.lowercased() ?? ""
            if scheme == "http" || scheme == "https" {
                // http(s) 链接在 App 内打开
                decisionHandler(.allow)
            } else if UIApplication.shared.canOpenURL(url) {
                // 其它 scheme（mailto:、tel: 等）转交系统处理
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}
