//
//  AlertPresentable+Additions.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

extension AlertPresentable where Self: UIViewController {

    // MARK: Instance methods

    func showMessage(_ message: String, title: String = "Attention!") {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
