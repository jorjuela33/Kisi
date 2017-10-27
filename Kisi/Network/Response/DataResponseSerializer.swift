//
//  DataResponseSerializer.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

public struct DataResponseSerializer: ResponseSerializer {
    
    // MARK: ResponseSerializer
    
    public func serialize(request: URLRequest?,
                          response: HTTPURLResponse?,
                          data: Data, errors: [Error]) -> Result<Data> {

        if let error = errors.first { return Result.failure(error) }
        
        if let response = response, emptyResponseCodes.contains(response.statusCode) {
            return .success(data)
        }
        
        guard !data.isEmpty else {
            return .failure(URLRequestOperationError.inputDataNilOrZeroLength)
        }
        
        return .success(data)
    }
}
