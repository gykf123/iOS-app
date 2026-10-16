import SwiftUI

/// 卡片内小节标题（品牌色图标 + 文字）。
struct SectionTitle: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label {
            Text(title)
                .font(.headline)
        } icon: {
            Image(systemName: systemImage)
                .foregroundColor(Theme.brand)
        }
    }
}
