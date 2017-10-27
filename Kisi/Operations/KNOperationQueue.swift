//
//  KSOperationQueue.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

class KSOperationQueue: OperationQueue {
    
    weak var delegate: OperationQueueDelegate?
    
    // MARK: Instance methods
    
    /// adds the operations to the queue
    func addOperations(_ ops: [Operation]) {
        for operation in ops {
            addOperation(operation)
        }
    }
    
    // MARK: Overrided methods
    
    override func addOperation(_ operation: Operation) {
        if let operation = operation as? KSOperation {
            operation.addObserver(self)
            
            let dependencies = operation.conditions.flatMap({ $0.dependency(for: operation) })
            
            for operationDependency in dependencies {
                operation.addDependency(operationDependency)
                addOperation(operationDependency)
            }
            
            let concurrencyCategories: [String] = operation.conditions.flatMap({ condition in
                if type(of: condition).isMutuallyExclusive == false { return nil }
                
                return "\(type(of: condition))"
            })
            
            if concurrencyCategories.isEmpty == false {
                ExclusivityManager.shared.add(operation, categories: concurrencyCategories)
                operation.addObserver(BlockObserver { operation, _ in
                    ExclusivityManager.shared.removeOperation(operation: operation, categories: concurrencyCategories)
                })
            }
            
            operation.willEnqueue()
        } else {
            operation.completionBlock = { [weak self, weak operation] in
                guard let queue = self, let operation = operation else { return }
                
                queue.delegate?.operationQueue(queue, operationDidFinish: operation, withErrors: [])
            }
        }
        
        delegate?.operationQueue(self, willAddOperation: operation)
        super.addOperation(operation)
    }
}

extension KSOperationQueue: ObservableOperation {
    
    // MARK: ObservableOperation
    
    func operation(_ operation: KSOperation, didProduceOperation newOperation: Operation) {
        addOperation(newOperation)
    }
    
    func operationDidFinish(_ operation: KSOperation, errors: [Error]) {
        delegate?.operationQueue(self, operationDidFinish: operation, withErrors: errors)
    }
    
    func operationDidStart(_ operation: KSOperation) { /* No OP */ }

}
