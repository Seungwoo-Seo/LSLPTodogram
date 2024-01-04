//
//  BaseTableView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import UIKit

class BaseTableView: UITableView, Base {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialAttributes() {}

    func initialHierarchy() {}

    func initialLayout() {}

}
