//
//  BupContainer.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import Foundation

struct BupContainer: Hashable {
    let bupTop: BupTop
    let bupContents: [BupContent]
    let bupBottom: BupBottom

    let nextCursor: String

    let id = UUID()
}
