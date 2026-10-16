import Foundation

/// 首页静态文案与站点常量（与线上主页保持一致）。
enum SiteContent {
    static let name = "FeSui"
    static let identity = "极客人格 · Geek ／ Minecraft 玩家"
    static let chips = ["代码", "红石", "自动化", "沙盒"]

    static let aboutParagraphs: [String] = [
        "我在红石电路与代码逻辑的交界处游走——既会在 Minecraft 里用方块搭出真实的电路，也会在终端前用脚本把重复劳动交给机器。不执拗，也不将就：每一座方块、每一行代码，都该有它存在的道理。",
        "世界是开放的沙盒，而我乐此不疲地编辑它。"
    ]

    static let quotes: [String] = [
        "在红石电路与代码逻辑的交界，我既是建筑师，也是工程师。",
        "不执拗，也不将就——每一座方块、每一行代码，都该有它的道理。",
        "世界是开放的沙盒，而我乐此不疲地编辑它。"
    ]

    static let email = "fesui_a@sina.com"

    /// 头像地址（线上主页同款）。
    static let avatarURLString = "https://fesui.xn--0iv.gay/avatar.png"
}
