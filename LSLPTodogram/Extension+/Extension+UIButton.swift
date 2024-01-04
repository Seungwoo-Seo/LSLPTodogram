//
//  Extension+UIButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/18.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {

    var title: Binder<String> {
        return Binder(base) { (button, title) in
            button.configuration?.title = title
        }
    }

}
