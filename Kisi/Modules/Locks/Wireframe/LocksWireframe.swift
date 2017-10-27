//
//  LocksWireframe.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

class LocksWireframe {

    private let operationQueue: NetworkingOperationQueue

    let presenter: LocksPresenter
    var viewController: UINavigationController?

    // MARK: Initialization

    required init(presenter: LocksPresenter, operationQueue: NetworkingOperationQueue) {
        self.operationQueue = operationQueue
        self.presenter = presenter
    }

    // MARK: Instance methods

    func presentUnlockView(_ identifier: Int) {
        let viewController = UnlockWireframe.createModule(identifier, operationQueue: operationQueue)
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    // MARK: Static methods

    static func createModule(_ operationQueue: NetworkingOperationQueue) -> UINavigationController {
        let interactor = LocksInteractor(locationManager: LocationManager(usage: .always), operationQueue: operationQueue)
        let presenter = LocksPresenter(interactor: interactor)
        let wireframe = LocksWireframe(presenter: presenter, operationQueue: operationQueue)

        interactor.presenter = presenter
        presenter.wireframe = wireframe
        return wireframe.createViewController()
    }
}

extension LocksWireframe: Wireframe {

    // MARK: Wireframe

    func createViewController() -> UINavigationController {
        let viewController: LocksTableViewController = UIStoryboard(storyBoardName: .main).instantiateViewController()
        viewController.presenter = presenter
        presenter.interface = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = navigationController
        return navigationController
    }
}
