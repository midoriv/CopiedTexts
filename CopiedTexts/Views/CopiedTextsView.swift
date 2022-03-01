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
    @State private var selectedText: String?
    
    @ViewBuilder
    var emptyView: some View {
        if viewModel.texts.isEmpty {
            Group {
                if viewModel.isFirst {
                    Text("You will see the contents of your clipboard here ...")
                }
                else {
                    Text("No clipboard contents.")
                }
            }.font(.title3)
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
                    ForEach(viewModel.texts, id: \.self) { text in
                        RowView(
                            isNotified: $isNotified,
                            selectedText: $selectedText,
                            text: text
                        )
                        .listRowBackground(selectedText == text ? Color(.systemGray5) : nil)
                    }
                    .onDelete(perform: viewModel.deleteText)
                }
            }
            .overlay(emptyView)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.inspectPasteboard()
                }
            }
            .overlay(
                isNotified ? NotifyView(isNotified: $isNotified, selectedText: $selectedText, geometry: geometry) : nil
            )
        }
    }
}

struct NotifyView: View {
    @Binding var isNotified: Bool
    @Binding var selectedText: String?
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isNotified = false
                        selectedText = nil
                    }
                }
            }
            
            Spacer()
        }
    }
}


struct RowView: View {
    @EnvironmentObject var viewModel: CopiedTextsViewModel
    @Binding var isNotified: Bool
    @Binding var selectedText: String?
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
                selectedText = text
                isNotified = true
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(isNotified ? .gray : .mint)
                Text("Copy")
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 30)
        }
        .buttonStyle(BorderlessButtonStyle())
        .disabled(isNotified)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CopiedTextsView()
            .environmentObject(CopiedTextsViewModel())
    }
}
