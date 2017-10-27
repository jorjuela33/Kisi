//
//  UnlockPresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol UnlockPresenterInterface: class {
    func dimiss()
    func unlock(_ identifier: Int)
}

class UnlockPresenter {

    let interactor: UnlockInteractorInput
    weak var interface: UnlockViewControllerInterface?
    var wireframe: UnlockWireframe?

    // MARK: Initialization

    required init(interactor: UnlockInteractorInput) {
        self.interactor = interactor
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
        interface?.hideLoadingIndicator()
        interface?.didUnlockDoor()
    }
}

extension UnlockPresenter: Presenter {}
