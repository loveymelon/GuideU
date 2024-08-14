//
//  ExView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import SwiftUI

extension View {
    func asButton(action: @escaping () -> Void ) -> some View {
        modifier(ButtonWrapper(action: action))
    }
}
