//
//  MarqueeTextView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

struct MarqueeTextView: View {
    
    let text: String
    let font: UIFont
    let leadingFade: CGFloat
    let trailingFade: CGFloat
    let startDelay: Double
    let alignment: Alignment
    
    @State private var animate = false
    
    public var body : some View {
        let stringSize = text.sizeOfString(usingFont: font)
        let stringWidth = stringSize.width
        let stringHeight = stringSize.height
        let nullAnimation = Animation
            .linear(duration: 0)
        
        return ZStack {
            GeometryReader { geo in
                WithPerceptionTracking {
                    let distance = stringWidth - geo.size.width
                    let animation = Animation
                        .linear(duration: Double(distance) / 30)
                        .delay(startDelay)
                        .repeatForever(autoreverses: true)
                    
                    if stringWidth > geo.size.width {
                        
                        Text(text)
                            .lineLimit(1)
                            .font(Font(font))
                            .offset(x: animate ? -(distance) : 0)
                            .animation(animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.animate = geo.size.width < stringWidth
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .onChange(of: self.text, perform: {text in
                                self.animate = geo.size.width < stringWidth
                            })
                            .offset(x: leadingFade )
                            .mask(
                                HStack(spacing:0) {
                                    Rectangle()
                                        .frame(width:2)
                                        .opacity(0)
                                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                        .frame(width: leadingFade)
                                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                        .frame(width: trailingFade)
                                    Rectangle()
                                        .frame(width:2)
                                        .opacity(0)
                                })
                            .frame(width: geo.size.width + leadingFade + trailingFade)
                            .offset(x: leadingFade * -1)
                    } else {
                        Text(self.text)
                            .font(.init(font))
                            .onChange(of: self.text, perform: {text in
                                self.animate = geo.size.width < stringWidth
                            })
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
                    }
                }
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: stringWidth)
        .onDisappear { self.animate = false }
    }
    
    init(text: String, font: UIFont, leading: CGFloat, trailing: CGFloat, startDelay: Double, alignment: Alignment? = nil) {
        self.text = text
        self.font = font
        self.leadingFade = leading
        self.trailingFade = trailing
        self.startDelay = startDelay
        self.alignment = alignment != nil ? alignment! : .topLeading
    }
}
