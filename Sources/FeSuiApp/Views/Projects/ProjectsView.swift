import SwiftUI
import UIKit

/// Tab 2：项目 —— 5 张卡片；前 4 张「规划中」，FKD 卡片可跳转官网。
struct ProjectsView: View {
    @State private var toastMessage: String?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(ProjectsData.all) { item in
                    projectCard(item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.bottom, 16)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("项目")
        .toast(message: $toastMessage)
    }

    private func projectCard(_ item: ProjectItem) -> some View {
        Button {
            if let url = item.url {
                UIApplication.shared.open(url)
            } else {
                showToast("规划中，敬请期待")
            }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                    if item.url == nil {
                        // 与网页一致：无 href 的项目标注「规划中」角标
                        Text("规划中")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(Theme.brand)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.brand.opacity(0.12), in: Capsule())
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Theme.secondaryText)
                    }
                }
                Text(item.desc)
                    .font(.subheadline)
                    .foregroundColor(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 6) {
                    ForEach(item.tags, id: \.self) { tag in
                        ChipTag(text: tag)
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassCard()
        }
        .buttonStyle(.plain)
    }

    private func showToast(_ text: String) {
        toastMessage = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if toastMessage == text {
                toastMessage = nil
            }
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectsView()
        }
    }
}
