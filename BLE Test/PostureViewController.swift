
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
    var x:Float
    var y:Float
    var z:Float
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
        var sensorData = SensorData()
        
        // TODO fill in sensorData from 'rx'
        
        return nil
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





