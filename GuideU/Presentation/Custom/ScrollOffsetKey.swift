//
//  ScrollOffsetKey.swift
//  GuideU
//
//  Created by Jae hyung Kim on 11/8/24.
//

import SwiftUICore

struct ScrollOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
