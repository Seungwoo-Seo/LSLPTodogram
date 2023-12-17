//
//  Extension+UITextView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/15.
//

import UIKit
import RxSwift

extension Reactive where Base: UITextView {

    var textAndColor: Binder<(text: String?, color: UIColor)> {
        return Binder(base) { (textView, value) in
            textView.text = value.text
            textView.textColor = value.color
        }
    }

}
