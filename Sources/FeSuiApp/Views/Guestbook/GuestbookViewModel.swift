import Foundation

/// 留言墙视图模型：直连 Supabase REST，匿名发布，无登录门禁。
@MainActor
final class GuestbookViewModel: ObservableObject {
    /// 列表加载状态。
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        /// 加载失败（文案与网页端一致）。
        case failed(String)
    }

    @Published private(set) var messages: [Message] = []
    @Published private(set) var loadState: LoadState = .idle
    @Published private(set) var isPublishing = false
    @Published var toastMessage: String?

    /// 昵称输入（选填，最多 30 字）。
    @Published var nickname = ""
    /// 内容输入（必填，最多 500 字）。
    @Published var content = ""

    let maxNicknameLength = 30
    let maxContentLength = 500

    private let client = GuestbookClient.shared

    /// 内容非空且当前没有发布任务时才允许发布。
    var canPublish: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isPublishing
    }

    /// 拉取留言列表。
    func load() async {
        loadState = .loading
        do {
            messages = try await client.fetchMessages()
            loadState = .loaded
        } catch {
            messages = []
            // 与网页端一致：拉取失败统一提示等待主人配置数据库
            loadState = .failed("留言墙尚未开启，等待主人配置数据库。")
        }
    }

    /// 发布留言：成功后清空表单并刷新列表。
    func publish() async {
        guard canPublish else { return }
        isPublishing = true
        defer { isPublishing = false }
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            try await client.postMessage(nickname: nickname, content: trimmedContent)
            nickname = ""
            content = ""
            await load()
            toastMessage = "发布成功"
        } catch {
            toastMessage = "发布失败，请稍后再试"
        }
    }
}
