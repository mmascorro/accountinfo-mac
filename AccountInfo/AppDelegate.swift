//
//  AppDelegate.swift
//  AccountInfo
//
//  Created by Miguel Mascorro on 3/5/16.
//  Copyright © 2016 Miguel Mascorro. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var serialLabel: NSTextField!
    @IBOutlet weak var computerNameLabel: NSTextField!
    @IBOutlet weak var adobeAccountLabel: NSTextField!
    @IBOutlet weak var remoteComputerNameLabel: NSTextField!
    
    var config = [String:String]()
    
    @IBAction func registerBtn(_: AnyObject) {
        self.registerWithServer(self.config)
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
        let url: NSURL = NSURL(string:self.config["url"]!+"/computers/register")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        
        let postString = String(format: "computer[name]=%@&computer[serial]=%@", self.getComputerName(), self.getComputerSerial())
        let postData = postString.dataUsingEncoding(NSUTF8StringEncoding)
  
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPBody = postData
    
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                
                if (responseString == 0) {
                
                } else {
                 
                }
            }
        }
        task.resume()
    }
    
    func getRemoteinfo(config: Dictionary<String, String>) {
        
        let url: NSURL = NSURL(string:self.config["url"]!+"/computers/info/"+self.getComputerSerial())!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!

                if (responseString == 0) {
                    self.remoteComputerNameLabel.stringValue = "NOT REGISTERED"
                    self.adobeAccountLabel.stringValue = ""
                } else {
                    let remoteInfo = responseString.componentsSeparatedByString(",")
                    
                    if (remoteInfo.count == 1) {
                        self.remoteComputerNameLabel.stringValue = remoteInfo[0]
                        self.adobeAccountLabel.stringValue = "No Account"
                    } else {
                        self.remoteComputerNameLabel.stringValue = remoteInfo[0]
                        self.adobeAccountLabel.stringValue = remoteInfo[1]
                    }
                }
            }
        }
        task.resume()
    }
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {

        self.serialLabel.stringValue = self.getComputerSerial()
        self.computerNameLabel.stringValue = self.getComputerName()

        let configPath:String = NSBundle.mainBundle().bundlePath.stringByAppendingString("/../config.json")
        let ic: NSData = NSData.init(contentsOfFile: configPath)!
        do {
            
            try self.config = NSJSONSerialization.JSONObjectWithData(ic, options: NSJSONReadingOptions.MutableContainers ) as! [String : String]
        } catch {
            
        }
        
        self.getRemoteinfo(self.config)
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}