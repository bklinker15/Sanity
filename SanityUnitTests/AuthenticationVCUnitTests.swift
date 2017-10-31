//
//  AuthenticationVCUnitTests.swift
//  SanityUnitTests
//
//  Created by Jordan Coppert on 10/30/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import XCTest
@testable import Sanity
class AuthenticationVCUnitTests: XCTestCase {
    var controllerToTest: AuthViewController!
    override func setUp() {
        super.setUp()
        controllerToTest = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthenticationVC") as? AuthViewController
    }
    
    override func tearDown() {
        controllerToTest = nil
        super.tearDown()
    }
    
    func testIsComplexPasswordGoodInput(){
        let testPassword = "tester"
        XCTAssert(controllerToTest.isComplexPassword(password:testPassword))
    }
    
    func testIsComplexPasswordBadInput(){
        let testPassword = "test"
        XCTAssertFalse(controllerToTest.isComplexPassword(password:testPassword))
    }
    
    func testIsValidEmailGoodInput(){
        let testEmail = "coppert@usc.edu"
        XCTAssert(controllerToTest.isValidEmail(email: testEmail))
    }
    
    func testIsValidEmailBadInput(){
        let testEmail = "coppertusc.edu"
        XCTAssertFalse(controllerToTest.isValidEmail(email: testEmail))
    }
}
