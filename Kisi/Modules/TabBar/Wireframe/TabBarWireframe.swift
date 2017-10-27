//
//  TabBarWireframe.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIStoryboard

class TabBarWireframe {

    private let operationQueue: NetworkingOperationQueue

    let presenter: TabBarPresenter
    var viewController: TabBarViewController?

    // MARK: Initialization

    init(presenter: TabBarPresenter, operationQueue: NetworkingOperationQueue) {
        self.operationQueue = operationQueue
        self.presenter = presenter
    }

    // MARK: Static methods

    static func createModule(_ operationQueue: NetworkingOperationQueue) -> TabBarViewController {
        let interactor = TabBarInteractor()
        let presenter = TabBarPresenter(interactor: interactor)
        let wireframe = TabBarWireframe(presenter: presenter, operationQueue: operationQueue)

        interactor.presenter = presenter
        return wireframe.createViewController()
    }
}

extension TabBarWireframe: Wireframe {

    // MARK: Wireframe

    func createViewController() -> TabBarViewController {
        let viewController: TabBarViewController = TabBarViewController()
        viewController.presenter = presenter
        viewController.viewControllers = [LocksWireframe.createModule(operationQueue), ProfileWireframe.createModule(operationQueue)]
        self.viewController = viewController
        return viewController
    }
}
