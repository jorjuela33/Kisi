//
//  UnlockInteractor.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol UnlockInteractorInput: InteractorInput {
    func unlock(_ identifier: Int)
}

protocol UnlockInteractorOutput: InteractorOutput {
    func didFailUnlocking(_ errors: [Error])
    func didFinishUnlocking()
}

class UnlockInteractor {

    private var operationQueue: NetworkingOperationQueue

    weak var presenter: UnlockInteractorOutput?

    // MARK: Initialization

    init(operationQueue: NetworkingOperationQueue) {
        self.operationQueue = operationQueue
    }
}

extension UnlockInteractor: UnlockInteractorInput {

    // MARK: UnlockInteractorInput

    func unlock(_ identifier: Int) {
        let unlockOperation = UnlockOperation(identifier: identifier)
        unlockOperation.operationCompletionBlock { [unowned self] errors in
            guard errors.isEmpty else {
                self.presenter?.didFailUnlocking(errors)
                return
            }

            self.presenter?.didFinishUnlocking()
        }

        unlockOperation.queuePriority = .high
        operationQueue.addOperation(unlockOperation)
    }
}
