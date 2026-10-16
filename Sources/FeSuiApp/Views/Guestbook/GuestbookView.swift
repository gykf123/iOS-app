import SwiftUI

/// Tab 4：留言墙 —— 发布表单 + 留言列表（Supabase REST）。
struct GuestbookView: View {
    @StateObject private var viewModel = GuestbookViewModel()
    @FocusState private var focusedField: Field?

    private enum Field {
        case nickname
        case content
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                composerCard
                messagesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("留言")
        .scrollDismissesKeyboard(.interactively)
        .refreshable {
            await viewModel.load()
        }
        .task {
            await viewModel.load()
        }
        .toast(message: $viewModel.toastMessage)
    }

    // MARK: - 发布表单

    private var composerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "写下留言", systemImage: "square.and.pencil")

            TextField("昵称（选填）", text: $viewModel.nickname)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .nickname)
                .onChange(of: viewModel.nickname) { newValue in
                    if newValue.count > viewModel.maxNicknameLength {
                        viewModel.nickname = String(newValue.prefix(viewModel.maxNicknameLength))
                    }
                }

            ZStack(alignment: .topLeading) {
                if viewModel.content.isEmpty {
                    Text("说点什么吧……")
                        .foregroundColor(Theme.secondaryText.opacity(0.7))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 5)
                }
                TextEditor(text: $viewModel.content)
                    .frame(minHeight: 88, maxHeight: 140)
                    .focused($focusedField, equals: .content)
                    .onChange(of: viewModel.content) { newValue in
                        if newValue.count > viewModel.maxContentLength {
                            viewModel.content = String(newValue.prefix(viewModel.maxContentLength))
                        }
                    }
            }
            .padding(8)
            .background(
                Color.primary.opacity(0.05),
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )

            HStack {
                Text("\(viewModel.content.count) / \(viewModel.maxContentLength)")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
                    .monospacedDigit()
                Spacer(minLength: 0)
                Button {
                    focusedField = nil
                    Task { await viewModel.publish() }
                } label: {
                    if viewModel.isPublishing {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("发布", systemImage: "paperplane.fill")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.brand)
                .disabled(!viewModel.canPublish)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    // MARK: - 留言列表（加载中 / 失败 / 空 / 列表 四态）

    @ViewBuilder
    private var messagesSection: some View {
        switch viewModel.loadState {
        case .idle, .loading:
            VStack(spacing: 10) {
                ProgressView()
                Text("加载中……")
                    .font(.subheadline)
                    .foregroundColor(Theme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)

        case .failed(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(Theme.secondaryText)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                Button("重试") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.bordered)
                .tint(Theme.brand)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)

        case .loaded:
            if viewModel.messages.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.largeTitle)
                        .foregroundColor(Theme.secondaryText)
                    Text("还没有留言，来抢沙发。")
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        messageRow(message)
                    }
                }
            }
        }
    }

    private func messageRow(_ message: Message) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(Theme.brand)
                    Text(message.displayNickname)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                }
                Spacer(minLength: 0)
                Text(message.displayTime)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
                    .monospacedDigit()
            }
            Text(message.content)
                .font(.body)
                .foregroundColor(Color.primary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(padding: 14)
    }
}

struct GuestbookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GuestbookView()
        }
    }
}
