//
//  BupContentAddCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit
import RxSwift

final class BupContentAddCell: BaseTableViewCell {
    let bupAddButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.lightGray
        config.title = "bup Add..."
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

        contentView.addSubview(bupAddButton)
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        bupAddButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.height.equalTo(44)
        }
    }

}
