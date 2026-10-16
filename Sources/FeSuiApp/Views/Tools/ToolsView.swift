import SwiftUI

/// Tab 5：工具 —— 三个入口，点开用 App 内 WKWebView 全屏打开。
struct ToolsView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(ToolsData.all) { entry in
                    NavigationLink(value: entry) {
                        toolCard(entry)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.bottom, 16)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("工具")
        .navigationDestination(for: ToolEntry.self) { entry in
            WebViewScreen(url: entry.url, title: entry.title)
        }
    }

    private func toolCard(_ entry: ToolEntry) -> some View {
        HStack(spacing: 14) {
            Text(entry.emoji)
                .font(.largeTitle)
                .frame(width: 52, height: 52)
                .background(
                    Theme.brand.opacity(0.10),
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(entry.desc)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(Theme.secondaryText)
        }
        .glassCard()
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ToolsView()
        }
    }
}
