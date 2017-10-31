//
//  EditBudgetUITests.swift
//  SanityUITests
//
//  Created by Katie Wasserman on 30/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest

class EditBudgetUITests: XCTestCase {
        
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
        super.tearDown()
    }
    
    func testAddCategoryAppears() {
        // Use recording to get started writing UI tests.
        
        //app.tables/*@START_MENU_TOKEN@*/.staticTexts["Adf"]/*[[".cells.staticTexts[\"Adf\"]",".staticTexts[\"Adf\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        element.children(matching: .button)["Button"].tap()
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 1)
        let textField = cell.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("new")
        
        let textField2 = cell.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.typeText("50.00")
        cell.buttons["Button"].tap()
 
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBDeleteCategory() {
        // Use recording to get started writing UI tests.
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element(boundBy: 1).swipeLeft()
        tablesQuery.buttons["Delete"].tap()

    }
    
    func testCddCategoryAppearsInBudgetInfo() {
        // Use recording to get started writing UI tests.
        
        //app.tables/*@START_MENU_TOKEN@*/.staticTexts["Adf"]/*[[".cells.staticTexts[\"Adf\"]",".staticTexts[\"Adf\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Button"].tap()
        
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 1)
        let textField = cell.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("new")
        
        let textField2 = cell.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.typeText("20.00")
        cell.buttons["Button"].tap()
        app.navigationBars["Sanity.EditBudgetView"].buttons["Budgets"].tap()
        
        
        XCTAssert(app.staticTexts["new"].exists, "problem displaying added category")
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testDeleteCategoryAppears(){
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element(boundBy: 1).swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        
        
        app.navigationBars["Sanity.EditBudgetView"].buttons["Budgets"].tap()
        
        XCTAssert(!app.staticTexts["new"].exists, "problem displaying added category")
        
    }
    
    
    func testEditBudget(){

        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        let button = cell.buttons["Button"]
        button.tap()
        
        let textField = cell.children(matching: .textField).element(boundBy: 1)
        textField.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["Delete"]/*[[".keyboards.keys[\"Delete\"]",".keys[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        textField.typeText("200.00")
        button.tap()
        
    }
    
    func testFEditBudgetAppears(){
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        let button = cell.buttons["Button"]
        button.tap()
        
        let textField = cell.children(matching: .textField).element(boundBy: 1)
        textField.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["Delete"]/*[[".keyboards.keys[\"Delete\"]",".keys[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        textField.typeText("300.00")
        button.tap()
        
        app.navigationBars["Sanity.EditBudgetView"].buttons["Budgets"].tap()
        
       
    }


    
    
    
}
