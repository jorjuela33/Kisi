//
//  TabBarPresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol TabBarPresenterInterface: class {}

class TabBarPresenter {

    let interactor: TabBarInteractorInput
    weak var interface: TabBarViewController?
    var wireframe: TabBarWireframe?

    // MARK: Initialization

    required init(interactor: TabBarInteractorInput) {
        self.interactor = interactor
        interactor.requestNotificationAccess()
    }
}

extension TabBarPresenter: Presenter, TabBarPresenterInterface, TabBarInteractorOutput {}
