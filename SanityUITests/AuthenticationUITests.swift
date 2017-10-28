//
//  AuthenticationUITests.swift
//  SanityUITests
//
//  Created by Brooks Klinker on 10/23/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity

class AuthenticationUITests: XCTestCase {
    var app: XCUIApplication!
    let username:String = "coppert@usc.edu"
    let password:String = "tester"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCorrectLogin(){
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Submit"].tap()
    }
    
    func testInvalidEmail() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText("wrong")
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Invalid email"].exists, "problem testing incorrect email error message")
    }
    
    func testShortPassword() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("hi")
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Password must be at least 6 characters long"].exists, "problem testing short password error message")
    }
    
    func testIncorrectPassword() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("wrong_password")
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Invalid login"].exists, "problem testing incorrect password error message")
    }
    
    func testIncorrectEmail() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText("username@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Invalid login"].exists, "problem testing incorrect email error message")
    }
    
    func testBlankEmail() {
        let app = XCUIApplication()
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Fields cannot be empty"].exists, "problem testing blank email error message")
    }
    
    func testBlankPassword() {
        let app = XCUIApplication()
        
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(username)
        app.buttons["Submit"].tap()
        XCTAssert(app.staticTexts["Fields cannot be empty"].exists, "problem testing blank password error message")
    }
}
