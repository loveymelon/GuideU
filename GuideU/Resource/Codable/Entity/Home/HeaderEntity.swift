//
//  HeaderEntity.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation

struct HeaderEntity: Entity {
    
    static let initialSelf = HeaderEntity(
        title: Const.MorePersonHeader.title,
        channelName: Const.MorePersonHeader.channelName,
        time: Const.MorePersonHeader.channelName,
        thumImage: nil
    )
    
    let sectionTitle = Const.MorePersonHeader.headerTop
    let title: String
    let channelName: String
    let time: String
    let thumImage: URL?
}
