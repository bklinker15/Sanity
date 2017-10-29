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
    
    func testUpdateNotificationSettings() {
        //login
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //change notification settings
        app.pickerWheels.element.adjust(toPickerWheelValue: "none")
        app.buttons["update notification frequency"].tap()
        
        //then verify picker view index and confirmation field
        XCTAssert(app.staticTexts["settings saved"].exists, "problem testing update settings confirmation message")
        XCTAssertEqual(app.pickerWheels.element.value as! String, "none", "problem testing update settings picker view value")
    }
    
    func testUpdatePassword() {
        //log in
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //enter password and update
        let textField = app.textFields["newPassword"]
        textField.typeText("testing")
        let updatePasswordButton = app.buttons["update password"]
        updatePasswordButton.tap()
        
        //check confirmation field
        XCTAssert(app.staticTexts["password updated"].exists, "problem testing update password confirmation message")
        
        //change password back to initial value
        textField.typeText(password)
        updatePasswordButton.tap()
    }
    
    func testInvalidPasswordUpdate() {
        //log in
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //enter password and try to update
        let textField = app.textFields.element(boundBy: 0)
        textField.typeText("hi")
        let updatePasswordButton = app.buttons["update password"]
        updatePasswordButton.tap()
        
        //check confirmation field
        XCTAssert(app.staticTexts["password must be at least 6 characters long"].exists, "problem testing update password invalid message")
    }
    
    func testLogout() {
        //login
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
        
        //navigate to settings view
        app.navigationBars["Budgets"].children(matching: .button).element(boundBy: 0).tap()
        
        //tap logout button
        app.buttons["Logout"].tap()

        //check that we are back at login view
        let window = app.windows.element(boundBy: 0)
        let currentViewElement = app.buttons["On"]
        XCTAssert(window.frame.contains(currentViewElement.frame))
    }
}
