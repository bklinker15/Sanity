//
//  TransactionClassUnitTests.swift
//  SanityUnitTests
//
//  Created by Jordan Coppert on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity
class TransactionClassUnitTests: XCTestCase {
    var transactionToTest:Transaction!
    override func setUp() {
        super.setUp()
        transactionToTest = Transaction(memo: "Milk", linkedBudgets: ["Spending"],
                                     paymentMethod: "cash", amount: 25, timestamp: Date())
    }
    
    override func tearDown() {
        transactionToTest = nil
        super.tearDown()
    }
    
    func testFirestoreSerializableConstructor(){
        let transactionData: [String : Any] = ["memo":"Milk", "linkedBudgets": ["Spending"],
                                               "paymentMethods": "cash", "amount": 25.00,
                                               "timestamp":Date()]
        let newTransaction = Transaction(dictionary: transactionData)
        XCTAssertEqual(transactionToTest.memo, newTransaction?.memo)
    }
    
    func testFirestoreSerializablBadDataExpectedField() {
        let transactionData: [String : Any] = ["memo":"Milk", "linkedBudgets": ["Spending"],
                                               "paymentMethodzxfzxfzxfs": "cash", "amount": 25.00,
                                               "timestamp":Date()]
        let newTransaction = Transaction(dictionary: transactionData)
        XCTAssertNil(newTransaction)
    }
    
    func testFirestoreSerializableInsufficientFields() {
        let transactionData: [String : Any] = ["memo":"Milk"]
        let newTransaction = Transaction(dictionary: transactionData)
        XCTAssertNil(newTransaction)
    }
    
}
