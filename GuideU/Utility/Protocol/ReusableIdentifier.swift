//
//  ReusableIdentifier.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/30/24.
//

import Foundation

protocol ReusableIdentifier {}

extension ReusableIdentifier {
    static var identifier: String {
        String(describing: self)
    }
}
