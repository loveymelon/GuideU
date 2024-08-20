//
//  PersonSectionView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import SwiftUI

struct PersonSectionView: View {
    
    @State
    private var isExtend: Bool = false
    
    var body: some View {
        VStack {
            if !isExtend {
                HStack {
                    // 프로필 이미지
                    profileImage()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("우왁굳")
                            Spacer()
                            crossImage()
                        }
                        // 설명
                        Text("왁타버스의 수장이자 우왁굳의 게임방송의 우왁굳이다 아아")
                            .lineLimit(1)
                    }
                }
                .padding(.all, 10)
            } else {
                VStack {
                    HStack {
                      Spacer()
                        crossImage()
                    }
                }
                .frame(height: 150) // 뷰완성되면 해제 하기
            }
        }
    }
}

extension PersonSectionView {
    
    private func profileImage() -> some View {
        Image.appLogo.resizable()
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 40)
            .clipShape(Circle())
            .background {
                Rectangle()
                    .fill(
                        .linearGradient(colors: [
                            Color(GuideUColor.ViewBaseColor.light.interaction6),
                            Color(GuideUColor.ViewBaseColor.light.interaction6),
                            Color(GuideUColor.ViewBaseColor.light.primary),
                            Color(GuideUColor.ViewBaseColor.light.primary)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 44)
                    .clipShape(Circle())
            }
    }
    
    private func crossImage() -> some View {
        Group {
            if !isExtend {
                Image.chevron.down.img.resizable()
                    .aspectRatio(1, contentMode: .fit)
                   
            } else {
                Image.chevron.up.img.resizable()
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .frame(width: 24)
        .asButton {
            withAnimation {
                isExtend.toggle()
            }
        }
    }
}
