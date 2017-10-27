//
//  ProfilePresenter.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol ProfilePresenterInterface {}

class ProfilePresenter {

    let interactor: ProfileInteractorInput
    weak var interface: ProfileTableViewInterface?
    var wireframe: ProfileWireframe?

    // MARK: Initialization

    required init(interactor: ProfileInteractorInput) {
        self.interactor = interactor
    }
}

extension ProfilePresenter: ProfileInteractorOutput {

    // MARK: ProfileInteractorOutput

}

extension ProfilePresenter: Presenter, ProfilePresenterInterface {}
