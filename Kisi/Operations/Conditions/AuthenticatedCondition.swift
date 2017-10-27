//
//  AuthenticatedCondition.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

struct AuthenticatedCondition: OperationCondition {
    
    static var name: String = "Authenticated Condition"
    
    static var isMutuallyExclusive: Bool = false
    
    // MARK: Instance methods
    
    func dependency(for operation: Operation) -> Operation? {
        return nil
    }
    
    func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        completion(.satisfied)
    }
}
