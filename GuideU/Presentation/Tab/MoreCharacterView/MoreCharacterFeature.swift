//
//  MoreCharacterFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoreCharacterFeature {
    
    @ObservableState
    struct State: Equatable {
        var dropDownOptions = Const.Channel.allCases
        var currentText = ""
        var currentIndex = 0
        
        let constViewState = ConstViewState()
    }
    
    struct ConstViewState: Equatable {
        let placeHolder =  "알고싶은 왁타버스 영상을 여기에"
        let main = "나는 왁타버스에서"
        let sub = "을 더 알아보고 싶어요."
        let targetString = "왁타버스"
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            
        }
        /// Binding
        case currentText(String)
        case currentIndex(Int)
        
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case onSubmit
    }
    
    enum DataTransType {
        
    }
    
    enum NetworkType {
        
    }
    
    var body: some ReducerOf<Self> {
       core()
    }
}

extension MoreCharacterFeature {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
             
            default:
                break
            }
            
            return .none
        }
    }
}
