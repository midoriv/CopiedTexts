//
//  CopiedTextsView.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 14/2/2022.
//

import SwiftUI

struct CopiedTextsView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var viewModel: CopiedTextsViewModel
    
    @ViewBuilder
    var emptyView: some View {
        if viewModel.texts.isEmpty {
            Text("No copied text yet")
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        Color(.systemGray6)
        .overlay(
            HStack {
                Text("Copied Texts")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding([.top, .horizontal], 30)
                Spacer()
            }
        )
        .frame(height: 60)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                
            List {
                ForEach(viewModel.sortedTexts, id: \.self) { text in
                    Text(text)
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
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
