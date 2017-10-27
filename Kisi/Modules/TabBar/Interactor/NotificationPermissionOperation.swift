//
//  NotificationPermissionOperation.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UserNotifications.UNUserNotificationCenter

final class NotificationPermissionOperation: KSOperation {

    // MARK: Initialization

    override init() {
        super.init()
        addCondition(AlertPresentation())
        name = "Notification Permission Operation"
    }

    // MARK: Overrided methods

    override func execute() {
        DispatchQueue.main.async {
            let options: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { [unowned self] _, error in
                self.finishWithError(error)
            })
        }
    }
}
