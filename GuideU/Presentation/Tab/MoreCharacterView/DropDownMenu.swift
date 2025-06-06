//
//  DropDownMen.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/27/24.
//

import SwiftUI

/// GuidU 드롭다운 뷰
struct DropDownMenu: View {
    /// 해당 프로퍼티에 들어갈 옵션을 정해주세요
    let options: [String]
    /// 버튼의 대한 높이 입니다. 기본 50
    var buttonHeight: CGFloat  =  50
    /// 최대 보여질 갯수를 지정합니다. 기본 3
    var maxItemDisplayed: Int  =  3
    
    /// 해당 인덱스를 통해 선택된 옵션을 가져오거나 정하세요
    @Binding
    var selectedOptionIndex: Int
    
    @Binding
    var showDropdown: Bool
    
//    @Environment(\.colorSystem) var colorSystem
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some  View {
        VStack {
            VStack(spacing: 0) {
                // selected item
                selectedItemView()
                .frame(height: buttonHeight, alignment: .leading)
                ifShowDownView()
            }
            .foregroundStyle(.black)
        }
        .zIndex(102)
    }
}
extension DropDownMenu {
    
    @ViewBuilder
    private func ifShowDownView() -> some View {
        if showDropdown {
            let scrollViewHeight: CGFloat = dropDownViewHeight()
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        ForEach(0..<options.count, id: \.self) { index in
                            openSelectedItemView(index: index, proxy: proxy)
                                .id(index)
                                .padding(.horizontal, 10)
                                .frame(height: buttonHeight, alignment: .leading)
                        }
                    }
                }
                .scrollDisabled(options.count <=  3)
                .frame(height: scrollViewHeight)
                .zIndex(103)
                .background(colorSystem.color(colorCase: .cellBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onAppear {
                    proxy.scrollTo(selectedOptionIndex)
                }
            }
        }
    }
    
    private func openSelectedItemView(index: Int, proxy: ScrollViewProxy) -> some View {
        Button(action: {
            withAnimation {
                selectedOptionIndex = index
                showDropdown.toggle()
            }
        }, label: {
            HStack {
                Spacer()
                Text(options[index])
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    .font(Font(WantedFont.semiFont.font(size: 18)))
                Spacer()
            }
        })
    }
    
    private func selectedItemView() -> some View {
        VStack {
            Button{
                withAnimation {
                    showDropdown.toggle()
                }
            } label: {
                VStack(spacing: 0) {
                    HStack(spacing: nil) {
                        if options[selectedOptionIndex] == Const.Channel.all.mainTitle {
                            Text(options[selectedOptionIndex])
                                .font(Font(WantedFont.boldFont.font(size: 21)))
                        } else {
                            Text(options[selectedOptionIndex])
                                .font(Font(WantedFont.boldFont.font(size: 21)))
                        }
                        
                        Spacer()
                        Image(ImageType.OtherImage.dropDownButton)
                            .rotationEffect(.degrees((showDropdown ?  -180 : 0)))
                    }
                    .padding(.bottom, 4)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(Color(GuideUColor.ViewBaseColor.light.primary))
                }
            }
        }
    }
}

extension DropDownMenu {
    private func dropDownViewHeight() -> CGFloat {
        let condition = options.count > maxItemDisplayed
        return condition ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
    }
}
