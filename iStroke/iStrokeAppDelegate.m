//
//  iStrokeAppDelegate.m
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "iStrokeAppDelegate.h"

@implementation iStrokeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    eventListener=[[EventListener alloc] init];
    [eventListener start];
}

-(IBAction) toggleTrack:(NSButton *)sender
{
    switch ([sender state]) {
        case NSOnState:
            [eventListener start];
            break;
        case NSOffState:
            [eventListener stop];
            break;
        default:
            break;
    }
}
@end
