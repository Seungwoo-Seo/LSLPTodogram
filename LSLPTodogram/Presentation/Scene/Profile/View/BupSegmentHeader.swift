//
//  BupSegmentHeader.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit
import RxSwift

final class BupSegmentHeader: BaseTableViewHeaderFooterView {
    var disposeBag = DisposeBag()
    
    let underlineSegmentedControl = UnderlineSegmentedControl(items: ["Bup", "답글", "리포스트"])

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(underlineSegmentedControl)
    }

    override func initialLayout() {
        super.initialLayout()

        underlineSegmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
