//
//  AddBudgetUITests.swift
//  SanityUITests
//
//  Created by Brooks Klinker on 10/28/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity

class AddBudgetUITests: XCTestCase {
    var app: XCUIApplication!
    let username:String = "coppert@usc.edu"
    let password:String = "tester"
        
    override func setUp() {
        super.setUp()
        
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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddRemoveFields() {
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Budget"].tap()
        let tablesQuery = app.tables

        let startNumFields = tablesQuery.cells.children(matching: .textField).count

        let addCategoryButton = app.buttons["Add Category"]
        addCategoryButton.tap()
        addCategoryButton.tap()
        // Check for four new text fields - two per each new added cell
        XCTAssert(tablesQuery.cells.children(matching: .textField).count == startNumFields + 4)

        let removeCategoryButton = app.buttons["Remove Category"]
        removeCategoryButton.tap()
        XCTAssert(tablesQuery.cells.children(matching: .textField).count == startNumFields + 2)
    }
    
    func testCategoryNameConflict(){
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Budget"].tap()
        
        let createBudgetButton = app.buttons["Create Budget"]

        let nameField = app.textFields["budgetNameField"]
        nameField.tap()
        nameField.typeText("name")
        
        let tablesQuery = app.tables
        let categoryTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Category"]/*[[".cells.textFields[\"Category\"]",".textFields[\"Category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        categoryTextField.tap()
        categoryTextField.tap()
        
        let cellsQuery = tablesQuery.cells
        cellsQuery.children(matching: .textField).element(boundBy: 0).typeText("c")
        
        let limitTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Limit"]/*[[".cells.textFields[\"Limit\"]",".textFields[\"Limit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        limitTextField.tap()
        cellsQuery.children(matching: .textField).element(boundBy: 1).typeText("1")
        app.buttons["Add Category"].tap()
        categoryTextField.tap()
        tablesQuery.cells.containing(.textField, identifier:"Limit").children(matching: .textField).element(boundBy: 0).typeText("c")
        limitTextField.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element(boundBy: 1).typeText("2")
       
        createBudgetButton.tap()
        
        let dismissButton = app.alerts["Oops!"].buttons["Dismiss"]
        XCTAssert(dismissButton.exists)
        
    }
    
    func testBlankField() {
        let randomNum = (Int(arc4random_uniform(10000)))
        let budgetName = "UItest\(randomNum)"
        
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Budget"].tap()
        
        //All blank
        let createBudgetButton = app.buttons["Create Budget"]
        createBudgetButton.tap()
        let dismissButton = app.alerts["Oops!"].buttons["Dismiss"]
        XCTAssert(dismissButton.exists)
        dismissButton.tap()
        
        //Blank category and limit
        let nameField = app.textFields["budgetNameField"]
        nameField.tap()
        nameField.typeText(budgetName)
        createBudgetButton.tap()
        XCTAssert(dismissButton.exists)
        dismissButton.tap()
        
        //Blank limit
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Category"]/*[[".cells.textFields[\"Category\"]",".textFields[\"Category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let cellsQuery = tablesQuery.cells
        cellsQuery.children(matching: .textField).element(boundBy: 0).typeText("category")
        
        let textField2 = cellsQuery.children(matching: .textField).element(boundBy: 1)
        createBudgetButton.tap()
        XCTAssert(dismissButton.exists)
        dismissButton.tap()
    
        //Blank notification threshold
        textField2.tap()
        textField2.typeText("20")
        createBudgetButton.tap()
        XCTAssert(dismissButton.exists)
        dismissButton.tap()
        
        //No Blanks
        let notifField = app.textFields["thresholdField"]
        notifField.tap()
        notifField.typeText("10")
        
        createBudgetButton.tap()
        
        XCTAssert(!dismissButton.exists)
    }
    
}
