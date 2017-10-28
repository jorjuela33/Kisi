//
//  BackgroundManager.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/28/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIApplication

final class BackgroundManager {

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

    // MARK: Instance methods

    final func startBackgroundTask(_ name: String = "com.kisi.backgroundmanager") {
        if identifier == UIBackgroundTaskInvalid {
            identifier = backgroundHandler.beginBackgroundTask(withName: name, expirationHandler: {
                self.endBackgroundTask()
            })
        }
    }

    final func endBackgroundTask() {
        if identifier != UIBackgroundTaskInvalid {
            backgroundHandler.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskInvalid
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
}
