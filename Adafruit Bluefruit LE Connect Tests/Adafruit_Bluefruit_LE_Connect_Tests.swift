//
//  Adafruit_Bluefruit_LE_Connect_Tests.swift
//  Adafruit Bluefruit LE Connect Tests
//
//  Created by Helen Diacono on 7/10/2015.
//  Copyright © 2015 Adafruit Industries. All rights reserved.
//

import XCTest

public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG, modified by Phil
    */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFF_FFFF
    }
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By DaRkDOG
    */
    public static func random(min min: Int, max: Int) -> Float {
        return Float.random() * Float((max - min) + min)
    }
}

class Adafruit_Bluefruit_LE_Connect_Tests: XCTestCase {
    var vc:PostureViewController?
    let minSense = -0x4_000  // = -2^14
    let maxSense = 0x4_000  // = +2^14
    var testSensor = SensorData(
        accel: Vector(x: 0.0,y: 0.0,z: 0.0),
        mag: Vector(x: 0.0,y: 0.0,z: 0.0),
        gyro: Vector(x: 0.0,y: 0.0,z: 0.0))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = PostureViewController()
        srandom(UInt32(time(nil)))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func prepSensorData(posture: PostureStatus) {
        testSensor.accel.x = Float.random(min: minSense, max: maxSense)
        testSensor.accel.y = Float.random(min: minSense, max: maxSense)
        testSensor.accel.z = Float.random(min: minSense, max: maxSense)
        testSensor.gyro.y = Float.random(min: minSense, max: maxSense)
        switch posture {
        case PostureStatus.OK:
            testSensor.gyro.x = Float.random(min: -gyroTrigger, max: gyroTrigger)
            testSensor.gyro.z = Float.random(min: -gyroTrigger, max: gyroTrigger)
        case PostureStatus.Back:
            testSensor.gyro.x = Float.random(min: minSense, max: -gyroTrigger-1)
            testSensor.gyro.z = Float.random(min: -gyroTrigger, max: gyroTrigger)
        case PostureStatus.Forward:
            testSensor.gyro.x = Float.random(min: gyroTrigger+1, max: maxSense)
            testSensor.gyro.z = Float.random(min: -gyroTrigger, max: gyroTrigger)
        case PostureStatus.Left:
            testSensor.gyro.x = Float.random(min: -gyroTrigger, max: gyroTrigger)
            testSensor.gyro.z = Float.random(min: gyroTrigger+1, max: maxSense)
        case PostureStatus.Right:
            testSensor.gyro.x = Float.random(min: -gyroTrigger, max: gyroTrigger)
            testSensor.gyro.z = Float.random(min: minSense, max: -gyroTrigger-1)
        default:
            break
        }
        testSensor.mag.x = Float.random(min: minSense, max: maxSense)
        testSensor.mag.y = Float.random(min: minSense, max: maxSense)
        testSensor.mag.z = Float.random(min: minSense, max: maxSense)
    }
    
    func testCalculatePostureStatusGood() {
        for _ in 1...triggerCount+2 {
            prepSensorData(PostureStatus.OK)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.OK, "sent good posture data but did get an OK response")
            }
    }
    
    func testCalculatePostureStatusMixed() {
        // send mix of bad posture data but fewer than triggerCount in a row
        testCalculatePostureStatusGood() // send some good posture data to begin with
        // then send data representing lean forward posture data
        
        for _ in 1..<triggerCount {
            prepSensorData(PostureStatus.Forward)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.OK, "sent too few lean forward posture data but didn't get OK response")
        }
        // then send data representing lean back posture data
        for _ in 1..<triggerCount {
            prepSensorData(PostureStatus.Back)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.OK, "sent too few lean back posture data but didn't get OK response")
        }
        // then send data representing lean left posture data
        for _ in 1..<triggerCount {
            prepSensorData(PostureStatus.Left)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.OK, "sent too few lean left posture data but didn't get OK response")
        }
        // then send data representing lean right posture data
        for _ in 1..<triggerCount {
            prepSensorData(PostureStatus.Right)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.OK, "sent too few lean right posture data but didn't get OK response")
        }
        testCalculatePostureStatusGood() // send some more good posture data
    }
    
    func testCalculatePostureStatusBad() {
        testCalculatePostureStatusGood() // send some good posture data to begin with
        // then send data representing lean forward posture data
        for _ in 1...triggerCount {
            prepSensorData(PostureStatus.Forward)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.Forward, "sent lean forward posture data but didn't get 'forward' response")
        }
        testCalculatePostureStatusGood() // send some more good posture data
        // then send data representing lean back posture data
        for _ in 1...triggerCount {
            prepSensorData(PostureStatus.Back)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.Back, "sent lean back posture data but didn't get 'back' response")
        }
        testCalculatePostureStatusGood() // send some more good posture data
        // then send data representing lean left posture data
        for _ in 1...triggerCount {
            prepSensorData(PostureStatus.Left)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.Left, "sent lean left posture data but didn't get 'left' response")
        }
        testCalculatePostureStatusGood() // send some more good posture data
        // then send data representing lean right posture data
        for _ in 1...triggerCount {
            prepSensorData(PostureStatus.Right)
            XCTAssert(vc!.calculatePostureStatus(testSensor) == PostureStatus.Right, "sent lean right posture data but didn't get 'right' response")
        }
    }
    
    func testParseBadData() {
        let parsed = vc!.parse("!A0123.45@hello there!")
        XCTAssert(parsed == nil, "sent bad data to be parsed but didn't get nil SensorData returned")
    }
    
    func testParseGoodData() {
        var dataGood: Bool = false
        let parsed = vc!.parse("!A0-1037.00@-14939.00@6112.00!G0194.00@-116.00@-266.00!M0870.00@-3623.00@-1348.00")
        XCTAssert(parsed != nil, "parsed returned a nil value to good data")
        dataGood =
            parsed!.accel.x == -1037.00 &&
            parsed!.accel.y == -14939.00 &&
            parsed!.accel.z == 6112.00 &&
            parsed!.gyro.x == 194.00 &&
            parsed!.gyro.y == -116.00 &&
            parsed!.gyro.z == -266.00 &&
            parsed!.mag.x == 870.00 &&
            parsed!.mag.y == -3623.00 &&
            parsed!.mag.z == -1348.00
        XCTAssert(dataGood == true, "parsed returned incorrect SensorData")
    }
    
    func testunParseBadData() {
        let txString = vc!.unParse(9)
        XCTAssert(txString == "", "unParse didn't return an empty string for bad data")
    }

    func testunParseGoodData() {
        let txString = vc!.unParse(1)
        XCTAssert(txString == "!B1@", "Asked unParse for string to turn on vibe motor 1 but didn't get correct txString")
    }
}
