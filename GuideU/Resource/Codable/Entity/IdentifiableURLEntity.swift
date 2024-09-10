//
//  IdentifiableURLEntity.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/11/24.
//

import Foundation

struct IdentifiableURLEntity: Identifiable, Entity {
    let id = UUID()
    let url: URL
}
