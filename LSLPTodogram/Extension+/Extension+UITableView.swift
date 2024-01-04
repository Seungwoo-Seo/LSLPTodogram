//
//  Extension+UITableView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/18.
//

import UIKit
import RxSwift

extension Reactive where Base: UITableView {

    var likeButtonUpdate: Binder<(row: Int, status: Bool, bup: Bup)> {
        return Binder(base) { tv, value in
            let cell = tv.cellForRow(at: IndexPath(row: value.row, section: 0)) as? BupCell

            if cell?.likeCache == nil {
                cell?.likeCache = value
            } else {
                cell?.likeCache = nil
            }

            cell?.bupView.communicationView.likeButton.isSelected = value.status


            if (value.bup.likes ?? []).contains(value.bup.creator.id) {
                if value.status {
                    cell?.bupView.communicationView.likeCountButton.configuration?.title = "\(value.bup.likes?.count ?? 0) 좋아요"

                } else {
                    cell?.bupView.communicationView.likeCountButton.configuration?.title = "\((value.bup.likes?.count ?? 0) - 1) 좋아요"
                }
            } else {
                if value.status {
                    cell?.bupView.communicationView.likeCountButton.configuration?.title = "\((value.bup.likes?.count ?? 0) + 1) 좋아요"

                } else {
                    cell?.bupView.communicationView.likeCountButton.configuration?.title = "\(value.bup.likes?.count ?? 0) 좋아요"
                }
            }
        }
    }

}
