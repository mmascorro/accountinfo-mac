//
//  AppDelegate.swift
//  AccountInfo
//
//  Created by Miguel Mascorro on 3/5/16.
//  Copyright © 2016 Miguel Mascorro. All rights reserved.
//

import Cocoa

@NSApplicationMain
class MAppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var serialLabel: NSTextField!
    @IBOutlet weak var computerNameLabel: NSTextField!
    @IBOutlet weak var adobeAccountLabel: NSTextField!
    @IBOutlet weak var remoteComputerNameLabel: NSTextField!
    
    var config = [String:String]()
    
    @IBAction func registerBtn(_: AnyObject) {
        print("button tapped!")
    }
    
    func getComputerSerial() -> String {
        
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
        
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey, kCFAllocatorDefault, 0);
        
        IOObjectRelease(platformExpert);
        
        let sn = serialNumberAsCFString.takeUnretainedValue()
        return sn as! String
    }
    
    func getComputerName() -> String {
        return NSHost.currentHost().localizedName!
    }
    
    func registerWithServer(config: Dictionary<String, String>) {
        
    }
    
    func getRemoteinfo(config: Dictionary<String, String>) {
        
    }
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        self.serialLabel.stringValue = self.getComputerSerial()
        self.computerNameLabel.stringValue = self.getComputerName()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}


/*

NSString *configPath = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingString:@"/config.json"];

NSData *ic = [NSData dataWithContentsOfFile:configPath];

self.config = [NSJSONSerialization JSONObjectWithData:ic options:NSJSONReadingMutableContainers error:nil];


[self getRemoteInfo:config];

*/