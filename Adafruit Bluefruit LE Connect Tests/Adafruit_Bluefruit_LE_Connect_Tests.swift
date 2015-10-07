//
//  Adafruit_Bluefruit_LE_Connect_Tests.swift
//  Adafruit Bluefruit LE Connect Tests
//
//  Created by Helen Diacono on 7/10/2015.
//  Copyright © 2015 Adafruit Industries. All rights reserved.
//

import XCTest

class Adafruit_Bluefruit_LE_Connect_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReturnFive() {
        let vc = PostureViewController();
        XCTAssert(vc.numberFive() == 5);
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.ß
        XCTAssert(1 > 2);
    }
    
}
