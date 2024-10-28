//
//  VideoCollectionView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/28/24.
//

import SwiftUI

struct VideoCollectionView: UIViewControllerRepresentable {
    var videos: [VideosEntity]
    var onAppear: (Int) -> Void
    
    func makeUIViewController(context: Context) -> UICollectionViewController {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let controller = UICollectionViewController(collectionViewLayout: layout)
        
        collectionView.delegate = context.coordinator
        controller.collectionView = collectionView
        controller.collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        controller.collectionView.dataSource = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
        context.coordinator.videos = videos
        uiViewController.collectionView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(videos: videos, onAppear: onAppear)
    }
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var videos: [VideosEntity]
        let onAppear: (Int) -> Void
        
        init(videos: [VideosEntity], onAppear: @escaping (Int) -> Void) {
            self.videos = videos
            self.onAppear = onAppear
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videos.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.configure(with: videos[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == videos.count - 1 { // 마지막 아이템에 도달 시 콜백 호출
                onAppear(indexPath.row)
            }
        }
    }
}

class VideoCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with video: VideosEntity) {
        titleLabel.text = video.title
    }
}
