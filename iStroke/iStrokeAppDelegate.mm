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
#import "DrawStrokeCell.hh"

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
    preStroke=0;
    
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
    if (!preStroke) {
        //   NSLog(@"no previou stroke");
    }
    else
    {
      //  double res=curStroke->compare(*preStroke);
      //  NSLog(@"Distance: %f",res);
        delete preStroke;
    }
    preStroke=curStroke;
    curStroke=new Stroke();
    
    DrawStrokeCell *cell=[[DrawStrokeCell alloc] initWithGesture:[[Gesture alloc] initWithStroke:preStroke]];
    [gestures addObject:cell];
}

-(void)awakeFromNib
{
    Gesture *g=[[Gesture alloc] init];
    g.key=1232;
    //DrawStrokeCell *cell=[[DrawStrokeCell alloc] initWithGesture:g];
    
    gestures=[[NSMutableArray alloc] initWithObjects:nil];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [gestures count];
}
-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 80;
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    DrawStrokeCell *cell=[gestures objectAtIndex:row];
    return [cell image];
    NSImage *img=[[NSImage alloc] init];
    // NSImage *img2=[[NSImage alloc] init];
    [img setSize:NSMakeSize(50, 50)];
    //[img2 setBackgroundColor:[NSColor redColor]];
     // [img drawAtPoint:NSMakePoint(0.5, 0.3) fromRect:NSMakeRect(0,0,0.3,0.2)
     //       operation:NSCompositeSourceIn fraction:0.7];
    return img;
    return [gestures objectAtIndex:row];
}
@end
