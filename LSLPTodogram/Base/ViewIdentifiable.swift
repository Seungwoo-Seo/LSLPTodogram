//
//  ViewIdentifiable.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

protocol ViewIdentifiable {
    static var identifier: String {get}
}

extension UITableViewCell: ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
