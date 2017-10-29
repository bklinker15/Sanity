//
//  BudgetHistoryUITests.swift
//  SanityUITests
//
//  Created by Nicholas Kaimakis on 10/28/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
import Firebase
@testable import Sanity

class BudgetHistoryUITests: XCTestCase {
    var app: XCUIApplication!
    let username:String = "coppert@usc.edu"
    let password:String = "tester"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBudgetHistoryDisplay() {
        //login
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
        
        //navigate to budget detail view
        let table = app.tables.element
        let cell = table.cells.element(boundBy: 0)
        cell.tap()
        
        //navigate to budget history view
        app.buttons["History"].tap()
        
        //check that table view of budget histories exists
        XCTAssert(app.tables.element.exists, "table view for budget history does not exist")
    }
}
