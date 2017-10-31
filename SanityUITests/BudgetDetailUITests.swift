//
//  BudgetDetailUITests.swift
//  SanityUITests
//
//  Created by Katie Wasserman on 30/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest

class BudgetDetailUITests: XCTestCase {
    
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
        
        let table = app.tables.element
        let cell = table.cells.element(boundBy: 0)
        cell.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBudgetName() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(app.staticTexts["Adf"].exists, "problem displaying budget name")
    }
    
    func testBudgetCategories(){
        XCTAssert(app.staticTexts["Asdf"].exists, "problem displaying categories")
    }
    
    
    
}
