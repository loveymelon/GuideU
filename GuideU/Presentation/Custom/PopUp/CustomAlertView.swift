//
//  CustomAlertView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/21/24.
//

import SwiftUI

enum AlertMode {
    case onlyCheck
    case cancelWith
}

struct CustomAlertView: View {
    
    var alertMode: AlertMode
    
    var title: String
    var message: String
    var ifMessageCenter : Bool
    
    var onCancel: () -> Void
    var onAction: () -> Void
    
    var actionTitle: String
    
    var body: some View {
        ZStack (alignment: .center) {
            Color.black.opacity(0.2)
                .ignoresSafeArea(edges: .all)
            Spacer()
            
            VStack(spacing: 16) {
                Text(title)
                    .font(Font(WantedFont.boldFont.font(size: 24)))
                    .foregroundStyle(.black)
                Text(message)
                        .font(Font(WantedFont.regularFont.font(size: 14)))
                    .multilineTextAlignment(ifMessageCenter ? .center : .leading)
                    .foregroundStyle(.gray)
                makeAlertView()
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
            .padding()
            
            Spacer()
        }
        .zIndex(1)
    }
}

extension CustomAlertView {
    
    @ViewBuilder
    func makeAlertView() -> some View {
        
        switch alertMode {
        case .cancelWith:
            HStack {
                Button(action: {
                    withAnimation {
                        onCancel()
                    }
                }) {
                    Text("취소")
                        .font(Font(WantedFont.boldFont.font(size: 16)))
                        .frame(maxWidth: .infinity)
                        .frame(height: 15)
                        .padding()
                        .background(Color(GuideUColor.ViewBaseColor.light.gray1))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action: {
                    withAnimation {
                        onAction()
                    }
                }) {
                    Text(actionTitle)
                        .font(Font(WantedFont.boldFont.font(size: 16)))
                        .frame(maxWidth: .infinity)
                        .frame(height: 15)
                        .padding()
                        .background(Color(GuideUColor.ViewBaseColor.light.primary))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        case .onlyCheck:
            Button(action: {
                onAction()
            }) {
                Text(actionTitle)
                    .font(Font(WantedFont.boldFont.font(size: 16)))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(GuideUColor.ViewBaseColor.light.primary))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
