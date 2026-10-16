import Foundation

/// 留言墙条目（对应 Supabase `guestbook` 表）。
///
/// 实测表结构：`{ id: Int, content: String, nickname: String?, user_id: null, created_at: String }`，
/// `created_at` 形如 `2026-10-16T14:30:00+00:00`（可能带小数秒）。
struct Message: Identifiable, Decodable {
    let id: Int
    let content: String
    /// 昵称可为空，展示时回退为「匿名访客」。
    let nickname: String?
    /// 服务端原始时间字符串。
    let createdAtRaw: String

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case nickname
        case createdAtRaw = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        createdAtRaw = try container.decode(String.self, forKey: .createdAtRaw)
    }

    /// 展示用昵称：空值回退「匿名访客」。
    var displayNickname: String {
        guard let nickname, !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "匿名访客"
        }
        return nickname
    }

    /// 解析后的时间（兼容带 / 不带小数秒两种 ISO8601 格式）。
    var createdAt: Date? {
        Self.formatterWithFractionalSeconds.date(from: createdAtRaw)
            ?? Self.formatterPlain.date(from: createdAtRaw)
    }

    /// 形如「10-16 22:30」的展示时间；解析失败返回空串。
    var displayTime: String {
        guard let date = createdAt else { return "" }
        return Self.displayFormatter.string(from: date)
    }

    private static let formatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let formatterPlain: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter
    }()
}
