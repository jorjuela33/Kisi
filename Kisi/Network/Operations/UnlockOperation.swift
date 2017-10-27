//
//  UnlockOperation.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

final class UnlockOperation: KSOperation {

    private let operationQueue = OperationQueue()
    private var internalErrors: [Error] = []

    let dataRequestOperation: URLDataRequestOperation

    // MARK: Initialization

    init(identifier: Int, currentServer: Server = Server.current(), sessionManager: SessionManager = SessionManager.shared) {
        guard let url = currentServer.apiEndPoint?.appendingPathComponent("locks/\(identifier)/access") else { fatalError("Empty server endpoint") }

        let urlRequest = URLRequest.authenticated(url, method: .POST, currentServer: currentServer)
        let request = ParameterEncoding.json.encode(urlRequest, parameters: [:]).0
        dataRequestOperation = sessionManager.dataRequestOperation(with: request)

        operationQueue.isSuspended = true

        super.init()

        name = "Unlock Operation"
    }

    // MARK: Instance methods

    @discardableResult
    final func operationCompletionBlock(_ completionBlock: @escaping ([Error]) -> Void) -> Self {
        operationQueue.addOperation {
            DispatchQueue.main.async {
                completionBlock(self.internalErrors)
            }
        }

        return self
    }

    // MARK: Overrided methods

    override func finished(_ errors: [Error]) {
        internalErrors.append(contentsOf: errors)
        operationQueue.isSuspended = false
    }

    override func execute() {
        dataRequestOperation.responseJSON { [unowned self] result in
            self.finishWithError(result.error)
        }
        .validate(acceptableStatusCodes: [201])
        .resume()
    }
}
