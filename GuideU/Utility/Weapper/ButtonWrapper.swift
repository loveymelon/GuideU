//
//  ButtonWrapper.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import SwiftUI

struct ButtonWrapper: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(
            action:action,
            label: { content }
        )
    }
}
