//
//  BupContentInputCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit
import RxCocoa
import RxSwift

final class BupContentInputCell: BaseTableViewCell {
    let bupContentInputTextView = {
        let view = UITextView()
        view.text = "할 일..."
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()

    var disposeBag = DisposeBag()

    func configure(_ item: BupContentInput) {
        bupContentInputTextView.text = item.content
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            bupContentInputTextView
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        bupContentInputTextView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(1)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }

}
