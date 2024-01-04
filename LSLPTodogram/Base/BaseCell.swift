//
//  BaseCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Base {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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


class BaseCollectionViewCell: UICollectionViewCell, Base {

    override init(frame: CGRect) {
        super.init(frame: frame)

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
