//
//  Todo.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import Foundation

struct Todo: Hashable, Identifiable {
    var title: String

    let id = UUID()
}
