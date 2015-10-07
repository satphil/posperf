//
//  Adafruit_Bluefruit_LE_Connect_Tests.swift
//  Adafruit Bluefruit LE Connect Tests
//
//  Created by Helen Diacono on 7/10/2015.
//  Copyright © 2015 Adafruit Industries. All rights reserved.
//

import XCTest

class Adafruit_Bluefruit_LE_Connect_Tests: XCTestCase {
    var vc:PostureViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = PostureViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculatePostureStatusEmpty() {
        // no data points means OK posture, right?
        XCTAssert(vc!.calculatePostureStatus([]) == PostureStatus.OK);
    }
    
    func testParseBadData() {
        let parsed = vc!.parse("!A0123.45@hello there!")
        XCTAssert(parsed == nil) // ensure no SensorData was returned
    }
}
