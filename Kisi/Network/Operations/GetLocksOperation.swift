//
//  GetLocksOperation.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

final class GetLocksOperation: KSOperation {

    private let operationQueue = OperationQueue()
    private var internalErrors: [Error] = []
    private var locks: [Lock] = []

    let dataRequestOperation: URLDataRequestOperation

    // MARK: Initialization

    init(currentServer: Server = Server.current(), sessionManager: SessionManager = SessionManager.shared) {
        guard let url = currentServer.apiEndPoint?.appendingPathComponent("locks") else { fatalError("Empty server endpoint") }

        let urlRequest = URLRequest.authenticated(url, method: .GET, currentServer: currentServer)
        let request = ParameterEncoding.json.encode(urlRequest, parameters: nil).0
        dataRequestOperation = sessionManager.dataRequestOperation(with: request)

        operationQueue.isSuspended = true

        super.init()

        name = "Get Locks Operation"
    }

    // MARK: Instance methods

    @discardableResult
    final func operationCompletionBlock(_ completionBlock: @escaping ([Lock], [Error]) -> Void) -> Self {
        operationQueue.addOperation {
            DispatchQueue.main.async {
                completionBlock(self.locks, self.internalErrors)
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
            guard let JSONRecords = result.value as? [JSONDictionary] else {
                self.finishWithError(result.error)
                return
            }

            self.locks = JSONRecords.flatMap({ Lock(dictionary: $0) })
            self.finish()
        }
        .validate(acceptableStatusCodes: [200])
        .resume()
    }
}
