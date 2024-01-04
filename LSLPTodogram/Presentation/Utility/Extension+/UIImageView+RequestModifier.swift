//
//  UIImageView+RequestModifier.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/29.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {

    func requestModifier(
        with string: String,
        token: String
    ) {
        let url = URL(string: NetworkBase.baseURL + string)

        let modifier = AnyModifier { request in
            var r = request
            r.setValue(token, forHTTPHeaderField: "Authorization")
            r.setValue(NetworkBase.key, forHTTPHeaderField: "SesacKey")
            return r
        }

        kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "heart"),
            options: [.requestModifier(modifier)]
        )
    }

}
