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

@interface iStrokeAppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate> {
@private
	NSWindow *window;

	EventListener *eventListener;
    
    iStroke::Stroke *curStroke, *preStroke;    
    IBOutlet NSWindow *drawStrokeWindow;
    IBOutlet DrawStrokeView *drawStrokeView;
    IBOutlet NSTabView *tableStroke;
    
    NSMutableArray *gestures;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) NSMutableArray *gestures;

- (IBAction)toggleTrack:(NSButton *)sender;
- (IBAction)chooseWindow:(id)sender;
- (void)doneChooseWindow;

- (IBAction)test:(id)sender;

-(void)addPoint:(double)x :(double)y;
-(void)doneStroke;

@end
