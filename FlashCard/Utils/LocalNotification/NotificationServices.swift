//
//  NotificationServices.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import Foundation

struct NotificationCenterServices {
    
    private init() {}
    
    private let notificationCenter: NotificationCenter = .default
    
    static let shared = NotificationCenterServices()
    
    func addObserver(_ observer: Any, selector: Selector, noti: AppNotificationName, object: Any?) {
        notificationCenter.addObserver(observer, selector: selector, name: noti.name, object: object)
    }
    
    func post(noti: AppNotificationName, object: Any?, userInfo: [AnyHashable: Any]?) {
        notificationCenter.post(name: noti.name, object: object, userInfo: userInfo)
    }
    
    func post(noti: AppNotificationName, object: Any?) {
        notificationCenter.post(name: noti.name, object: object)
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }
}

enum AppNotificationName {
    
    case languageDidChange
    
    var name: Notification.Name {
        Notification.Name("App.\(String(describing: self))")
    }
}
