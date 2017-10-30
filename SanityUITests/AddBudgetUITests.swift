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
        
    }
    
    func testBlankField() {
        let randomNum = (Int(arc4random_uniform(10000)))
        let budgetName = "UItest\(randomNum)"
        
        let app = XCUIApplication()
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Budget"].tap()
        
        //All blank
        let createBudgetButton = app.buttons["Create Budget"]
        createBudgetButton.tap()
        let dismissButton = app.alerts["Oops!"].buttons["Dismiss"]
        XCTAssert(dismissButton.exists)
        dismissButton.tap()
        
        //Blank category and limit
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        let textField = element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        textField.typeText(budgetName)
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

        //No blanks
        textField2.tap()
        element.tap()
        textField2.tap()
        textField2.typeText("20")
        createBudgetButton.tap()
        
        XCTAssert(!dismissButton.exists)
    }
    
}
