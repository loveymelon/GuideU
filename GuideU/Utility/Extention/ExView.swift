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
    
    
    func headerGradient() -> some View {
        self
            .overlay {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                .black.opacity(0),
                                .black.opacity(0.1),
                                .black.opacity(0.3),
                                .black.opacity(0.6),
                                .black.opacity(0.8),
                                .black.opacity(1)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                }
            }
    }
}
