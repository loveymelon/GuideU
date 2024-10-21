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
    
    @ViewBuilder func shimmering(
        active: Bool = true,
        animation: Animation = ShimmerAnimation.defaultAnimation,
        gradient: Gradient = ShimmerAnimation.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: ShimmerAnimation.Mode = .mask
    ) -> some View {
        if active {
            modifier(ShimmerAnimation(animation: animation, gradient: gradient, bandSize: bandSize, mode: mode))
        } else {
            self
        }
    }
    
    func errorAlert(
        alertModel: Binding<AlertMessage?>,
        confirm: @escaping (AlertMessage) -> Void,
         cancel: @escaping (AlertMessage) -> Void
    ) -> some View {
        return self
            .alert(
                item: alertModel) { item in
                    Text(item.title)
                } actions: { item in
                    if item.cancelTitle == nil {
                        Text(item.actionTitle)
                            .asButton {
                                confirm(item)
                            }
                    } else {
                        Text(item.actionTitle)
                            .asButton {
                                confirm(item)
                            }
                        Text(item.cancelTitle!)
                            .asButton {
                                cancel(item)
                            }
                    }
                } message: { item in
                    Text(item.message)
                }
    }
}
