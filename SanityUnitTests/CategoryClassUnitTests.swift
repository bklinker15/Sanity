//
//  CategoryClassUnitTests.swift
//  SanityUnitTests
//
//  Created by Jordan Coppert on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity
class CategoryClassUnitTests: XCTestCase {
    
    var categoryToTest: Sanity.Category!
    override func setUp() {
        super.setUp()
        categoryToTest = Sanity.Category(name: "Groceries", paymentMethods: [],
                                         spendingLimit: 100, amountSpent: 0)
    }
    
    override func tearDown() {
        categoryToTest = nil
        super.tearDown()
    }
    
    func testFirestoreSerializableConstructor(){
        let categoryData: [String : Any] = ["name":"Groceries", "spendingLimit": 100.00,
                                            "amountSpent": 1.00]
        let newCategory = Category(dictionary: categoryData)
        XCTAssertEqual(categoryToTest.getName(), newCategory?.getName())
    }
    
    func testFirestoreSerializablBadDataExpectedField() {
        let categoryData: [String : Any] = ["name":"Groceries","spendingLimit":100,
                                            "ammountSpent": 0.00]
        let newCategory = Category(dictionary: categoryData)
        XCTAssertNil(newCategory)
    }
    
    func testFirestoreSerializableInsufficientFields() {
        let categoryData: [String : Any] = ["name":"Groceries"]
        let newCategory = Category(dictionary: categoryData)
        XCTAssertNil(newCategory)
    }
    
}
