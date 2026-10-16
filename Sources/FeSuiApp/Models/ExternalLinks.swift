import Foundation

/// 站外链接集中配置（中文域名使用 punycode 形式，iOS 可直接打开）。
enum ExternalLinks {
    /// FKD 游戏服务器官网（「FKD.是.gay」）。
    static let fkdServer = URL(string: "https://fkd.xn--0iv.gay")!

    /// 构造 mailto: 链接。
    static func mailto(_ address: String) -> URL {
        URL(string: "mailto:\(address)")!
    }
}
