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

	EventListener *eventListener;
}

@property(assign) IBOutlet NSWindow *window;

- (IBAction)toggleTrack:(NSButton *)sender;

- (IBAction)chooseWindow:(id)sender;

- (void)doneChooseWindow;

@end
