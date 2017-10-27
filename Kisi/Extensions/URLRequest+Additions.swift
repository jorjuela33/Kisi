//
//  URLRequest+Additions.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

extension URLRequest {

    // MARK: Initialization

    init(url: URL, method: HTTPMethod, contentType: ContentType = .json) {
        self.init(url: url)
        self.httpMethod = method.rawValue
        setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        setValue("keep-alive", forHTTPHeaderField: "Connection")
    }

    // MARK: Static methods

    static func authenticated(_ url: URL,
                              method: HTTPMethod,
                              contentType: ContentType = .json,
                              currentServer: Server = Server.current()) -> URLRequest {
        
        var request = URLRequest(url: url, method: method, contentType: contentType)
        request.setValue("KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c", forHTTPHeaderField: "Authorization")
        return request
    }
}
