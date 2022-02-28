//
//  CopiedTextsViewModel.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 16/2/2022.
//

import Foundation
import SwiftUI

class CopiedTextsViewModel: ObservableObject {
    @Published var texts = [String]()
    
    
    // MARK: - Intents
    
    func inspectPasteboard() {
        if let text = UIPasteboard.general.string {
            if !self.texts.contains(text) {
                DispatchQueue.main.async {
                    self.texts.insert(text, at: 0)
                }
            }
        }
    }
    
    func setPasteboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    func clearPasteboard() {
        UIPasteboard.general.string = ""
    }
    
    func deleteText(indexSet: IndexSet) {
        texts.remove(atOffsets: indexSet)
        
        // if deleted the last text
        if texts.isEmpty {
            clearPasteboard()
        }
    }
}
