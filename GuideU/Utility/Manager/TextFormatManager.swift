//
//  TextFormatManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/10/24.
//

import Foundation

struct TextFormatManager {
    
    func splitTextInfoChunks(_ text: String) -> [String] {
        let words = text.split(separator: ". ").map(String.init)
        var chunks: [String] = []
        
        for (index, word) in words.enumerated() {
            if index == words.count - 1 {
                chunks.append(word)
            } else {
                chunks.append(word + ".")
            }
        }
        
        return chunks
    }
}
