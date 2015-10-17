
//  PostureViewController.swift
//  Adafruit Bluefruit LE Connect
//
//  Created by Collin Cunningham on 9/30/14.
//  Copyright (c) 2014 Adafruit Industries. All rights reserved.
//

import Foundation
import UIKit
import Dispatch


protocol PostureViewControllerDelegate: HelpViewControllerDelegate {
    func sendData(newData:NSData)
}

// Data Type Definitions
enum PostureStatus:Int {
    case OK
    case Left
    case Right
    case Forward
    case Back
}

public struct Vector {
    var x:Int
    var y:Int
    var z:Int
}

public struct SensorData {
    var accel:Vector
    var mag:Vector
    var gyro:Vector
}

enum ActuatorType {
    case Buzzer
}

public let gyroTrigger = 400 // sense data beyond which we sense a lean
public let triggerCount = 3 // number of times in a row that a trigger has to occur to sound an alarm

public struct ActuatorCommand {
    var type:ActuatorType?
    var id:Int? // 0, 1, 2, 3, etc
}

class PostureViewController: UIViewController {
    
    var delegate:PostureViewControllerDelegate?
    @IBOutlet var helpViewController:HelpViewController!
    
    convenience init(aDelegate:PostureViewControllerDelegate?){
        self.init(nibName: "PostureViewController" as String, bundle: NSBundle.mainBundle())
        
        self.delegate = aDelegate
        self.title = "Posture"
    }
    
    
    override func viewDidLoad(){
        
        //setup help view
        self.helpViewController.title = "Help"
        self.helpViewController.delegate = delegate
        
    }
    
    func transmitTX(tx:NSString){
        // 'tx' is the bluetooth command transmission as a string
        
        let data = NSData(bytes: tx.UTF8String, length: tx.length)
        delegate?.sendData(data)
        
    }
    
    func receiveRX(rx:NSString) {
        // 'rx' is the bluetooth data transmission as a string
        NSLog("Transmission: %@", rx);
    }
    
    func parse(rx:NSString)->SensorData? {
        // typical input string: !A0-1037.00@-14939.00@6112.00!G0194.00@-116.00@-266.00!M0870.00@-3623.00@-1348.00
        // use it to fill a sensorData structure
        // if an error, return nil structure
        var xyz: [String]
        var sensorData = SensorData(
            accel: Vector(x: 0,y: 0,z: 0),
            mag: Vector(x: 0,y: 0,z: 0),
            gyro: Vector(x: 0,y: 0,z: 0))
        var vector = rx.componentsSeparatedByString("!") // split into vectors
        if vector[0] != "" { return nil } // first character is supposed to be "!" so first split should be empty string
        for i in 1...3 {
            var prefix: String
            switch i {
            case 1:
                prefix="A0"
            case 2:
                prefix="G0"
            case 3:
                prefix="M0"
            }
            if !vector[i].hasPrefix(prefix) {return nil}  // next two chars are supposed to be prefix
            vector[i].removeAtIndex(vector[i].startIndex) // remove prefix i.e. first two characters
            vector[i].removeAtIndex(vector[i].startIndex)
            xyz = vector[i].componentsSeparatedByString("@") // split into x, y and z values
            switch i {
            case 1:
                if let j = Int(xyz[0]) { sensorData.accel.x = j } else { return nil }
                if let j = Int(xyz[1]) { sensorData.accel.y = j } else { return nil }
                if let j = Int(xyz[2]) { sensorData.accel.z = j } else { return nil }
            case 2:
                if let j = Int(xyz[0]) { sensorData.gyro.x = j } else { return nil }
                if let j = Int(xyz[1]) { sensorData.gyro.y = j } else { return nil }
                if let j = Int(xyz[2]) { sensorData.gyro.z = j } else { return nil }
            case 3:
                if let j = Int(xyz[0]) { sensorData.mag.x = j } else { return nil }
                if let j = Int(xyz[1]) { sensorData.mag.y = j } else { return nil }
                if let j = Int(xyz[2]) { sensorData.mag.z = j } else { return nil }
            }
        }
        return sensorData
    }
    
    func unParse(tx:Int)->NSString {
        // TODO build a string from 'tx'
        
        return ""
    }
    
    func calculatePostureStatus(data:SensorData)->PostureStatus {
        // TODO analyse sensor datas and return posture status
        
        return PostureStatus.OK
    }
    
    func didConnect() {
        // bluetooth connection is now established
    }
    
    func receiveData(rxData : NSData){
        
        if (isViewLoaded() && view.window != nil) {
            let rx = NSString(bytes: rxData.bytes, length: rxData.length, encoding: NSUTF8StringEncoding)
            receiveRX(rx!);
        }
        
    }
}





