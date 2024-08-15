//
//  SearchDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/15/24.
//

import Foundation

import Foundation

// MARK: - SearchDTOElement
/// 사용시 LinkeDTO에 담아서
struct SearchDTO: DTO {
    let name: String
    let engName: String?
    let definition: String
    let smallImageURL: String?
    let largeImageURL: String?
    let links: [LinkDTO]?
    let id: Int
    let type: SearchTypeDTO
    let description: String?
    let synonyms: [String?]?
    let relatedVideos: [RelatedVideoDTO]?
    let isDetectable: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case engName = "eng_name"
        case definition
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
        case links, id, type, description, synonyms
        case relatedVideos = "related_videos"
        case isDetectable = "is_detectable"
    }
}


