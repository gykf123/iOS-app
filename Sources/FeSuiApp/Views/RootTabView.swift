import SwiftUI

/// 根容器：底部 TabView，五个 Tab —— 首页 / 项目 / 友链 / 留言 / 工具。
struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("首页", systemImage: "house.fill")
            }

            NavigationStack {
                ProjectsView()
            }
            .tabItem {
                Label("项目", systemImage: "cube.box.fill")
            }

            NavigationStack {
                FriendsView()
            }
            .tabItem {
                Label("友链", systemImage: "link")
            }

            NavigationStack {
                GuestbookView()
            }
            .tabItem {
                Label("留言", systemImage: "bubble.left.and.bubble.right.fill")
            }

            NavigationStack {
                ToolsView()
            }
            .tabItem {
                Label("工具", systemImage: "wrench.and.screwdriver.fill")
            }
        }
        .tint(Theme.brand)
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
