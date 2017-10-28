//
//  BackgroundObserver.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

class BackgroundObserver {

    private var backgroundHandler: BackgroundHandler
    private var identifier = UIBackgroundTaskInvalid
    private var isInBackground = false

    init(backgroundHandler: BackgroundHandler = UIApplication.shared) {
        self.backgroundHandler = backgroundHandler

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDidEnterBackgroundNotification(_:)),
                                               name: .UIApplicationDidEnterBackground,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDidEnterForegroundNotification(_:)),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)

        isInBackground = UIApplication.shared.applicationState == .background
        if isInBackground {
            startBackgroundTask()
        }
    }

    // MARK: Notification methods

    @objc func didReceiveDidEnterBackgroundNotification(_ notification: NSNotification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }

    @objc private func didReceiveDidEnterForegroundNotification(_ notification: Notification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }

    private func startBackgroundTask() {
        if identifier == UIBackgroundTaskInvalid {
            identifier = backgroundHandler.beginBackgroundTask(withName: "Background observer", expirationHandler: {
                 self.endBackgroundTask()
            })
        }
    }

    private func endBackgroundTask() {
        if identifier != UIBackgroundTaskInvalid {
            backgroundHandler.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskInvalid
        }
    }
}

extension BackgroundObserver: ObservableOperation {

    // MARK: Observable Operation

    func operationDidStart(_ operation: KSOperation) {}

    func operation(_ operation: KSOperation, didProduceOperation newOperation: Operation) {}

    func operationDidFinish(_ operation: KSOperation, errors: [Error]) {
        endBackgroundTask()
    }
}
