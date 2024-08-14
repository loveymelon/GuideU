//
//  DuplicateDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

// MARK: - Duplicate
struct DuplicateDTO: DTO {
    let name: String
    let memeID: Int

    enum CodingKeys: String, CodingKey {
        case name
        case memeID = "meme_id"
    }
}
