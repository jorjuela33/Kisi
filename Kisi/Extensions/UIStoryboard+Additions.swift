//
//  UIStoryboard+Additions.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

extension UIStoryboard {

    enum StoryboardName: String {
        case main = "Main"
    }

    // MARK: Initialization

    convenience init(storyBoardName: StoryboardName, bundle: Bundle? = nil) {
        self.init(name: storyBoardName.rawValue, bundle: bundle)
    }

    // MARK: Instance methods

    func instantiateViewController<T: UIViewController>() -> T where T: StoryBoardIdentifiable {
        guard let viewController = instantiateViewController(withIdentifier: T.storyBoardIdentifier) as? T else {
            fatalError("Unable instantiate the VC")
        }

        return viewController
    }
}
