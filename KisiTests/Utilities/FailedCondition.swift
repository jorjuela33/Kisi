//
//  FailedCondition.swift
//  KisiTests
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation
@testable import Kisi

struct FailedCondition: OperationCondition {
    
    static var name: String = "Failed Condition"
    
    static var isMutuallyExclusive: Bool = false
    
    // MARK: OperationCondition
    
    func dependency(for operation: Operation) -> Operation? {
        return nil
    }
    
    func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        completion(.failed(OperationError.executionFailed))
    }
}
