//
//  OracleView.swift
//  HadexGate
//
//  The AI guide — "The Keeper of the Gate". Chat UI over OracleService.
//

import SwiftUI

struct OracleView: View {
    @Environment(OracleService.self) private var oracle
    @Environment(LibraryStore.self) private var library
    @Environment(SubscriptionManager.self) private var subscriptions
    @Environment(PaywallPresenter.self) private var paywall
    @FocusState private var inputFocused: Bool
    @State private var draft = ""
    @State private var keyboardVisible = false

    private var oracleLocked: Bool {
        !subscriptions.hasOracleUnlimited && oracle.remainingFreeAsks() <= 0
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(oracle.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        if oracle.messages.count <= 1 {
                            suggestionsBlock
                        }
                        Color.clear.frame(height: 8).id("bottom")
                    }
                    .padding(.horizontal, Metrics.screenPadding)
                    .padding(.top, 14)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: oracle.messages.count) {
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                // The engine banner pins to the top; the input bar pins to the
                // bottom and — via safeAreaInset — always rides above the keyboard.
                .safeAreaInset(edge: .top, spacing: 0) { engineBanner }
                .safeAreaInset(edge: .bottom, spacing: 0) { inputBar }
            }
            .hadexBackground()
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation(.easeOut(duration: 0.2)) { keyboardVisible = true }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation(.easeOut(duration: 0.2)) { keyboardVisible = false }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text("Keeper of the Gate")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Palette.bone)
                        Text("Oracle of the Underworld")
                            .font(.caption2)
                            .foregroundStyle(Palette.boneMuted)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.tap()
                        oracle.reset()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(Palette.ember)
                    }
                }
            }
            // Keyboard is dismissed by swiping the message list
            // (scrollDismissesKeyboard). A screen-wide tap gesture is deliberately
            // NOT used here — it would steal the tap that focuses the input field
            // and dismiss the keyboard the instant the user tries to type.
        }
    }

    private var engineBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: oracle.engine == .appleIntelligence ? "apple.logo" : "books.vertical.fill")
                .font(.caption2.weight(.bold))
            Text(LocalizedStringKey(oracle.engine.note))
                .font(.caption2)
                .lineLimit(2)
            Spacer(minLength: 0)
            if !subscriptions.hasOracleUnlimited {
                Text("\(oracle.remainingFreeAsks()) free")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Palette.gold)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(Palette.gold.opacity(0.15)))
            }
        }
        .foregroundStyle(Palette.boneMuted)
        .padding(.horizontal, 14).padding(.vertical, 8)
        .background(Palette.charcoal.opacity(0.8))
        .overlay(Rectangle().fill(Palette.ash).frame(height: 1), alignment: .bottom)
    }

    private var suggestionsBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ask the Keeper")
                .font(.caption.weight(.bold))
                .foregroundStyle(Palette.smoke)
                .padding(.top, 8)
            FlowLayout(spacing: 8) {
                ForEach(oracle.suggestions, id: \.self) { suggestion in
                    Button {
                        send(suggestion)
                    } label: {
                        Text(LocalizedStringKey(suggestion))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Palette.bone)
                            .padding(.horizontal, 12).padding(.vertical, 9)
                            .background(Capsule().fill(Palette.slate))
                            .overlay(Capsule().stroke(Palette.violet.opacity(0.4), lineWidth: 1))
                    }
                    .buttonStyle(.pressable)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var inputBar: some View {
        if oracleLocked {
            lockedBar
        } else {
            askBar
        }
    }

    private var lockedBar: some View {
        Button {
            Haptics.tap(.medium)
            paywall.present()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                Text("Free questions used — Unlock the Oracle")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1).minimumScaleFactor(0.85)
                Spacer(minLength: 0)
                Text("$1.99")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(Palette.abyss)
            .padding(.horizontal, 16).padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Gradients.ember))
        }
        .buttonStyle(.pressable)
        .padding(.horizontal, Metrics.screenPadding)
        .padding(.top, 10)
        .padding(.bottom, keyboardVisible ? 10 : 84)
        .background(Palette.obsidian.opacity(0.95))
        .overlay(Rectangle().fill(Palette.ash).frame(height: 1), alignment: .top)
    }

    private var askBar: some View {
        HStack(spacing: 10) {
            TextField("", text: $draft, prompt: Text("Ask of the underworld…").foregroundColor(Palette.smoke), axis: .vertical)
                .focused($inputFocused)
                .foregroundStyle(Palette.bone)
                .lineLimit(1...4)
                .padding(.horizontal, 14).padding(.vertical, 11)
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Palette.charcoal))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(inputFocused ? Palette.violet.opacity(0.6) : Palette.ash, lineWidth: 1))

            Button {
                send(draft)
            } label: {
                Image(systemName: "arrow.up")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Palette.abyss)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(canSend ? AnyShapeStyle(Gradients.spirit) : AnyShapeStyle(Palette.ash)))
            }
            .buttonStyle(.pressable)
            .disabled(!canSend || oracle.isResponding)
        }
        .padding(.horizontal, Metrics.screenPadding)
        .padding(.top, 10)
        // Clear the floating tab bar when the keyboard is down; sit just above the
        // keyboard when it's up. Keyed off the REAL keyboard state (not focus) so
        // the bar is never hidden behind the tab bar.
        .padding(.bottom, keyboardVisible ? 10 : 84)
        .background(Palette.obsidian.opacity(0.95))
        .overlay(Rectangle().fill(Palette.ash).frame(height: 1), alignment: .top)
    }

    private var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func send(_ text: String) {
        let question = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !oracle.isResponding else { return }
        if oracleLocked {
            inputFocused = false
            Haptics.warning()
            paywall.present()
            return
        }
        Haptics.tap(.medium)
        draft = ""
        inputFocused = false
        if !subscriptions.hasOracleUnlimited { oracle.registerFreeAsk() }
        Task {
            _ = await oracle.ask(question)
            library.record(HistoryEvent(kind: .oracle, title: question,
                                        detail: "Asked the Keeper", date: Date()))
        }
    }
}

