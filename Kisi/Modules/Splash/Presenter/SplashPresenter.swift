//
//  SplashPresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol SplashPresenterInterface: class {
    func dismiss()
}

class SplashPresenter {

    let interactor: SplashInteractorInput
    weak var interface: SplashViewController?
    var wireframe: SplashWireframe?

    // MARK: Initialization

    required init(interactor: SplashInteractorInput) {
        self.interactor = interactor
    }
}

extension SplashPresenter: SplashPresenterInterface {

    // MARK: SplashPresenterInterface

    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.wireframe?.dismiss()
        }
    }
}

extension SplashPresenter: Presenter {}
