//
//  Server.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

private let kisiDevApiURL = URL(string: "https://api.getkisi.com")
private let kisiDotComApiURL = URL(string: "https://api.getkisi.com")

struct Server: Codable {
    
    enum Key: String {
        case serverEnviromentKey = "_ServerEnviromentKey"
    }
    
    /// the current URL
    let url: URL?
    
    /// the name for the server
    let name: String
    
    /// the version of the current server
    let version: Int

    /// the available servers
    static var servers: [Server] {
        return [
            Server(name: "Development", url: kisiDevApiURL),
            Server(name: "Production", url: kisiDotComApiURL)
        ]
    }

    /// Returns a instance of the development server
    static var development: Server {
        return Server(name: "Development", url: kisiDevApiURL)
    }

    /// The default server is initialized with the
    /// production URL
    static var production: Server {
        return Server(name: "Production", url: kisiDotComApiURL)
    }

    /// Returns the current URL with the api path
    var apiEndPoint: URL? {
        return url
    }

    /// the protection space for the current server
    var protectionSpace: URLProtectionSpace? {
        guard
            /// the server url
            let url = url,

            /// the url host
            let host = url.host else { return nil }

        return URLProtectionSpace(host: host,
                                  port: url.port ?? 0,
                                  protocol: url.scheme,
                                  realm: nil,
                                  authenticationMethod: nil)
    }
    
    // MARK: Initialization
    
    init(name: String, url: URL?, version: Int = 1) {
        self.name = name
        self.url = url
        self.version = version
    }
    
    // MARK: Class methods

    /// Returns the current server enabled
    static func current(userDefaultsStorable: UserDefaultsStorable = UserDefaults.standard) -> Server {
        guard
            /// the data
            let data = userDefaultsStorable.object(forKey: Key.serverEnviromentKey.rawValue) as? Data,

            /// the current server
            let server = try? JSONDecoder().decode(Server.self, from: data) else { return Server.development }

        return server
    }

    /// store the current server in the user default
    static func set(_ server: Server, userDefaultStorable: UserDefaultsStorable = UserDefaults.standard) {
        let data = try? JSONEncoder().encode(server)
        userDefaultStorable.set(data, forKey: Key.serverEnviromentKey.rawValue)
    }
}

extension Server: Equatable {

    static func == (lhs: Server, rhs: Server) -> Bool {
        return lhs.apiEndPoint == rhs.apiEndPoint && lhs.name == rhs.name && lhs.version == rhs.version
    }
}
