//
//  NotificationCenterManager.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/10.
//

import Foundation
import RxSwift

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(self.name).map { $0.object }
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
    }
}

enum NotificationCenterManager: NotificationCenterProtocol {
    case removeBup
    case custom

    var name: Notification.Name {
        switch self {
        case .removeBup:
            return Notification.Name("removeBup")
        case .custom:
            return Notification.Name("ApplicationNotificationCenter.custom")
        }
    }
}
