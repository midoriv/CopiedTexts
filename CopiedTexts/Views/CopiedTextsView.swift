//
//  CopiedTextsView.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 14/2/2022.
//

import SwiftUI

struct CopiedTextsView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel: CopiedTextsViewModel
    @State private var isNotified = false
    
    @ViewBuilder
    var emptyView: some View {
        if viewModel.texts.isEmpty {
            Text("No copied text yet").font(.title3)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        Color(.systemGray6)
        .overlay(
            HStack {
                Text("Copied Texts")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding(.horizontal, 30)
                Spacer()
            }
        )
        .frame(height: 70)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                titleView
                List {
                    ForEach(viewModel.sortedTexts, id: \.self) { text in
                        RowView(isNotified: $isNotified, text: text)
                    }
                    .onDelete(perform: viewModel.deleteText)
                }
            }
            .overlay(emptyView)
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .inactive:
                    print("inactive")
                case .active:
                    print("active")
                case .background:
                    print("background")
                @unknown default:
                    break
                }
                
                if newPhase == .active {
    //                viewModel.clearPasteboard()
                    viewModel.inspectPasteboard()
                }
            }
            .overlay(isNotified ? NotifyView(notify: $isNotified, geometry: geometry) : nil)
        }
    }
}

struct NotifyView: View {
    @Binding var notify: Bool
    var geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Color.mint
            .frame(width: geometry.size.width, height: 50)
            .opacity(0.9)
            .overlay(Text("Text Copied!").bold())
            .transition(.opacity)
            .onAppear {
                withAnimation(.default.delay(2)) {
                    notify = false
                }
            }
            
            Spacer()
        }
    }
}

struct RowView: View {
    @EnvironmentObject var viewModel: CopiedTextsViewModel
    @Binding var isNotified: Bool
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            copyButton
        }
    }
    
    var copyButton: some View {
        Button {
            viewModel.setPasteboard(text: text)
            withAnimation {
                isNotified = true
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.mint)
                Text("Copy")
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 30)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
