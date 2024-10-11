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
        contentView()
    }
}

extension ShareView {
    
    private func contentView() -> some View {
        ZStack {
            backgroundView()
            moveMainAppButtonView()
        }
    }
    
    private func backgroundView() -> some View {
        Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                justClose()
            }
    }
    
    private func moveMainAppButtonView() -> some View {
        VStack {
            Spacer()
            Group {
                if !viewModel.state.trigger {
                    Text(viewModel.state.loadingText)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 40)
                } else {
                    Button {
                        moveToMainApp()
                    } label: {
                        Text(viewModel.state.checkedText)
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
