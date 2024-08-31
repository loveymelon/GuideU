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
            GuidUSearchBarBottomLineView(currentText: $currentText, placeHolder: placeHolder, lineWidth: 1.4) {
                
            }
        }
    }
}


#if DEBUG
#Preview {
  SearchView()
}
#endif
