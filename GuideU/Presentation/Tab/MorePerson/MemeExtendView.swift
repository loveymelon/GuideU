//
//  MemeExtendView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/10/24.
//

import SwiftUI

struct MemeExtendView: View {
    
    @State
    private var isExtend: Bool = false
    private let textManager = TextFormatManager()
       
    var selectedURL: (String) -> Void
    
    let setModel: MemeEntity
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        VStack {
            if !isExtend {
                notExpendView()
                    .padding(.all, 15)
            } else {
                VStack {
                    expendView()
                        .padding(.all, 15)
                }
            }
        }
    }
}

extension MemeExtendView {
    
    private func notExpendView() -> some View {
        VStack {
            HStack {
                Text(setModel.name)
                    .font(Font(WantedFont.boldFont.font(size: 18)))
                Spacer()
                crossImage()
            }
        }
    }
    
    private func expendView() -> some View {
       VStack {
           topView()
               .padding(.bottom, 7)
           
           textBoxView()
               .padding(.bottom, 12)
           if !setModel.relatedVideos.isEmpty {
               relative()
           }
        }
    }
    
    private func topView() -> some View {
        VStack {
            HStack {
                Text(setModel.name)
                    .font(Font(WantedFont.boldFont.font(size: 18)))
                Spacer()
                crossImage()
            }
            colorSystem.color(colorCase: .lineColor)
                .frame(maxWidth: .infinity)
                .frame(height: 2)
        }
    }
    
    private func textBoxView() -> some View {
        
        let text = textManager.splitTextInfoChunks(setModel.definition)
        
        return VStack(alignment: .leading) {
            ForEach(text, id: \.self) { chunk in
                Text(chunk)
                    .font(Font(WantedFont.midFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .detailGrayColor))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func relative() -> some View {
        VStack {
            HStack {
                Text("관련 컨텐츠")
                    .font(Font(WantedFont.semiFont.font(size: 20)))
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(setModel.relatedVideos, id: \.link) { urlEntity in
                        VStack(alignment: .leading) {
                            DownImageView(url: urlEntity.thumbnailURL, option: .max)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(urlEntity.title)
                                .font(Font(WantedFont.midFont.font(size: 15)))
                                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                                .lineLimit(1)
                            Text(urlEntity.channel)
                                .font(Font(WantedFont.midFont.font(size: 15)))
                                .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                                .lineLimit(1)
                        }
                        .frame(width: 170)
                        .asButton {
                            selectedURL(urlEntity.link)
                        }
                    }
                }
            }
        }
    }
    
    private func crossImage() -> some View {
        Group {
            if !isExtend {
                Image(ImageType.OtherImage.chevronDown.rawValue)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                   
            } else {
                Image(ImageType.OtherImage.chevronUp.rawValue)
                    .resizable()
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

//#if DEBUG
//#Preview {
//    MemeExtendView(selectedURL: { text in
//        print(text)
//    }, setModel: .init(
//        name: "뮤지컬네",
//        definition: "뮤지컬 + 아이네",
//        description: "아이네님이 뮤지컬 관련 노가리 및 노래를 부르면서 자연스럽게 자리 잡은 별명이다.",
//        synonyms: [
//            "뮤지컬 아이네"
//          ],
//        relatedVideos: [
//            .init(
//                link: "https://www.youtube.com/watch?v=bwgR3hAR7nQ",
//                title: "방송에서 부른 Popular (뮤지컬 위키드)",
//                thumbnailURL: URL(string: "https://i.ytimg.com/vi/bwgR3hAR7nQ/maxresdefault.jpg"),
//                channel: "데친 숙주나물",
//                type: .youtube
//            ),
//            .init(
//                link: "https://www.youtube.com/watch?v=_0tU0gkma_w",
//                title: "방송에서 부른 에델바이스 화음 넣기",
//                thumbnailURL: URL(string: "https://i.ytimg.com/vi/_0tU0gkma_w/maxresdefault.jpg"),
//                channel: "데친 숙주나물",
//                type: .youtube
//            )
//        ],
//        isDetectable: true,
//        id: 467,
//        duplicates: [],
//        appearanceTime: 37)
//    )
//}
//#endif
