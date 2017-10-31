//
//  BudgetClassUnitTests.swift
//  SanityUnitTests
//
//  Created by Jordan Coppert on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity
class BudgetClassUnitTests: XCTestCase {
    var budgetToTest:Budget!
    override func setUp() {
        super.setUp()
        budgetToTest = Budget(name: "Spending", resetDate: Date(), lastReset: Date(),
                              resetInterval: 1, totalBudget: 150, budgetRemaining: 150,
                              previousBudgetRemains: [], previousBudgetLimits: [], notificationThreshold: 1)
    }
    
    override func tearDown() {
        budgetToTest = nil
        super.tearDown()
    }
    
    func testFirestoreSerializableConstructor(){
        let budgetData: [String : Any] = ["name":"Spending", "budgetRemaining":150.00,
                                          "totalBudget":150.00, "lastReset":Date(),
                                          "resetDate":Date(), "resetInterval":1,
                                          "notificationThreshold":1.0,
                                          "previousBudgetRemains":[12.00, 15.00],
                                          "previousBudgetLimits": [100.00]]
        let newBudget = Budget(dictionary: budgetData)
        XCTAssertEqual(budgetToTest.getName(), newBudget?.getName())
    }
    
    func testFirestoreSerializablBadDataExpectedField() {
        let budgetData: [String : Any] = ["name":"Spending", "budgetRemaining":150.00,
                                          "totalBudget":150.00, "lastReset":Date(),
                                          "resetDate":Date(), "resetInterval":1,
                                          "notificationThreshold":1,
                                          "previousBudgetRemains":[12.00, 15.00],
                                          "previousBudgetLimits": [100.00]]
        let newBudget = Budget(dictionary: budgetData)
        XCTAssertNil(newBudget)
    }
    
    func testFirestoreSerializableInsufficientFields() {
        let budgetData: [String : Any] = ["name":"Spending"]
        let newBudget = Budget(dictionary: budgetData)
        XCTAssertNil(newBudget)
    }
    
}
