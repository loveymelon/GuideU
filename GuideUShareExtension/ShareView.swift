//
//  ShareView.swift
//  GuideUShareExtension
//
//  Created by Jae hyung Kim on 10/6/24.
//

import SwiftUI

struct ShareView: View {
    
    @EnvironmentObject
    var viewModel: ShareViewModel
    
    var moveToMainApp: () -> Void
    var justClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    justClose()
                }
            
            VStack {
                
                Spacer()
                
                Group {
                    if !viewModel.state.trigger {
                        Text("불러오는 중입니다.")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 40)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Button {
                            moveToMainApp()
                        } label: {
                            Text("가이두에서 확인하기")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 40)
                        }
                    }
                }
                .padding(.bottom, 80)
            }
        }
    }
}
