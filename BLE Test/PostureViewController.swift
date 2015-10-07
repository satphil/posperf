
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
    
    // Example test method, see Adafruit_Bluefruit_LE_Connect_Tests.swift
    func numberFive()->Int {
        return 5
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





