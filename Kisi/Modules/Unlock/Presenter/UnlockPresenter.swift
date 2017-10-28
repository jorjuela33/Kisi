//
//  UnlockPresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UserNotifications.UNUserNotificationCenter
import UIKit.UIApplication

protocol UnlockPresenterInterface: class {
    func dimiss()
    func unlock(_ identifier: Int)
}

class UnlockPresenter {

    private var backgroundHandler: BackgroundHandler
    private var notificationPresentable: NotificationPresentable

    let interactor: UnlockInteractorInput
    weak var interface: UnlockViewControllerInterface?
    var wireframe: UnlockWireframe?

    // MARK: Initialization

    required init(interactor: UnlockInteractorInput,
                  backgroundHandler: BackgroundHandler = UIApplication.shared,
                  notificationPresentable: NotificationPresentable = UNUserNotificationCenter.current()) {

        self.backgroundHandler = backgroundHandler
        self.interactor = interactor
        self.notificationPresentable = notificationPresentable
    }

    // MARK: Private methods

    private final func presentLocalNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Success!"
        notificationContent.body = "Door Unlocked"

        let request = UNNotificationRequest(identifier: "Door Unlocked", content: notificationContent, trigger: nil)
        notificationPresentable.add(request, withCompletionHandler: nil)
    }
}

extension UnlockPresenter: UnlockPresenterInterface {

    // MARK: UnlockPresenterInterface

    func dimiss() {
        wireframe?.dismiss()
    }

    func unlock(_ identifier: Int) {
        interface?.showLoadingIndicator()
        interactor.unlock(identifier)
    }
}

extension UnlockPresenter: UnlockInteractorOutput {

    // MARK: UnlockInteractorOutput

    func didFailUnlocking(_ errors: [Error]) {
        let error = errors.first as? KSError
        let message = error?.message ?? "We are not able to unlock the door at this moment. Please try again later"
        interface?.hideLoadingIndicator()
        interface?.showErrorMessage(message)
    }

    func didFinishUnlocking() {
        if backgroundHandler.applicationState == .active {
            interface?.hideLoadingIndicator()
            interface?.didUnlockDoor()
        } else {
            presentLocalNotification()
        }
    }
}

extension UnlockPresenter: Presenter {}
