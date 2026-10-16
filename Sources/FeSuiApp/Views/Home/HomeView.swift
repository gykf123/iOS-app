import SwiftUI
import UIKit

/// Tab 1：首页 —— 头部信息 / 关于我 / 格言 / 邮箱入口。
struct HomeView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                headerCard
                aboutCard
                quotesCard
                emailCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("FeSui")
        .navigationBarTitleDisplayMode(.large)
    }

    /// 头部：头像 + 名字 + 身份 + chips。
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                AvatarView(
                    urlString: SiteContent.avatarURLString,
                    fallbackText: "F",
                    size: 76
                )
                VStack(alignment: .leading, spacing: 6) {
                    Text(SiteContent.name)
                        .font(.title2.weight(.bold))
                    Text(SiteContent.identity)
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 8) {
                ForEach(SiteContent.chips, id: \.self) { chip in
                    ChipTag(text: chip)
                }
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    /// 关于我：两段原文。
    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "关于我", systemImage: "person.crop.circle")
            ForEach(Array(SiteContent.aboutParagraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(.body)
                    .foregroundColor(Color.primary.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    /// 格言：三条，纵向排列。
    private var quotesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "格言", systemImage: "text.quote")
            ForEach(Array(SiteContent.quotes.enumerated()), id: \.offset) { _, quote in
                HStack(alignment: .top, spacing: 10) {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Theme.brand)
                        .frame(width: 4)
                    Text(quote)
                        .font(.subheadline)
                        .foregroundColor(Color.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    /// 邮箱入口：点击调用系统邮件客户端。
    private var emailCard: some View {
        Button {
            UIApplication.shared.open(ExternalLinks.mailto(SiteContent.email))
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Theme.brand, in: Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("邮箱")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(SiteContent.email)
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Theme.secondaryText)
            }
        }
        .buttonStyle(.plain)
        .glassCard()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
