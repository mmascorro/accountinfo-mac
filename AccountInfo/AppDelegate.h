//
//  AppDelegate.h
//  AccountInfo
//
//  Created by Miguel Mascorro on 6/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *serialLabel;
@property (weak) IBOutlet NSTextField *computerNameLabel;
@property (weak) IBOutlet NSTextField *adobeAccountLabel;
@property (weak) IBOutlet NSTextField *remoteComputerNameLabel;

@property NSDictionary *config;

- (IBAction)registerBtn:(id)sender;

- (NSString*)getComputerSerial;
- (NSString*)getComputerName;

- (void)registerWithServer:(NSDictionary *)config;
- (void)getRemoteInfo:(NSDictionary *)config;

@end
