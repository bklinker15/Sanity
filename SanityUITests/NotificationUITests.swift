//
//  NotificationUITests.swift
//  SanityUITests
//
//  Created by Will Durkee on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
import Firebase
@testable import Sanity

class NotificationUITests: XCTestCase {
    var app: XCUIApplication!
    let username:String = "x@usc.edu"
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
    
    func login(){
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
    }
    
    func testCategoryExceededNotification() {
        //login
        login()
        
        //press add transaction
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //overdraw "candy" category but do not go over the threshold or budget limit
        
        let predicate = NSPredicate(format: "exists == true")
        let amountSpentTextField = app.textFields["amountSpent"]
        expectation(for: predicate, evaluatedWith: amountSpentTextField, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        
        amountSpentTextField.tap()
        amountSpentTextField.typeText("40")
        
        let addTransactionButton = app.buttons["addTransaction"]
        addTransactionButton.tap()
        
        
        //check that the notification alert comes up
        
        let predicate3 = NSPredicate(format: "exists == true")
        let categoryAlert = app.alerts["Category Exceeded!"]
        expectation(for: predicate3, evaluatedWith: categoryAlert, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssert(categoryAlert.exists, "Alert for category overage does not exist!")
        
        print("Made it to alert")
        
        app.alerts["Category Exceeded!"].buttons["OK"].tap()
        
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //overdraw "candy" category but do not go over the threshold or budget limit
        let predicate2 = NSPredicate(format: "exists == true")
        let amountSpentTextField2 = app.textFields["amountSpent"]
        expectation(for: predicate2, evaluatedWith: amountSpentTextField2, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        amountSpentTextField2.tap()
        amountSpentTextField2.typeText("-40")
        
        let addTransactionButton2 = app.buttons["addTransaction"]
        addTransactionButton2.tap()
    }
    
    func testThresholdExceededNotification() {
        //login
        login()
        
        //press add transaction
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //draw enough out of budget to pass the threshold
        
        let predicate = NSPredicate(format: "exists == true")
        let amountSpentTextField = app.textFields["amountSpent"]
        expectation(for: predicate, evaluatedWith: amountSpentTextField, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        
        amountSpentTextField.tap()
        amountSpentTextField.typeText("95")
        
        let addTransactionButton = app.buttons["addTransaction"]
        addTransactionButton.tap()
        
        
        //check that the notification alert comes up
        
        let predicate3 = NSPredicate(format: "exists == true")
        let threshAlert = app.alerts["Threshold Exceeded!"]
        expectation(for: predicate3, evaluatedWith: threshAlert, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssert(threshAlert.exists, "Alert for category overage does not exist!")
        
        print("Made it to alert")
        
        app.alerts["Threshold Exceeded!"].buttons["OK"].tap()
        
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //overdraw "candy" category but do not go over the threshold or budget limit
        let predicate2 = NSPredicate(format: "exists == true")
        let amountSpentTextField2 = app.textFields["amountSpent"]
        expectation(for: predicate2, evaluatedWith: amountSpentTextField2, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        amountSpentTextField2.tap()
        amountSpentTextField2.typeText("-95")
        
        let addTransactionButton2 = app.buttons["addTransaction"]
        addTransactionButton2.tap()
    }
    
    func testBudgetExceededNotification() {
        //login
        login()
        
        //press add transaction
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //draw enough out of budget to pass below or at 0
        
        let predicate = NSPredicate(format: "exists == true")
        let amountSpentTextField = app.textFields["amountSpent"]
        expectation(for: predicate, evaluatedWith: amountSpentTextField, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        
        amountSpentTextField.tap()
        amountSpentTextField.typeText("110")
        
        let addTransactionButton = app.buttons["addTransaction"]
        addTransactionButton.tap()
        
        
        //check that the notification alert comes up
        
        let predicate3 = NSPredicate(format: "exists == true")
        let threshAlert = app.alerts["Budget Exceeded!"]
        expectation(for: predicate3, evaluatedWith: threshAlert, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssert(threshAlert.exists, "Alert for category overage does not exist!")
        
        print("Made it to alert")
        
        app.alerts["Budget Exceeded!"].buttons["OK"].tap()
        
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 1).tap()
        app.sheets["Add"].buttons["Transaction"].tap()
        
        //overdraw "candy" category but do not go over the threshold or budget limit
        let predicate2 = NSPredicate(format: "exists == true")
        let amountSpentTextField2 = app.textFields["amountSpent"]
        expectation(for: predicate2, evaluatedWith: amountSpentTextField2, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        amountSpentTextField2.tap()
        amountSpentTextField2.typeText("-110")
        
        let addTransactionButton2 = app.buttons["addTransaction"]
        addTransactionButton2.tap()
    }
}

