//
//  UnlockWireframe.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

class UnlockWireframe {

    private let operationQueue: NetworkingOperationQueue
    private let identifier: Int

    let presenter: UnlockPresenter
    var viewController: UnlockViewController?

    // MARK: Initialization

    required init(presenter: UnlockPresenter, identifier: Int, operationQueue: NetworkingOperationQueue) {
        self.identifier = identifier
        self.operationQueue = operationQueue
        self.presenter = presenter
    }

    // MARK: Instance methods

    final func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Static methods

    static func createModule(_ identifier: Int, operationQueue: NetworkingOperationQueue) -> UnlockViewController {
        let interactor = UnlockInteractor(operationQueue: operationQueue)
        let presenter = UnlockPresenter(interactor: interactor)
        let wireframe = UnlockWireframe(presenter: presenter, identifier: identifier, operationQueue: operationQueue)

        interactor.presenter = presenter
        presenter.wireframe = wireframe
        return wireframe.createViewController()
    }
}

extension UnlockWireframe: Wireframe {

    // MARK: Wireframe

    func createViewController() -> UnlockViewController {
        let viewController: UnlockViewController = UIStoryboard(storyBoardName: .main).instantiateViewController()
        viewController.presenter = presenter
        viewController.identifier = identifier

        presenter.interface = viewController
        self.viewController = viewController
        return viewController
    }
}
