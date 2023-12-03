//
//  TodoInputCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit
import RxCocoa
import RxSwift

final class TodoInputCell: BaseTableViewCell {
    private let middlePointLabel = {
        let label = UILabel()
        label.text = "•"
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    let todoInputTextView = {
        let view = UITextView()
        view.text = "할 일..."
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialAttributes() {
        super.initialAttributes()

        selectionStyle = .none
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            middlePointLabel,
            todoInputTextView
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        middlePointLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todoInputTextView)
            make.leading.equalToSuperview().offset(offset)
        }

        todoInputTextView.snp.makeConstraints { make in
            make.leading.equalTo(middlePointLabel.snp.trailing).offset(offset)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

}
