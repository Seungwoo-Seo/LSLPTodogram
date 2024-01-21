//
//  UIImageView+RequestModifier.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/29.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {

    func requestModifier(with string: String) {
        let url = URL(string: NetworkBase.baseURL + string)
        let token = KeychainManager.read(key: KeychainKey.token.rawValue) ?? ""

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

    func requestModifier(with string: String, completion: @escaping (UIImage) -> Void) {
        let url = URL(string: NetworkBase.baseURL + string)
        let token = KeychainManager.read(key: KeychainKey.token.rawValue) ?? ""

        let modifier = AnyModifier { request in
            var r = request
            r.setValue(token, forHTTPHeaderField: "Authorization")
            r.setValue(NetworkBase.key, forHTTPHeaderField: "SesacKey")
            return r
        }

        kf.setImage(with: url, placeholder: nil, options: [.requestModifier(modifier)]) { result in
            switch result {
            case .success(let success):
                completion(success.image)
            case .failure(let error):
                print(error)
            }
        }
    }

}
