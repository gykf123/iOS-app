import Foundation

/// Supabase 后端配置。
/// anon / publishable key 属于设计上可公开的密钥（RLS 已限制其权限），与网页端做法一致。
enum SupabaseConfig {
    static let baseURL = "https://yowwyasttkywyqgseuqz.supabase.co"
    static let anonKey = "sb_publishable_j4rpi2ejPTMGxo79uaaX3g_kQYrinS4"
    static let guestbookTable = "guestbook"
    static let guestbookPath = "/rest/v1/\(guestbookTable)"
    /// 昵称为空时落库的默认昵称。
    static let defaultNickname = "匿名访客"
    /// 读取条数上限。
    static let fetchLimit = 100
}
