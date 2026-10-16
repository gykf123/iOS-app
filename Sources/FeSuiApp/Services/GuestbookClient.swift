import Foundation

/// 留言墙网络客户端：直连 Supabase REST API，匿名读写（无第三方依赖）。
final class GuestbookClient {
    static let shared = GuestbookClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        session = URLSession(configuration: configuration)
        decoder = JSONDecoder()
        encoder = JSONEncoder()
    }

    /// 拉取最新留言（按 created_at 倒序，最多 100 条）。
    func fetchMessages() async throws -> [Message] {
        var components = URLComponents(string: SupabaseConfig.baseURL)
        components?.path = SupabaseConfig.guestbookPath
        components?.queryItems = [
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "\(SupabaseConfig.fetchLimit)")
        ]
        guard let url = components?.url else {
            throw GuestbookError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        applyCommonHeaders(to: &request)

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try decoder.decode([Message].self, from: data)
    }

    /// 发布一条留言；昵称为空时落库为「匿名访客」。
    func postMessage(nickname: String, content: String) async throws {
        var components = URLComponents(string: SupabaseConfig.baseURL)
        components?.path = SupabaseConfig.guestbookPath
        guard let url = components?.url else {
            throw GuestbookError.invalidURL
        }

        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let payload = GuestbookInsertPayload(
            content: content,
            nickname: trimmedNickname.isEmpty ? SupabaseConfig.defaultNickname : trimmedNickname
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(payload)
        applyCommonHeaders(to: &request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await session.data(for: request)
        try validate(response)
    }

    /// 公共请求头：apikey + Bearer 鉴权。
    private func applyCommonHeaders(to request: inout URLRequest) {
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPSURLResponse else {
            throw GuestbookError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw GuestbookError.httpStatus(httpResponse.statusCode)
        }
    }
}

/// 发布留言的 JSON 结构。
private struct GuestbookInsertPayload: Encodable {
    let content: String
    let nickname: String
}

/// 留言墙错误。
enum GuestbookError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "请求地址无效。"
        case .invalidResponse:
            return "服务器响应异常。"
        case .httpStatus(let code):
            return "服务器返回状态码 \(code)。"
        }
    }
}
