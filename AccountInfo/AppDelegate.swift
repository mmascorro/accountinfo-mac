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
        
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString!, kCFAllocatorDefault, 0);
        
        IOObjectRelease(platformExpert);
        
        let sn = serialNumberAsCFString?.takeUnretainedValue()
        return sn as! String
    }
    
    func getComputerName() -> String {
        return Host.current().localizedName!
    }
    
    func registerWithServer(_ config: Dictionary<String, String>) {
        let url: URL = URL(string:self.config["url"]!+"/computers/register")!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let postString = String(format: "computer[name]=%@&computer[serial]=%@", self.getComputerName(), self.getComputerSerial())
        let postData = postString.data(using: String.Encoding.utf8)
  
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        task.resume()
    }
    
    func getRemoteinfo(_ config: Dictionary<String, String>) {
        
        let url: URL = URL(string:self.config["url"]!+"/computers/info/"+self.getComputerSerial())!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                let response = String(data: data!, encoding: String.Encoding.utf8)
                if (Int(response!) == 0) {
                    self.remoteComputerNameLabel.stringValue = "NOT REGISTERED"
                    self.adobeAccountLabel.stringValue = ""
                } else {
                    let remoteInfo = response!.components(separatedBy: ",")

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
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        self.serialLabel.stringValue = self.getComputerSerial()
        self.computerNameLabel.stringValue = self.getComputerName()

        let configPath:String = Bundle.main.bundlePath + "/../config.json"
        let ic: Data = try! Data.init(contentsOf: URL(fileURLWithPath: configPath))
        do {
            
            try self.config = JSONSerialization.jsonObject(with: ic, options: JSONSerialization.ReadingOptions.mutableContainers ) as! [String : String]
        } catch {
            
        }
        
        self.getRemoteinfo(self.config)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
