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
    
    var body: some View {
        Group {
            if viewModel.texts.isEmpty {
                Text("No copied text yet")
            }
            else {
                List {
                    ForEach(viewModel.texts, id: \.self) { text in
                        Text(text)
                    }
                }
            }
        }
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
