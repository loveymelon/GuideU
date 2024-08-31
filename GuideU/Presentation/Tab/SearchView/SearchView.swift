//
//  SearchView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/31/24.
//

import SwiftUI


struct SearchView: View {
    
    @State var currentText = ""
    let placeHolder =  "알고싶은 왁타버스 영상을 여기에"
    
    var body: some View {
        VStack {
            fakeNavigation()
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            if currentText.isEmpty {
                currentListView()
                
            } else {
                searchListView()
            }
        }
    }
}

// MARK: 검색중인 텍스트가 존재하지 않았을때
extension SearchView {
    
    private func currentListView() -> some View {
        ScrollView {
            recentSectionView()
                .padding(.horizontal, 10)
            
        }
    }
}
// MARK: 검색중인 텍스트가 존재할 경우
extension SearchView {
    private func searchListView() -> some View {
        ScrollView {
            
        }
    }
}

// MARK: 최근 검색한 | 전체삭제
extension SearchView {
    private func recentSectionView() -> some View {
        HStack(alignment: .center) {
            Group {
                Text(Const.recentSection)
                    .font(Font(WantedFont.midFont.font(size: 15)))
                    
                Text("|")
                    .font(Font(WantedFont.midFont.font(size: 13)))
                    .offset(y: -1.5)
                Text(Const.allClear)
                    .font(Font(WantedFont.midFont.font(size: 15)))
                    .asButton {
                        /// 전체삭제 버튼 클릭시
                        
                    }
            }
            .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
            Spacer()
        }
    }
}

// MARK: 상단 네비게이션
extension SearchView {
    private func fakeNavigation()  -> some View {
        VStack {
            HStack {
                Image.appLogo
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 52)
                
                Spacer()
                Image.close
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .asButton {
                        /// 전뷰로 이동
                        
                    }
                    .frame(height: 32)
            }
            GuidUSearchBarBottomLineView(currentText: $currentText, placeHolder: placeHolder, lineWidth: 1.4) {
                /// onSubmit
                
            }
        }
    }
}


#if DEBUG
#Preview {
  SearchView()
}
#endif
