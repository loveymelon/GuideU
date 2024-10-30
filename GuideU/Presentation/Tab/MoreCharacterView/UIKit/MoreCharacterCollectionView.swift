//
//  MoreCharacterCollectionView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/30/24.
//

import SwiftUI

final class MoreCharacterCollectionView: UICollectionViewController {
    
    var data: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentIndex: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ViewWrappingUIKitCellView.self, forCellWithReuseIdentifier: ViewWrappingUIKitCellView.identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + 1 // ("헤더")
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewWrappingUIKitCellView.identifier, for: indexPath) as? ViewWrappingUIKitCellView else {
//            return UICollectionViewCell()
//        }
//        
//        if indexPath.item == 0 {
////            cell.configure(with: A)
//        }
//        
//    }
    
}
