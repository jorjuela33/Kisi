//
//  LocksPresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol LocksPresenterInterface: class {
    func getLocks()
}

class LocksPresenter {

    let interactor: LocksInteractorInput
    weak var interface: LocksTableViewControllerInterface?
    var wireframe: LocksWireframe?

    // MARK: Initialization

    required init(interactor: LocksInteractorInput) {
        self.interactor = interactor
    }
}

extension LocksPresenter: LocksPresenterInterface {

    // MARK: LocksPresenterInterface

    func getLocks() {
        interactor.getLocks()
    }
}

extension LocksPresenter: LocksInteractorOutput {

    // MARK: LocksInteractorOutput

    func didFailFetchingLocks(_ errors: [Error]) {
        interface?.showErrorMessage("We are not able to fetch the locks at this moment")
    }

    func didFinishFetchingLocks(_ locks: [LockDisplayItem]) {
        interface?.didFinishFechingLocks(locks)
    }

    func didFoundLock(_ identifier: Int) {
        wireframe?.presentUnlockView(identifier)
    }

    func locationManagerDidFail(withError error: LocationManagerError) {
        interface?.showErrorMessage("We are not able to start the location updates")
    }

    func locationPermissionNotAuthorized() {
        interface?.showErrorMessage("Please go to settings and grant access to the location services")
    }
}

extension LocksPresenter: Presenter {}
