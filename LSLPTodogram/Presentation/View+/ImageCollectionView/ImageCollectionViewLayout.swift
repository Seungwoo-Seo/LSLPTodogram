//
//  ImageCollectionViewLayout.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/26.
//

import UIKit

enum ImageCollectionViewLayout {
    case one(size: CGSize)
    case many(size: CGSize)

    var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        switch self {
        case .one(let size):
            layout.itemSize = size
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .many(let size):
            layout.itemSize = size
            layout.sectionInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 8)
        }

        return layout
    }

}
