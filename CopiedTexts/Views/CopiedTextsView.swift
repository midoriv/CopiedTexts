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
    
    var body: some View {
        
        List {
            ForEach(viewModel.sortedTexts, id: \.self) { text in
                Text(text)
            }
            .onDelete { indexSet in
                viewModel.texts.remove(atOffsets: indexSet)
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
