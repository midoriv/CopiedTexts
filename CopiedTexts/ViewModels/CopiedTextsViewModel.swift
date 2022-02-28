//
//  CopiedTextsViewModel.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 16/2/2022.
//

import Foundation
import SwiftUI

class CopiedTextsViewModel: ObservableObject {
    @Published var texts = [String]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultKey = "UserDefault"
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(texts), forKey: userDefaultKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultKey),
           let decodedTexts = try? JSONDecoder().decode(Array<String>.self, from: jsonData) {
            texts = decodedTexts
        }
    }
    
    init() {
        restoreFromUserDefaults()
    }
    
    
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
