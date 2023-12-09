//
//  ViewModelType.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import Foundation
import RxRelay

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol BupViewModelType: ViewModelType {
    var bupContainerList: BehaviorRelay<[BupContainer]> {get}
}
