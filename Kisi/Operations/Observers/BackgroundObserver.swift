//
//  BackgroundObserver.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

struct BackgroundObserver {

    private var backgroundManager = BackgroundManager()
}

extension BackgroundObserver: ObservableOperation {

    // MARK: Observable Operation

    func operationDidStart(_ operation: KSOperation) {}

    func operation(_ operation: KSOperation, didProduceOperation newOperation: Operation) {}

    func operationDidFinish(_ operation: KSOperation, errors: [Error]) {
        backgroundManager.endBackgroundTask()
    }
}
