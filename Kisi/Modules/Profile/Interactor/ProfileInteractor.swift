//
//  ProfileInteractor.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol ProfileInteractorInput: InteractorInput {}
protocol ProfileInteractorOutput: InteractorOutput {}

class ProfileInteractor {

    private let operationQueue: NetworkingOperationQueue

    weak var presenter: ProfileInteractorOutput?

    // MARK: Initialization

    init(operationQueue: NetworkingOperationQueue) {
        self.operationQueue = operationQueue
    }
}

extension ProfileInteractor: ProfileInteractorInput {}