private struct MessageBubble: View {
    let message: OracleMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == .oracle {
                avatar
            } else {
                Spacer(minLength: 40)
            }

            Group {
                if message.isThinking {
                    ThinkingDots()
                        .padding(.horizontal, 16).padding(.vertical, 14)
                } else {
                    Text(LocalizedStringKey(message.text))
                        .font(.callout)
                        .foregroundStyle(message.role == .oracle ? Palette.bone : Palette.abyss)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 14).padding(.vertical, 11)
                }
            }
            .background(bubbleBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(message.role == .oracle ? Palette.violet.opacity(0.35) : .clear, lineWidth: 1)
            )

            if message.role == .oracle {
                Spacer(minLength: 40)
            }
        }
    }

    private var avatar: some View {
        ZStack {
            Circle().fill(Gradients.spirit).frame(width: 32, height: 32)
            Image(systemName: "sparkles").font(.caption).foregroundStyle(.white)
        }
    }

    private var bubbleBackground: some ShapeStyle {
        message.role == .oracle ? AnyShapeStyle(Palette.charcoal) : AnyShapeStyle(Gradients.ember)
    }
}

private struct ThinkingDots: View {
    @State private var phase = 0
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Palette.violet)
                    .frame(width: 7, height: 7)
                    .scaleEffect(phase == i ? 1 : 0.5)
                    .opacity(phase == i ? 1 : 0.4)
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(280))
                withAnimation(.easeInOut(duration: 0.28)) { phase = (phase + 1) % 3 }
            }
        }
        .accessibilityLabel("The Keeper is thinking")
    }
}

#Preview {
    OracleView()
        .environment(OracleService())
        .environment(LibraryStore())
        .environment(SubscriptionManager())
}
