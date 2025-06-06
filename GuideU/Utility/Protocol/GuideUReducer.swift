//
//  GuiduUReducer.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import Foundation

protocol GuideUReducer {
    
    associatedtype ViewCycleType
    
    associatedtype ViewEventType
    
    associatedtype DataTransType
}

protocol GuideUReducerOptional {
    associatedtype NetworkType
    
    associatedtype CancelId: Hashable
}
