import SwiftUI

/// 头像：优先网络加载，失败回退为首字母圆形占位（ZStack + Circle + Text）。
struct AvatarView: View {
    let urlString: String
    let fallbackText: String
    var size: CGFloat = 72

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                fallback
            case .empty:
                fallback
            @unknown default:
                fallback
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Theme.brand.opacity(0.35), lineWidth: 2)
        )
    }

    /// 首字母占位。
    private var fallback: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Theme.brand, Theme.brand.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(fallbackText)
                .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(urlString: SiteContent.avatarURLString, fallbackText: "F")
    }
}
