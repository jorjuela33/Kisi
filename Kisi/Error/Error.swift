//
//  Error.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

enum KSError: Error {
    case unlockFail
}

extension KSError {

    var message: String {
        switch self {
        case .unlockFail: return "We are not able to unlock the device at this moment."
        }
    }
}
