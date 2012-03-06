//
//  iStrokeAppDelegate.h
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EventListener.h"
#import "Stroke.hh"
#import "DrawStrokeView.hh"
#import "Application.hh"
#import "Command.hh"
#import "ApplicationOutlineView.hh"

@interface iStrokeAppDelegate : NSObject <NSApplicationDelegate> {

	NSWindow *window;

	EventListener *eventListener;
    
    iStroke::Stroke *curStroke, *preStroke;    
    IBOutlet NSWindow *drawStrokeWindow;
    IBOutlet DrawStrokeView *drawStrokeView;
    IBOutlet NSTableView *tableStroke;
    IBOutlet ApplicationOutlineView *applicationOutlineView;
    
}

@property(assign) IBOutlet NSWindow *window;


- (IBAction)toggleTrack:(NSButton *)sender;
- (IBAction)chooseWindow:(id)sender;
- (void)doneChooseWindow:(NSString *)process;

- (IBAction)test:(id)sender;
-(IBAction) addGroup:(id)sender;
-(IBAction) save:(id)sender;

-(void)addPoint:(double)x :(double)y;
-(void)doneStroke;

@end
