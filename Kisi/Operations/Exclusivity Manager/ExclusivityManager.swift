//
//  ExclusivityManager.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

class ExclusivityManager {
    
    private let queue = DispatchQueue(label: "com.ravekit.ExclusivityManager")
    private var operations: [String: [KSOperation]] = [:]
    
    /// a shared instance of the controller
    static let shared = ExclusivityManager()
    
    // MARK: Initialization
    
    private init() {}
    
    // MARK: Instance methods
    
    /// Registers an operation as being mutually exclusive
    func add(_ operation: KSOperation, categories: [String]) {
        queue.sync {
            for category in categories {
                var operationsWithThisCategory = operations[category] ?? []
                if let last = operationsWithThisCategory.last {
                    operation.addDependency(last)
                }
                
                operationsWithThisCategory.append(operation)
                operations[category] = operationsWithThisCategory
            }
        }
    }
    
    /// Unregisters an operation from being mutually exclusive.
    func removeOperation(operation: KSOperation, categories: [String]) {
        queue.async {
            for category in categories {
                let matchingOperations = self.operations[category]
                
                if
                    /// the  operations category
                    var operationsWithThisCategory = matchingOperations,
                    
                    /// the index for the operation
                    let index = operationsWithThisCategory.index(of: operation) {
                    
                    operationsWithThisCategory.remove(at: index)
                    self.operations[category] = operationsWithThisCategory
                }
            }
        }
    }
}
