//
//  TeamRoleProtocol.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/18/24.
//

import Foundation

protocol TeamRoleProtocol: Equatable, Hashable {
    static var mainTitle: String { get }
    var title: String { get }
    var member: String { get }
    static var textGrayOptions: [String] { get }
    var paddingOptions: Bool { get }
}
