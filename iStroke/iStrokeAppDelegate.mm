//
//  iStrokeAppDelegate.m
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "iStrokeAppDelegate.hh"
#include <iostream>
#include <fstream>
#import "Gesture.hh"

using namespace std;
using namespace iStroke;

@implementation iStrokeAppDelegate

@synthesize window;
@synthesize gestures;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [drawStrokeWindow setLevel:NSFloatingWindowLevel];
    [drawStrokeWindow setOpaque:NO];
    [drawStrokeWindow setBackgroundColor:[NSColor clearColor]];
    [drawStrokeWindow setStyleMask:NSBorderlessWindowMask];
    drawStrokeWindow.isVisible=NO;
    [drawStrokeWindow setFrame:[[NSScreen mainScreen] frame] display:YES];
    
    [window makeKeyAndOrderFront:self];
    
    curStroke=new Stroke();
    preStroke=new Stroke();
    
	eventListener = [[EventListener alloc] init];
	[eventListener start];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[eventListener release];
    
    if (curStroke) {
        delete curStroke;
    }
    if(preStroke){
        delete preStroke;
    }
}

- (IBAction)toggleTrack:(NSButton *)sender {
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

- (IBAction)chooseWindow:(id)sender {
	window.isVisible = NO;
	[[NSApplication sharedApplication] deactivate];
	NSCursor *cursor = [NSCursor crosshairCursor];
	[cursor set];
	[eventListener chooseWindowMode];
}

- (void)doneChooseWindow {
	[[NSApplication sharedApplication] activateIgnoringOtherApps:NO];
	window.isVisible = YES;
	NSCursor *cursor = [NSCursor arrowCursor];
	[cursor set];
    
}

-(IBAction)test:(id)sender
{
    [drawStrokeWindow makeKeyAndOrderFront:self];
}

-(void)addPoint:(double)x :(double)y
{
    curStroke->addPoint(x,y);
    [drawStrokeView addPoint:x :y];
    if (!drawStrokeWindow.isVisible) {
        drawStrokeWindow.isVisible=YES;
    }
    [drawStrokeView setNeedsDisplay:YES];
}
-(void)doneStroke
{
    [drawStrokeView clear];
    drawStrokeWindow.isVisible=NO;
    
    curStroke->finish();
    
    
    // NSLog(@"Comparing two stroke");
    if (preStroke->size()==0) {
        //   NSLog(@"no previou stroke");
    }
    else
    {
      //  double res=curStroke->compare(*preStroke);
      //  NSLog(@"Distance: %f",res);
    }
    delete preStroke;
    preStroke=curStroke;
    curStroke=new Stroke();
    
}

-(NSArray *)gestures
{
    return gestures;
}
-(void)setGestures:(NSMutableArray *)a
{
    gestures=a;
}
-(void)insertObject:(Gesture *)g inGestureAtIndex:(NSUInteger)index
{
    [gestures insertObject:g atIndex:index];
}
-(void)removeObjetFromGestureAtIndex:(NSUInteger)index
{
    [gestures removeObjectAtIndex:index];
}
-(void)awakeFromNib
{
    Gesture *g=[[Gesture alloc] init];
    g.key=1232;
    
    NSMutableArray *a=[NSMutableArray arrayWithObjects:g, nil];
    [self setGestures:a];
}

@end
