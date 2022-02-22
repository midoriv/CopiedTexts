//
//  CopiedTextsApp.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 14/2/2022.
//

import SwiftUI

@main
struct CopiedTextsApp: App {
    let viewModel = CopiedTextsViewModel()
    
    var body: some Scene {
        WindowGroup {
            CopiedTextsView()
                .environmentObject(viewModel)
        }
    }
}
