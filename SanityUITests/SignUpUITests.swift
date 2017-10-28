//
//  SignUpUITests.swift
//  SanityUITests
//
//  Created by Nicholas Kaimakis on 10/28/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
import Firebase
@testable import Sanity

class SignUpUITests: XCTestCase {
    var app: XCUIApplication!
    let userEmail: String = "newUser@example.com"

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

    func testSignup() {
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText(userEmail)
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Submit"].tap()
        
//        //delete user from database
//        Firestore.firestore().document("Users/\(userEmail)").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
        
    }
    
    func testBlankEmailSignup() {
        
    }
    
    func testBlankPasswordSignup() {
        
    }
    
    func testTakenEmailSignup() {
        
    }
}
