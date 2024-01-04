//
//  ImageCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/26.
//

import UIKit
import RxSwift

final class ImageCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()

    let imageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        return view
    }()

    let removeButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.white
        config.background.backgroundColor = Color.black.withAlphaComponent(0.12)
        config.cornerStyle = .capsule
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        config.image = UIImage(systemName: "xmark")
        let button = UIButton(configuration: config)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 8
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(inset)
        }
    }

}
