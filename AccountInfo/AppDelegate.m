//
//  AppDelegate.m
//  AccountInfo
//
//  Created by Miguel Mascorro on 6/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"


#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>


@implementation AppDelegate

@synthesize serialLabel;
@synthesize computerNameLabel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self.serialLabel setStringValue:@"hit erh"];
    [self.computerNameLabel setStringValue:@"compu name"];
    
    [self getComputerSerial];
    [self getComputerName];
}


-(void)getComputerSerial
{
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));

    if (platformExpert) {
        CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
        if (serialNumberAsCFString) {
            [self.serialLabel setStringValue:CFBridgingRelease(serialNumberAsCFString)];
        }
        IOObjectRelease(platformExpert);
    }
}

-(void)getComputerName
{
    NSString *cn = [[NSHost currentHost] localizedName];
    [self.computerNameLabel setStringValue:cn];
}
@end
