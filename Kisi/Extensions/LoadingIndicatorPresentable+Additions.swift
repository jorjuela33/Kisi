//
//  LoadingIndicatorPresentable+Additions.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import MBProgressHUD
import UIKit.UIViewController

extension LoadingIndicatorPresentable where Self: UIViewController {

    // MARK: Instance methods

    func hideLoadingIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func showLoadingIndicator() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
}
