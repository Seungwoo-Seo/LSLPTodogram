//
//  BupCellViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/04.
//

import Foundation

final class BupCellViewModel {
    let bup: Bup

    var baseImageUrls: [String]?
    var likeCache: (row: Int, status: Bool, bup: Bup)?

    init(bup: Bup) {
        self.bup = bup
    }
}
