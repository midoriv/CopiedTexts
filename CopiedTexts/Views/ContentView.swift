//
//  ContentView.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 14/2/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CopiedTextsViewModel
    
    @State var pasteboardContents: String = ""
    
    init(viewModel: CopiedTextsViewModel) {
        self.viewModel = viewModel
//        viewModel.inspectPasteboard()
    }
    
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
        .onAppear {
            viewModel.inspectPasteboard()
        }
    }
    
    
    

}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
