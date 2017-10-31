//
//  AddTransactionUITests.swift
//  SanityUITests
//
//  Created by Jordan Coppert on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
import Firebase
@testable import Sanity
class AddTransactionUITests: XCTestCase {
    var app: XCUIApplication!
    let username:String = "coppert@usc.edu"
    let password:String = "tester"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
    }
    
    func testAddTransactionFields(){
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        let startNumFields = app.tables.cells.children(matching: .textField).count
        XCUIApplication().buttons["Add Transaction"].tap()
        XCTAssert(app.tables.cells.children(matching: .textField).count == startNumFields + 2)
    }
    
    func testRemoveTransactionFields() {
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        XCUIApplication().sheets["Add"].buttons["Transaction"].tap()
        
        let startNumFields = app.tables.cells.children(matching: .textField).count
        XCUIApplication().buttons["Add Transaction"].tap()
        XCUIApplication().buttons["Remove Transaction"].tap()
        XCTAssert(app.tables.cells.children(matching: .textField).count == startNumFields)
    }
    
    func testReturnToDashboardAndProperBudgetUpdate(){
        //Go through tables, cells, bound by gets the first index or row, then the text in there, and my ID
        //Accessibility Identifier is KEY
        var budgetRemaining = app.tables.cells.element(boundBy: 0).staticTexts["BudgetRemaining"].label
        budgetRemaining.remove(at: budgetRemaining.startIndex)
        let amountSpent = 1.00
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.cells.textFields["Amout Spent"]/*[[".cells",".textFields[\"Amout Spent\"]",".textFields[\"amountSpent\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,1]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.textFields["amountSpent"]/*[[".cells.textFields[\"amountSpent\"]",".textFields[\"amountSpent\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.typeText("\(amountSpent)")
        tablesQuery/*@START_MENU_TOKEN@*/.cells.textFields["What'd you buy?"]/*[[".cells.textFields[\"What'd you buy?\"]",".textFields[\"What'd you buy?\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.cells.children(matching: .textField).element(boundBy: 1).typeText("milk")
        app/*@START_MENU_TOKEN@*/.buttons["Add Transaction(s)"]/*[[".buttons[\"Add Transaction(s)\"]",".buttons[\"addTransaction\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        var newRemainder = app.tables.cells.element(boundBy: 0).staticTexts["BudgetRemaining"].label
        newRemainder.remove(at: newRemainder.startIndex)
        XCTAssert(Double(newRemainder)! + amountSpent == Double(budgetRemaining))
    }
    
}
