//
//  MemeDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

struct BookElementDTO: DTO {
    let timestamp: Int
    let memes: [MemeDTO]
}

/// MemeDTO
struct MemeDTO: DTO {
    let name, definition, description: String
    let synonyms: [String]
    let relatedVideos: [RelatedVideoDTO]
    let isDetectable: Bool
    let id: Int
    let duplicates: [DuplicateDTO]?
    let appearanceTime: Int?

    enum CodingKeys: String, CodingKey {
        case name, definition, description, synonyms
        case relatedVideos = "related_videos"
        case isDetectable = "is_detectable"
        case id
        case duplicates
        case appearanceTime = "appearance_time"
    }
}

struct BooksDTO: DTO {
    let bookListDTO: [BookElementDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var bookList = [BookElementDTO] ()
        while !container.isAtEnd {
            let bookData = try container.decode(BookElementDTO.self)
            bookList.append(bookData)
        }
        self.bookListDTO = bookList
    }
}
