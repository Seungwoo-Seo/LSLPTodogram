//
//  TodoInfo.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import Foundation
import UIKit

struct TodoInfo: Hashable, Identifiable {
    var profileImage: UIImage
    var nickname: String
    var title: String
    var todoList: [Todo] = []

    let id = UUID()
}
