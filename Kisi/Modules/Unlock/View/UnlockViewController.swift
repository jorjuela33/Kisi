//
//  UnlockViewController.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

protocol UnlockViewControllerInterface: LoadingIndicatorPresentable {
    func didUnlockDoor()
    func showErrorMessage(_ message: String)
}

class UnlockViewController: UIViewController {

    @IBOutlet private var lockView: LockView!

    var presenter: UnlockPresenterInterface?
    var identifier: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.unlock(identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UnlockViewController: UnlockViewControllerInterface {

    // MARK: UnlockViewControllerInterface

    func didUnlockDoor() {
        lockView.animate() {
            self.presenter?.dimiss()
        }
    }

    func showErrorMessage(_ message: String) {
        showMessage(message) {
            self.presenter?.dimiss()
        }
    }
}

extension UnlockViewController: AlertPresentable, LoadingIndicatorPresentable, StoryBoardIdentifiable {}
