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
    
    var sortedTexts: [String] {
        texts.reversed()
    }
    
    // get currently copied text (the last text in the array)
    var currentText: String {
        if let last = texts.last {
            return last
        }
        else {
            return ""
        }
    }
    
    
    // MARK: - Intents
    
    func inspectPasteboard() {
        guard UIPasteboard.general.hasStrings else { return }
        
        let somePatterns: Set<PartialKeyPath<UIPasteboard.DetectedValues>> = [
             \.probableWebURL,
             \.probableWebSearch
        ]
        UIPasteboard.general.detectValues(for: somePatterns) { result in
            switch result {
            case .success(let detectedValues):
                let detectedPatterns = detectedValues[keyPath: \.patterns]
                
                for pattern in detectedPatterns {
                    switch pattern {
                    case \.probableWebURL, \.probableWebSearch:
                        if (detectedValues[keyPath: pattern] as? String) != self.currentText {
                            DispatchQueue.main.async {
                                self.texts.append("\(detectedValues[keyPath: pattern])")
                            }
                        }
                        return
                    default:
                        print("default")
                        return
                    }
                }
                
            case .failure (let failure):
                print(failure)
            break
            }
        }
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
