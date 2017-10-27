//
//  TabBarInteractor.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol TabBarInteractorInput: InteractorInput {
    func requestNotificationAccess()
}

protocol TabBarInteractorOutput: InteractorOutput {}

class TabBarInteractor {

    private var operationQueue = KSOperationQueue()

    weak var presenter: TabBarInteractorOutput?
}

extension TabBarInteractor: TabBarInteractorInput {

    // MARK: TabBarInteractorInput

    func requestNotificationAccess() {
        let notificationPermissionOperation = NotificationPermissionOperation()
        operationQueue.addOperation(notificationPermissionOperation)
    }
}
