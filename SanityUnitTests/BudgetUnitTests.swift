//
//  BudgetUnitTests.swift
//  SanityUnitTests
//
//  Created by Brooks Klinker on 10/29/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity

class BudgetUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetLast6PeriodsMore() {
        let budget = Budget(name: "test", resetDate: Date(), lastReset: Date(), resetInterval: 0, totalBudget: 30, budgetRemaining: 30, previousBudgetRemains: [2.0, 4.2, 5.5, 4.3, 7.4, 5.3, 9.2], previousBudgetLimits: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0], notificationThreshold: 50.00)
        
        let lastSixLimits = budget.getPreviousSixBudgetLimits()
        let lastSixRemains = budget.getPreviousSixBudgetRemains()
        
        XCTAssert(lastSixLimits.count == 6, "Failed array count assert. Count was \(lastSixLimits.count)")
        XCTAssert(lastSixRemains.count == 6, "Failed array count assert. Count was \(lastSixRemains.count)")
        
        //Test front
        XCTAssert(lastSixRemains[0] == 4.2)
        XCTAssert(lastSixLimits[0] == 2.0)

        //Test back
        XCTAssert(lastSixLimits[5] == 7.0)
        XCTAssert(lastSixRemains[5] == 9.2)

    }
    
    func testGetLast6PeriodsExactly6(){
        let budget = Budget(name: "test", resetDate: Date(), lastReset: Date(), resetInterval: 0, totalBudget: 30, budgetRemaining: 30, previousBudgetRemains: [2.0, 4.2, 5.5, 4.3, 7.4, 5.0], previousBudgetLimits: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0], notificationThreshold: 50.00)
        
        let lastSixLimits = budget.getPreviousSixBudgetLimits()
        let lastSixRemains = budget.getPreviousSixBudgetRemains()
        
        XCTAssert(lastSixLimits.count == 6, "Failed array count assert. Count was \(lastSixLimits.count)")
        XCTAssert(lastSixRemains.count == 6, "Failed array count assert. Count was \(lastSixRemains.count)")
        
        //Test front
        XCTAssert(lastSixRemains[0] == 2.0)
        XCTAssert(lastSixLimits[0] == 1.0)
        
        //Test back
        XCTAssert(lastSixLimits[5] == 6.0)
        XCTAssert(lastSixRemains[5] == 5.0)
        
    }
    
    func testGetLast6PeriodsLessThan6(){
        let budget = Budget(name: "test", resetDate: Date(), lastReset: Date(), resetInterval: 0, totalBudget: 30, budgetRemaining: 30, previousBudgetRemains: [2.0, 4.2, 5.5], previousBudgetLimits: [1.0, 2.0, 4.0], notificationThreshold: 50.00)
        
        let lastSixLimits = budget.getPreviousSixBudgetLimits()
        let lastSixRemains = budget.getPreviousSixBudgetRemains()
        
        XCTAssert(lastSixLimits.count == 3, "Failed array count assert. Count was \(lastSixLimits.count)")
        XCTAssert(lastSixRemains.count == 3, "Failed array count assert. Count was \(lastSixRemains.count)")
        
        //Test front
        XCTAssert(lastSixRemains[0] == 2.0)
        XCTAssert(lastSixLimits[0] == 1.0)
        
        //Test back
        XCTAssert(lastSixLimits[2] == 4.0)
        XCTAssert(lastSixRemains[2] == 5.5)
        
    }
    
    
}
