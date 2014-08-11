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
@synthesize adobeAccountLabel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self.serialLabel setStringValue:[self getComputerSerial]];
    [self.computerNameLabel setStringValue:[self getComputerName]];
    
    NSString *configPath = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingString:@"/config.json"];
    
    NSData *ic = [NSData dataWithContentsOfFile:configPath];
    
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:ic options:NSJSONReadingMutableContainers error:nil];
   
    [self registerWithServer:config];
    
}

-(void)registerWithServer:(NSDictionary *)config
{
    
    NSString *post = [NSString stringWithFormat:@"computer[name]=%@&computer[serial]=%@",[self getComputerName], [self getComputerSerial]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:config[@"url"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {

        
            NSString *acct = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self.adobeAccountLabel setStringValue:acct];
        } else {
            [self.adobeAccountLabel setStringValue:@"-"];
        }
    }];

}



-(NSString*)getComputerSerial
{
    NSString *serial = @"";
    
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));

    if (platformExpert) {
        CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
        if (serialNumberAsCFString) {
            serial = CFBridgingRelease(serialNumberAsCFString);
        }
        IOObjectRelease(platformExpert);
    }
    return serial;
}

-(NSString*)getComputerName
{
    NSString *cn = [[NSHost currentHost] localizedName];
    return cn;
}
@end
