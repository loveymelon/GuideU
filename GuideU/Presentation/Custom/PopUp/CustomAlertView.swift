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
    
    @Binding var isShowing: Bool
    
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
        .animation(.easeInOut, value: isShowing)
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
                        isShowing = false
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
                        isShowing = false
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
                isShowing = false
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

#if DEBUG
#if compiler(>=5.9)
@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isShowing: Bool = true
    
    return CustomAlertView(alertMode: .onlyCheck, isShowing: $isShowing, title: "김재형", message: "잘생겼다~!", ifMessageCenter: true, onCancel: {
        
    }, onAction: {
        
    }, actionTitle: "확인이여")
}
#endif
#endif
