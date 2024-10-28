//
//  ThreadCheckable.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/28/24.
//

import Foundation

protocol ThreadCheckable {}

extension ThreadCheckable {
    func checkedMainThread() {
        print(Thread.current)
        if OperationQueue.current == OperationQueue.main {
            print(#function, "OperationQueue: Running on the main thread")
        } else {
            print(#function, "OperationQueue: Running on a background thread")
        }
    }
}
