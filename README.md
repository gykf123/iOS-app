# FeSui iOS App

「FeSui 个人主页」的原生 iOS 客户端（Swift + SwiftUI），后续将承载 FKD 服务器等相关内容。

## 项目简介

App 完整复刻 FeSui 个人主页的移动端体验，底部 TabView 五个 Tab：**首页 / 项目 / 友链 / 留言 / 工具**。

- 中文 UI、品牌主色 `#4F7CFF`（深色模式提亮为 `#8FB2FF`），深浅色自动适配
- 卡片风格：圆角 18、半透明「玻璃感」材质、淡阴影
- 图标使用 SF Symbols

## 功能列表

| Tab | 内容 |
| --- | --- |
| 首页 | 头像（网络加载，失败回退首字母「F」）、名字 / 身份 / 标签、「关于我」两段原文、3 条格言、邮箱入口（mailto） |
| 项目 | 5 张卡片；前 4 张标注「规划中」角标并弹轻提示，FKD 服务器主页可跳转官网 |
| 友链 | 白鹿原嚒、MCJS，点击调用系统浏览器打开 |
| 留言 | Supabase REST 匿名读写留言墙：昵称（30 字）+ 内容（500 字，带计数）、下拉刷新、加载中 / 失败 / 空 / 列表四态 |
| 工具 | 矿石查找器、MC 搜索、FKD 服务器三个入口，App 内 WKWebView 全屏打开，带关闭按钮与加载进度 |

## 技术栈

- Swift 5 + SwiftUI，部署目标 iOS 16.0+
- **零第三方依赖**：全部使用 Foundation / Network（URLSession）/ SwiftUI / WebKit 原生实现
- **XcodeGen** 工程方案：`project.yml` 描述工程，`*.xcodeproj` 不纳入版本库，由本地或 CI 执行 `xcodegen generate` 生成
- 留言后端：Supabase（PostgREST），直接使用可公开的 publishable key（RLS 已限制权限）
- CI：GitHub Actions `macos-14` runner 未签名构建

## 目录结构

```
.
├── .github/workflows/build.yml   # CI：XcodeGen + xcodebuild 未签名构建
├── project.yml                   # XcodeGen 工程描述
├── Resources/Info.plist          # 显式 Info.plist
├── Sources/FeSuiApp/
│   ├── App.swift                 # @main 入口
│   ├── Models/                   # 数据模型与静态文案
│   │   ├── SiteContent.swift     #   首页文案、chips、格言、邮箱、头像 URL
│   │   ├── ExternalLinks.swift   #   站外链接（FKD 等）
│   │   ├── ProjectItem.swift     #   项目数据
│   │   ├── FriendLink.swift      #   友链数据
│   │   ├── ToolEntry.swift       #   工具入口数据
│   │   └── Message.swift         #   留言模型（ISO8601 双策略解析）
│   ├── Services/                 # 网络层
│   │   ├── SupabaseConfig.swift  #   Supabase baseURL / anonKey
│   │   └── GuestbookClient.swift #   留言墙 REST 客户端
│   ├── Theme/Theme.swift         # 动态品牌色、玻璃感卡片样式
│   └── Views/
│       ├── RootTabView.swift     # 底部 5 Tab 容器
│       ├── WebView.swift         # WKWebView 封装 + 全屏容器
│       ├── Components/           # 头像、Chip、小节标题、Toast
│       ├── Home/                 # Tab 1 首页
│       ├── Projects/             # Tab 2 项目
│       ├── Friends/              # Tab 3 友链
│       ├── Guestbook/            # Tab 4 留言（View + ViewModel）
│       └── Tools/                # Tab 5 工具
└── README.md
```

所有外部数据源（Supabase 配置、工具 URL、站外链接、文案）均集中在 `Models/` 与 `Services/SupabaseConfig.swift` 的常量类型中。

## 本地构建

要求：macOS + Xcode 15 及以上（工程语言模式 Swift 5）。

```bash
# 1. 安装 XcodeGen
brew install xcodegen

# 2. 生成 Xcode 工程（*.xcodeproj 不入库，每次生成）
xcodegen generate

# 3. 用 Xcode 打开
open FeSuiApp.xcodeproj
```

打开后选择开发团队即可在真机 / 模拟器运行（CI 使用 `CODE_SIGNING_ALLOWED=NO` 做未签名构建）。

## CI

- 工作流：`.github/workflows/build.yml`
- 触发：push / pull request 到 `main`（监听 `Sources/**`、`Resources/**`、`project.yml`、workflow 自身变更），以及手动 `workflow_dispatch`
- 步骤：checkout → 缓存 Homebrew → `brew install xcodegen` → `xcodegen generate` → 缓存 SwiftPM（预留）→ `xcodebuild -project FeSuiApp.xcodeproj -scheme FeSuiApp -configuration Debug -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build`

## 已知限制

- 工程在 Linux 沙箱中开发，**无 Xcode 无法本地编译验证**；源码仅通过 `swiftc -parse` 语法检查与人工审查，首次完整类型检查以 CI 结果为准。
- 留言墙依赖线上 Supabase 实例；若后端未开启或 RLS 变更，App 内会显示「留言墙尚未开启，等待主人配置数据库。」
- 未配置 App Icon（无 asset catalog），首次上架 App Store 需自行补充图标资源。
- 使用 Xcode 15+ 打开（View 默认 MainActor 隔离）；Xcode 14 及以下打开可能需要小幅调整。
