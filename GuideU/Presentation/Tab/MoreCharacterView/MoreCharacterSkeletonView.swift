//
//  MoreCharacterSkeletonView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/23/24.
//

import SwiftUI

struct MoreCharacterSkeletonView: View {
    
    var body: some View {
        contentView()
    }
}

extension MoreCharacterSkeletonView {
    private func contentView() -> some View {
        VStack {
            mainImageView()
            sectionView()
                .padding(.horizontal, 10)
                .padding(.bottom, 8)
        }
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 6)
    }
    
    private func mainImageView() -> some View {
        Color.gray.opacity(0.8)
        .frame(height: 190)
        .frame(maxWidth: .infinity)
    }
    
    private func sectionView() -> some View {
        HStack {
            Color.gray.opacity(0.8)
                .frame(width: 40, height: 40)
                .aspectRatio(1, contentMode: .fill)
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                HStack {
                    Color.gray.opacity(0.8)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 50)
                        
                    Spacer()
                }
                HStack {
                    Color.gray.opacity(0.8)
                        .frame(width: 120, height: 12)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Spacer()
                }
                
            }
        }
    }
    
}
