import SwiftUI

/// 全局主题：品牌色、背景、文字、圆角与卡片样式。
/// 颜色统一使用 UIColor 动态 provider，深浅色模式自动适配（不依赖 asset catalog）。
enum Theme {
    /// 品牌主色：浅色 #4F7CFF，深色模式提亮为 #8FB2FF。
    static let brand = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0x8F / 255.0, green: 0xB2 / 255.0, blue: 0xFF / 255.0, alpha: 1)
            : UIColor(red: 0x4F / 255.0, green: 0x7C / 255.0, blue: 0xFF / 255.0, alpha: 1)
    })

    /// 页面背景：浅色为柔和蓝白，深色为近黑。
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1)
            : UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1)
    })

    /// 卡片描边色。
    static let cardStroke = Color.primary.opacity(0.08)

    /// 次要文字色。
    static let secondaryText = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 0.62, alpha: 1)
            : UIColor(white: 0.42, alpha: 1)
    })

    /// 卡片圆角。
    static let cornerRadius: CGFloat = 18

    private init() {}
}

/// 轻盈「玻璃感」卡片：半透明材质 + 淡阴影 + 细描边。
struct GlassCardModifier: ViewModifier {
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .stroke(Theme.cardStroke, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

extension View {
    /// 套用玻璃感卡片样式。
    func glassCard(padding: CGFloat = 16) -> some View {
        modifier(GlassCardModifier(padding: padding))
    }
}
