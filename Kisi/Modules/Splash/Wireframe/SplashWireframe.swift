//
//  SplashWireframe.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

class SplashWireframe {

    weak var viewController: SplashViewController?

    // MARK: Instance methods

    final func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Static methods

    static func createModule() -> SplashViewController {
        let interactor = SplashInteractor()
        let presenter = SplashPresenter(interactor: interactor)
        let wireframe = SplashWireframe()
        
        presenter.wireframe = wireframe
        return wireframe.createViewController(presenter)
    }
}

extension SplashWireframe: Wireframe {

    // MARK: Wireframe

    func createViewController(_ presenter: SplashPresenter) -> SplashViewController {
        let viewController: SplashViewController = UIStoryboard(storyBoardName: .main).instantiateViewController()
        viewController.presenter = presenter

        presenter.interface = viewController
        self.viewController = viewController
        return viewController
    }
}
