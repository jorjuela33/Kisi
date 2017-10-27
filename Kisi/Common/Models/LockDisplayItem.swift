//
//  LockDisplayItem.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

struct LockDisplayItem {
    let id: Int
    let description: String
    let name: String
    let uuid: String

    // MARK: Initialization

    init(id: Int, description: String, name: String, uuid: String) {
        self.id = id
        self.description = description
        self.name = name
        self.uuid = uuid
    }
}
