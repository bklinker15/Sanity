//
//  SettingsUITests.swift
//  SanityUITests
//
//  Created by Nicholas Kaimakis on 10/28/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity

class SettingsUITests: XCTestCase {
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
    
    func login(){
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
    }
    
    func testUpdateNotificationSettings() {
        login()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //change notification settings and save current setting
        let currentSetting:String = app.pickerWheels.element.value as! String
        app.pickerWheels.element.adjust(toPickerWheelValue: "none")
        app.buttons["update notification frequency"].tap()
        
        //then verify picker view index and confirmation field
        XCTAssert(app.staticTexts["settings saved"].exists, "problem testing update settings confirmation message")
        XCTAssertEqual(app.pickerWheels.element.value as! String, "none", "problem testing update settings picker view value")
        
        //change settings back to old value
        app.pickerWheels.element.adjust(toPickerWheelValue: currentSetting)
        app.buttons["update notification frequency"].tap()
    }
    
    func testUpdatePassword() {
        login()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //enter password and update
        let textField = app.textFields["newPassword"]
        textField.tap()
        textField.typeText("testing")
        let updatePasswordButton = app.buttons["update password"]
        updatePasswordButton.tap()
        
        //check confirmation field, must wait a few second for label to appear
        let predicate = NSPredicate(format: "exists == true")
        let query = app.staticTexts["password updated"]
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssert(app.staticTexts["password updated"].exists, "problem testing update password confirmation message")
        
        //change password back to initial value
        textField.tap()
        textField.typeText(password)
        updatePasswordButton.tap()
    }
    
    func testInvalidPasswordUpdate() {
        login()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //enter password and try to update
        let textField = app.textFields["newPassword"]
        textField.tap()
        textField.typeText("hi")
        let updatePasswordButton = app.buttons["update password"]
        updatePasswordButton.tap()
        
        //check confirmation field
        XCTAssert(app.staticTexts["password must be at least 6 characters long"].exists, "problem testing update password invalid message")
    }
    
    func testLogout() {
        login()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //tap logout button
        app.buttons["Logout"].tap()

        //check that we are back at login view after delay
        let predicate = NSPredicate(format: "exists == true")
        let query = app.staticTexts["sanity"]
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssert(app.staticTexts["sanity"].exists, "problem logging out from settings page")
    }
}
