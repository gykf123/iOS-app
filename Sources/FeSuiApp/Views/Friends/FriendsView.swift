import SwiftUI
import UIKit

/// Tab 3：友链 —— 点击调用系统浏览器打开。
struct FriendsView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(FriendsData.all) { friend in
                    friendCard(friend)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.bottom, 16)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("友链")
    }

    private func friendCard(_ friend: FriendLink) -> some View {
        Button {
            UIApplication.shared.open(friend.url)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.brand.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Text(String(friend.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(Theme.brand)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(friend.desc)
                        .font(.subheadline)
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
        .buttonStyle(.plain)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FriendsView()
        }
    }
}
