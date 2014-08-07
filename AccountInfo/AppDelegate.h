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

- (void)getComputerSerial;
- (void)getComputerName;

@end
