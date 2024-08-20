//
//  CharactersDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation

struct CharactersDTO: DTO {
    let name: String
    let engName: String
    let definition: String
    let smallImageUrl: String
    let largeImageUrl: String
    let links: [String]
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case engName = "eng_name"
        case definition
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
        case links
        case id
    }
}
