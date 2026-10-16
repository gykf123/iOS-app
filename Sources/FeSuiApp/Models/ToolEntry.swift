import Foundation

/// 工具页入口（点开后用 App 内 WKWebView 全屏打开）。
struct ToolEntry: Identifiable, Hashable {
    let id = UUID()
    let emoji: String
    let title: String
    let desc: String
    let url: URL
}

/// 工具页数据源（与线上主页一致）。
enum ToolsData {
    static let all: [ToolEntry] = [
        ToolEntry(
            emoji: "⛏️",
            title: "矿石查找器",
            desc: "基岩版矿石分布预测：输入种子号，可视化各高度层的矿物概率。",
            url: URL(string: "https://fesui.xn--0iv.gay/tool/ore-finder.html")!
        ),
        ToolEntry(
            emoji: "🧭",
            title: "MC 搜索",
            desc: "minecraftsearch.com 功能复刻：种子 / 矿石 / 结构 / 群系查找等 9 款工具，Java + 基岩双版，WASM 本地运行。",
            url: URL(string: "https://fesui.xn--0iv.gay/tool/minecraft-search/index.html")!
        ),
        ToolEntry(
            emoji: "🏰",
            title: "FKD 服务器",
            desc: "FKD 游戏服务器官方网站。",
            url: ExternalLinks.fkdServer
        )
    ]
}
