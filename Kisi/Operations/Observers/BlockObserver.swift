//
//  BlockObserver.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

struct BlockObserver: ObservableOperation {
    
    private let startHandler: ((KSOperation) -> Void)?
    private let produceHandler: ((KSOperation, Operation) -> Void)?
    private let finishHandler: ((KSOperation, [Error]) -> Void)?
    
    init(startHandler: ((KSOperation) -> Void)? = nil,
         produceHandler: ((KSOperation, Operation) -> Void)? = nil,
         finishHandler: ((KSOperation, [Error]) -> Void)? = nil) {
        
        self.startHandler = startHandler
        self.produceHandler = produceHandler
        self.finishHandler = finishHandler
    }
    
    // MARK: ObservableOperation
    
    func operationDidStart(_ operation: KSOperation) {
        startHandler?(operation)
    }
    
    func operation(_ operation: KSOperation, didProduceOperation newOperation: Operation) {
        produceHandler?(operation, newOperation)
    }
    
    func operationDidFinish(_ operation: KSOperation, errors: [Error]) {
        finishHandler?(operation, errors)
    }
}
