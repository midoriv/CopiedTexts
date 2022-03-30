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
            storeTextsInUserDefaults()
        }
    }
    
    // store and restore texts in/from UserDefaults
    private var udKeyForTexts = "UserDefaults: texts"
    
    private func storeTextsInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(texts), forKey: udKeyForTexts)
    }
    
    private func restoreTextsFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: udKeyForTexts),
           let decodedTexts = try? JSONDecoder().decode(Array<String>.self, from: jsonData) {
            texts = decodedTexts
        }
    }
    
    // store isFirst into UserDefaults
    private(set) var isFirst: Bool      // whether the app runs for the first time
    private var udKeyForIsFirst = "UserDefaults: isFirst"
    
    private func setIsFirstInUserDefaults() {
        if isFirst {
            isFirst = false
            UserDefaults.standard.set(try? JSONEncoder().encode(isFirst), forKey: udKeyForIsFirst)
        }
    }
    
    init() {
        isFirst = UserDefaults.standard.data(forKey: udKeyForIsFirst) == nil
        
        // ensure that currently copied text is not shown the first time app runs
        if isFirst {
            clearPasteboard()
        }
        else {
            restoreTextsFromUserDefaults()
        }
    }
    
    
    // MARK: - Intents
    
    // If the pasteboard contains a string add it to the `texts` collection
    func inspectPasteboard() {
        if let text = UIPasteboard.general.string {
            if !text.isEmpty && !self.texts.contains(text) {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                
                DispatchQueue.main.async {
                    self.texts.insert(trimmed, at: 0)
                }
                
                // isFirst is set to false the first time a text is added
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
