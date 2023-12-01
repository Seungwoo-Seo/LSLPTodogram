//
//  TodoAddCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit
import RxSwift

final class TodoAddCell: BaseTableViewCell {
    let todoAddButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.lightGray
        config.title = "todo Add..."
        let button = UIButton(configuration: config)
        return button
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

        contentView.addSubview(todoAddButton)
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        todoAddButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.height.equalTo(44)
        }
    }

}
