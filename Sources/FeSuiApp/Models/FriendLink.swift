import Foundation

/// 友链数据。
struct FriendLink: Identifiable {
    let id = UUID()
    let name: String
    let desc: String
    let url: URL
}

/// 友链页数据源（与线上主页一致）。
enum FriendsData {
    static let all: [FriendLink] = [
        FriendLink(
            name: "白鹿原嚒",
            desc: "技术博客与开源项目分享，Minecraft 玩家的自留地。",
            url: URL(string: "https://blym.top/")!
        ),
        FriendLink(
            name: "MCJS",
            desc: "网页版 Minecraft 最佳中文版，无需下载即可在浏览器里游玩。",
            url: URL(string: "https://mcjs.link")!
        )
    ]
}
