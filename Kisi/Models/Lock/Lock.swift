//
//  Lock.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

struct Lock {
    let description: String
    let id: Int
    let latitude: Double
    let longitude: Double
    let major: UInt16
    let minor: UInt16
    let name: String
    let uuid: UUID
}

extension Lock: JSONMappeable {

    /// Allowable keys for `Lock`'s representation
    enum DictionaryKey: String {
        case description
        case id
        case latitude = "place.latitude"
        case longitude = "place.longitude"
        case major = "ibeacon_major"
        case minor = "ibeacon_minor"
        case name
        case uuid = "ibeacon_uuid"
    }

    // MARK: JSONMappeable

    init?(dictionary: JSONDictionary) {
        guard
            /// lock description
            let description = dictionary[DictionaryKey.description.rawValue] as? String,

            /// lock identifier
            let id = dictionary[DictionaryKey.id.rawValue] as? Int,

            /// latitude
            let latitude = dictionary[KeyPath(DictionaryKey.latitude.rawValue)] as? Double,

            /// longitude
            let longitude = dictionary[KeyPath(DictionaryKey.longitude.rawValue)] as? Double,

            /// lock name
            let name = dictionary[DictionaryKey.name.rawValue] as? String,

            /// uuid string
            let uuidString = dictionary[DictionaryKey.uuid.rawValue] as? String,

            /// uuid
            let uuid = UUID(uuidString: uuidString) else { return nil }

        self.description = description
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.major = dictionary[DictionaryKey.major.rawValue] as? UInt16 ?? 0
        self.minor = dictionary[DictionaryKey.minor.rawValue] as? UInt16 ?? 0
        self.name = name
        self.uuid = uuid
    }
}
