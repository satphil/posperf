
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
    
    convenience init(aDelegate:PostureViewControllerDelegate){
        self.init(nibName: "PostureViewController" as String, bundle: NSBundle.mainBundle())
        
        self.delegate = aDelegate
        self.title = "Posture"
    }
    
    
    override func viewDidLoad(){
        
        //setup help view
        self.helpViewController.title = "Help"
        self.helpViewController.delegate = delegate
        
    }
    
    func sendCommand(tx:NSString){
        // 'tx' is the bluetooth command transmission as a string
        
        let data = NSData(bytes: tx.UTF8String, length: tx.length)
        delegate?.sendData(data)
        
    }
    
    func receiveData(rxData : NSData){
        
        if (isViewLoaded() && view.window != nil) {
            let rx = NSString(bytes: rxData.bytes, length: rxData.length, encoding: NSUTF8StringEncoding)
            
            // 'rx' is the bluetooth data transmission as a string
            NSLog("Transmission: %@", rx!);
        }
        
    }
    
    func didConnect() {
        // bluetooth connection is now established
    }
}





