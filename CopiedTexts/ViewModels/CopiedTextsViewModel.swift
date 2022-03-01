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
    
    private(set) var isFirst: Bool
    
    private var userDefaultKey = "UserDefault"
    private var userDefaultKey2 = "UserDefault: isFirst"
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(texts), forKey: userDefaultKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultKey),
           let decodedTexts = try? JSONDecoder().decode(Array<String>.self, from: jsonData) {
            texts = decodedTexts
        }
    }
    
    private func setIsFirstInUserDefaults() {
        if isFirst {
            isFirst = false
            UserDefaults.standard.set(try? JSONEncoder().encode(isFirst), forKey: userDefaultKey2)
        }
    }
    
    init() {
        isFirst = UserDefaults.standard.data(forKey: userDefaultKey2) == nil
        
        // ensure that currently copied text is not shown the first time app runs
        if isFirst {
            clearPasteboard()
        }
        else {
            restoreFromUserDefaults()
        }
    }
    
    
    // MARK: - Intents
    
    func inspectPasteboard() {
        if let text = UIPasteboard.general.string {
            if !text.isEmpty && !self.texts.contains(text) {
                DispatchQueue.main.async {
                    self.texts.insert(text, at: 0)
                }
                
                setIsFirstInUserDefaults()
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
        clearPasteboard()
        texts.remove(atOffsets: indexSet)
    }
}
