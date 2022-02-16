//
//  CopiedTextsViewModel.swift
//  CopiedTexts
//
//  Created by Midori Verdouw on 16/2/2022.
//

import Foundation
import SwiftUI

class CopiedTextsViewModel: ObservableObject {
    @Published private(set) var texts = [String]()
    
    
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
                    case \.probableWebURL:
                        print("url")
                        self.texts.append("\(detectedValues[keyPath: pattern])")
                        return
                    case \.probableWebSearch:
                        print("search")
                        self.texts.append("\(detectedValues[keyPath: pattern])")
                        return
                    default: return
                    }
                }
                
            case .failure:
            break
            }
        }
    }
}
