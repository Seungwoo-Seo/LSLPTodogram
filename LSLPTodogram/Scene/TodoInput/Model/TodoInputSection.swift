//
//  TodoInputSection.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import Foundation
import RxDataSources

struct TodoInputSection {
    var items: [Item] = []
}

extension TodoInputSection: SectionModelType {
    typealias Item = TodoInputItemIdentifiable

    init(original: TodoInputSection, items: [Item]) {
        self = original
        self.items = items
    }
}
