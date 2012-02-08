//
//  iStrokeAppDelegate.h
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EventListener.h"

@interface iStrokeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    
    EventListener * listener;
}

@property (assign) IBOutlet NSWindow *window;

@end
