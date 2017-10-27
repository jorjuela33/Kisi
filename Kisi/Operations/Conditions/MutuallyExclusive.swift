//
//  MutuallyExclusive.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

struct MutuallyExclusive<T>: OperationCondition {

    static var name: String {
        return "MutuallyExclusive<\(T.self)>"
    }

    static var isMutuallyExclusive: Bool {
        return true
    }

    init() { }

    // MARK: OperationCondition

    public func dependency(for operation: Operation) -> Operation? {
        return nil
    }

    func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        completion(.satisfied)
    }
}

enum Alert {}
typealias AlertPresentation = MutuallyExclusive<Alert>
