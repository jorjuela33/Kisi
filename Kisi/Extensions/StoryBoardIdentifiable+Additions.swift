//
//  StoryBoardIdentifiable+Additions.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UIViewController

extension StoryBoardIdentifiable where Self: UIViewController {

    static var storyBoardIdentifier: String {
        return String(describing: self)
    }
}
