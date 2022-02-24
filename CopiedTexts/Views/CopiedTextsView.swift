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
    @State private var notify = false
    
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
        VStack(spacing: 0) {
            titleView
            List {
                ForEach(viewModel.sortedTexts, id: \.self) { text in
                    RowView(notify: $notify, text: text)
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
        .overlay(notify ? notifyView : nil)
    }
    
    @ViewBuilder
    var notifyView: some View {
        VStack {
            Text("Text Copied!")
                .transition(.opacity)
                .onAppear {
                    withAnimation(.default.delay(2)) {
                        notify = false
                    }
                    print("notify value: \(notify)")
                }
            Spacer()
        }
    }
}

struct RowView: View {
    @EnvironmentObject var viewModel: CopiedTextsViewModel
    @Binding var notify: Bool
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Button {
                viewModel.setPasteboard(text: text)
                withAnimation {
                    notify = true
                }
            } label: {
                copyButton
            }
        }
    }
    
    var copyButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.mint)
            Text("Copy")
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 30)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
