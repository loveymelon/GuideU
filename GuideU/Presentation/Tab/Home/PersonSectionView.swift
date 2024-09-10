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
    private let textManager = TextFormatManager()
   
    var rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    var selectedURL: (String) -> Void
    
    let setModel: YoutubeCharacterEntity
    
    var body: some View {
        VStack {
            if !isExtend {
                notExpendView()
                    .padding(.all, 10)
            } else {
                expendView()
                    .padding(.all, 10)
            }
        }
    }
}

extension PersonSectionView {
    
    private func notExpendView() -> some View {
        HStack {
            // 프로필 이미지
            profileImage(size: CGSize(width: 40, height: 42))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(setModel.name)
                        .font(Font(WantedFont.boldFont.font(size: 18)))
                    Spacer()
                    crossImage()
                }
                // 설명
                Text(setModel.definition)
                    .font(Font(WantedFont.regularFont.font(size: 14)))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                    .lineLimit(1)
            }
        }
    }
    
    private func expendView() -> some View {
        ZStack(alignment: .topTrailing) {
            HStack {
              Spacer()
                crossImage()
            }
            VStack(spacing: 14) {
                HStack {
                    profileImage(size: CGSize(width: 50, height: 52))
                    Text(setModel.name)
                        .font(Font(WantedFont.midFont.font(size: 19)))
                        .padding(.leading, 6)
                    Spacer()
                }
                textBoxView()
                
                socialView()
                
                // relative()
            }
        }
    }
    
    private func textBoxView() -> some View {
        
        let text = textManager.splitTextInfoChunks(setModel.definition)
        
        return VStack {
            ForEach(text, id: \.self) { chunk in
                Text(chunk)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 8)
        .background(Color(GuideUColor.ViewBaseColor.light.depth1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func socialView() -> some View {
        LazyVGrid(columns: rows) {
            ForEach(setModel.links, id: \.self) { item in
                socialElementView(item: item)
            }
        }
    }
    
    private func relative() -> some View {
        VStack {
            HStack {
                Text("관련 컨텐츠")
                    .font(Font(WantedFont.semiFont.font(size: 20)))
                    .padding(.horizontal, 10)
                Spacer()
            }
            
            /// 관련된 컨텐츠
            
        }
    }
    
    private func socialElementView(item: LinkEntity) -> some View {
        VStack {
            switch item.type {
            case .afreeca:
                HStack {
                    Image.SocialImages.soop.img
                    Text("숲(아프리카tv)")
                        .padding(.leading, 8)
                    Spacer()
                }
            case .instagram:
                HStack {
                    Image.SocialImages.instagram.img
                    Text("인스타 그램")
                        .padding(.leading, 8)
                    Spacer()
                }
            case .twitter:
                HStack {
                    Image.SocialImages.twitterX.img
                    Text("X(트위터)")
                        .padding(.leading, 8)
                    Spacer()
                }
            case .youtube:
                HStack {
                    Image.SocialImages.youtube.img
                    Text("메인 유튜브")
                        .padding(.leading, 8)
                    Spacer()
                }
            default :
                EmptyView()
            }
        }
        .font(Font(WantedFont.midFont.font(size: 17)))
        .padding(.horizontal, 10)
        .asButton {
            selectedURL(item.link)
        }
    }

    private func profileImage(size: CGSize) -> some View {
        DownImageView(url: setModel.smallImageURL, option: .max, fallbackURL: setModel.largeImageURL)
            .frame(width: size.width, height: size.height)
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .background {
                ZStack {
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
                    Text("준비중")
                        .font(Font(WantedFont.blackFont.font(size: 10)))
                        .foregroundStyle(.white.opacity(0.9))
                }
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

//#if DEBUG
//#Preview {
//    let model: YoutubeCharacterEntity = .init(
//        name: "릴파",
//        engName: "LILPA",
//        definition: "뛰어난 가창력과 듣기만 해도 속이 뚫리는 시원한 고음과 뛰어난 춤 실력을 보여주는 다재다능한 노력파 아이돌이다. 또한 뛰어난 창의성을 바탕으로 다양하고 신박한 컨텐츠와 신기술을 바탕으로 이세돌에서 처음 페이셜을 도입하는 등 새로운 것에 도전하는 모습도 보여준다.",
//        smallImageURL: URL(string: "https://yt3.googleusercontent.com/TfNiEYiPS4wX6BWXerod80xL3pB8RvRLHiEDiPTPo1ZOIsgYivENAGTu2Sax_YJ-8g9SCHtvFw=s176-c-k-c0x00ffffff-no-rj"),
//        largeImageURL: URL(string: "https://photo.waksight.com/%EC%9A%B0%EC%99%81%EA%B5%B3%EC%9D%B4%EC%84%B8%EB%8F%8C/%EB%A6%B4%ED%8C%8C-%ED%8E%BC%EC%B9%98%EA%B8%B0.png"),
//        links: [
//            .init(link: "https://www.youtube.com/channel/UC-oCJP9t47v7-DmsnmXV38Q", title: "릴파 lilpa", thumbnailURL: "https://yt3.googleusercontent.com/KD99tMo8AN4tlm409F2dG2QQ_JcKOS8GK94exkxyZrONuRI_-lI2TbRQKzI46jcAh5hbqG0uqPw=s900-c-k-c0x00ffffff-no-rj", channel: "릴파 lilpa", type: .youtube, description: nil, createdAt: nil),
//            .init(link: "https://www.youtube.com/channel/UC-oCJP9t47v7-DmsnmXV38Q", title: "릴파 lilpa", thumbnailURL: "https://yt3.googleusercontent.com/KD99tMo8AN4tlm409F2dG2QQ_JcKOS8GK94exkxyZrONuRI_-lI2TbRQKzI46jcAh5hbqG0uqPw=s900-c-k-c0x00ffffff-no-rj", channel: "릴파 lilpa", type: .afreeca, description: nil, createdAt: nil),
//            .init(link: "https://www.youtube.com/channel/UC-oCJP9t47v7-DmsnmXV38Q", title: "릴파 lilpa", thumbnailURL: "https://yt3.googleusercontent.com/KD99tMo8AN4tlm409F2dG2QQ_JcKOS8GK94exkxyZrONuRI_-lI2TbRQKzI46jcAh5hbqG0uqPw=s900-c-k-c0x00ffffff-no-rj", channel: "릴파 lilpa", type: .twitter, description: nil, createdAt: nil),
//            .init(link: "https://www.youtube.com/channel/UC-oCJP9t47v7-DmsnmXV38Q", title: "릴파 lilpa", thumbnailURL: "https://yt3.googleusercontent.com/KD99tMo8AN4tlm409F2dG2QQ_JcKOS8GK94exkxyZrONuRI_-lI2TbRQKzI46jcAh5hbqG0uqPw=s900-c-k-c0x00ffffff-no-rj", channel: "릴파 lilpa", type: .instagram, description: nil, createdAt: nil)
//        ])
//    PersonSectionView(setModel: model) { text in
//        print(text)
//    }
//}
//#endif

