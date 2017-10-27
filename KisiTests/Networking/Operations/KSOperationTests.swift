//
//  KSOperationTests.swift
//  KisiTests
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import XCTest
@testable import Kisi

private struct OperationTestCondition: OperationCondition {
    
    let expectation: XCTestExpectation
    
    static var name: String = "OperationTestObserver"
    
    static var isMutuallyExclusive: Bool = false
    
    // MARK: Initialization
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    // MARK: OperationCondition
    
    func dependency(for operation: Operation) -> Operation? {
        return nil
    }
    
    func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        expectation.fulfill()
        completion(.satisfied)
    }
}

class KSOperationTests: KisiBaseTests {
    
    private let operationQueue = KSOperationQueue()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testThatConditionShouldBeInvoked() {
        /// Given
        let expectation = self.expectation(description: "Condition expectation")
        let operation = KSOperation()
        
        /// When
        operation.addCondition(OperationTestCondition(expectation: expectation))
        operationQueue.addOperation(operation)
        
        /// Then
        waitForExpectations(timeout: networkTimeout, handler: nil)
    }
    
    func testThatObserverShouldBeInvoked() {
        /// Given
        let expectation = self.expectation(description: "Observer expectation")
        let operation = KSOperation()
        var finishHandlerInvoked = false
        var produceHandlerInvoked = false
        var startHandlerInvoked = false
        
        /// When
        operation.addObserver(BlockObserver(startHandler: { _ in
            startHandlerInvoked = true
        }, produceHandler: { _, _ in
            produceHandlerInvoked = true
        }, finishHandler: { _, _ in
            finishHandlerInvoked = true
            expectation.fulfill()
        }))
        operation.produceOperation(Operation())
        operationQueue.addOperation(operation)
        
        /// Then
        waitForExpectations(timeout: networkTimeout, handler: nil)
        XCTAssertTrue(finishHandlerInvoked)
        XCTAssertTrue(produceHandlerInvoked)
        XCTAssertTrue(startHandlerInvoked)
    }
    
    func testThatOperationShouldFailForCondition() {
        /// Given
        let expectation = self.expectation(description: "Failed Condition expectation")
        let operation = KSOperation()
        var errors: [Error]?
        
        /// When
        operation.addObserver(BlockObserver(finishHandler: { _, conditionErrors in
            errors = conditionErrors
            expectation.fulfill()
        }))
        operation.addCondition(FailedCondition())
        operationQueue.addOperation(operation)
        
        /// Then
        waitForExpectations(timeout: networkTimeout, handler: nil)
        XCTAssertNotNil(errors)
        XCTAssertTrue(errors?.isEmpty == false)
    }
}
