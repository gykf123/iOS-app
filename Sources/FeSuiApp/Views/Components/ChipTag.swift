import SwiftUI

/// 小标签（chips / 项目 tags 通用）。
struct ChipTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .foregroundColor(Theme.brand)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Theme.brand.opacity(0.12), in: Capsule())
    }
}
