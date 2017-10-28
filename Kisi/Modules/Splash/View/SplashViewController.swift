//
//  SplashViewController.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var presenter: SplashPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SplashViewController: StoryBoardIdentifiable {}
