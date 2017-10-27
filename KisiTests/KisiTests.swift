//
//  KisiTests.swift
//  KisiTests
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import OHHTTPStubs
import XCTest
@testable import Kisi

class KisiBaseTests: XCTestCase {
    
    let networkTimeout: TimeInterval = 30.0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Instance methods

    /// Stubs the response for the given parameters
    ///
    /// path       - The URL path.
    /// fileName   - The json file name.
    /// statusCode - The status code for the response by default 200.
    /// headers    - The headers for the reponse
    func stubResponse(_ path: String, fileName: String, statusCode: Int32 = 200, headers: [String: String]? = nil) {
        var HTTPHeaders = ["Content-Type": "application/json"]
        if let headers = headers {
            HTTPHeaders = headers.lazy.reduce(HTTPHeaders, { result, pair in
                var x = result
                x[pair.0] = pair.1
                return x
            })
        }

        OHHTTPStubs.stubRequests(passingTest: {
            return $0.url?.path.contains(path) ?? false
        }) { _ in
            let fileURL = self.URLForResource(fileName, withExtension: "json")
            return  OHHTTPStubsResponse(fileURL: fileURL, statusCode: statusCode, headers: HTTPHeaders)
        }
    }

    /// Returns the URL for the given resource
    ///
    /// fileName      - The name of the resource to search
    /// withExtension - The extension of the file
    func URLForResource(_ fileName: String, withExtension: String) -> URL {
        let bundle = Bundle(for: KisiBaseTests.self)
        return bundle.url(forResource: fileName, withExtension: withExtension)!
    }
}
