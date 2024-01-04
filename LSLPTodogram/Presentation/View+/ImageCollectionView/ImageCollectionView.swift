//
//  ImageCollectionView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/25.
//

import UIKit

final class ImageCollectionView: BaseCollectionView {

    init(collectionViewLayout: ImageCollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout.layout)
    }

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }

}
