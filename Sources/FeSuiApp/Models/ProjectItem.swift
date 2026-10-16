import Foundation

/// 项目卡片数据。
struct ProjectItem: Identifiable {
    let id = UUID()
    let name: String
    let desc: String
    let tags: [String]
    /// 有链接即可点击跳转；为 nil 表示「规划中」。
    let url: URL?
}

/// 项目页数据源（与线上主页一致）。
enum ProjectsData {
    static let all: [ProjectItem] = [
        ProjectItem(
            name: "红石自动化实验室",
            desc: "基于 Minecraft 红石与真实电路原理的自动化演示",
            tags: ["Minecraft"],
            url: nil
        ),
        ProjectItem(
            name: "终端工具箱",
            desc: "一组零依赖的命令行小工具",
            tags: ["CLI"],
            url: nil
        ),
        ProjectItem(
            name: "静态站点生成器",
            desc: "纯前端、无构建步骤的极简建站方案",
            tags: ["Web"],
            url: nil
        ),
        ProjectItem(
            name: "数据可视化",
            desc: "用原生 Canvas / SVG 讲故事",
            tags: ["Chart"],
            url: nil
        ),
        ProjectItem(
            name: "FKD 服务器主页",
            desc: "FKD 游戏服务器官方网站",
            tags: ["Minecraft", "服务器"],
            url: ExternalLinks.fkdServer
        )
    ]
}
