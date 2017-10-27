//
//  ProfileWireframe.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

class ProfileWireframe {

    private let operationQueue: NetworkingOperationQueue

    let presenter: ProfilePresenter
    var viewController: UINavigationController?

    // MARK: Initialization

    required init(presenter: ProfilePresenter, operationQueue: NetworkingOperationQueue) {
        self.operationQueue = operationQueue
        self.presenter = presenter
    }

    // MARK: Static methods

    static func createModule(_ operationQueue: NetworkingOperationQueue) -> UINavigationController {
        let interactor = ProfileInteractor(operationQueue: operationQueue)
        let presenter = ProfilePresenter(interactor: interactor)
        let wireframe = ProfileWireframe(presenter: presenter, operationQueue: operationQueue)

        interactor.presenter = presenter
        return wireframe.createViewController()
    }
}

extension ProfileWireframe: Wireframe {

    // MARK: Wireframe

    func createViewController() -> UINavigationController {
        let viewController: ProfileTableViewController = UIStoryboard(storyBoardName: .main).instantiateViewController()
        viewController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = navigationController
        return navigationController
    }
}
