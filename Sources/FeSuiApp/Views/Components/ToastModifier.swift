import SwiftUI

/// 轻提示（Toast）：底部深色胶囊，约 2 秒后自动消失。
struct ToastModifier: ViewModifier {
    @Binding var message: String?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let message {
                Text(message)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.78), in: Capsule())
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                    .padding(.bottom, 28)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: message)
    }
}

extension View {
    /// 在视图底部弹出轻提示。
    func toast(message: Binding<String?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
