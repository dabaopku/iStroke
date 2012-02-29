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
#import "Action.hh"
#import "Command.hh"

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
    
    Action *act=[[Action alloc] initWithStroke:preStroke];
    [gestures addObject:act];
    [tableStroke reloadData];
    
}

-(void)awakeFromNib
{    
    gestures=[[NSMutableArray alloc] initWithObjects:nil];
    
    commandTypeDelegate=[[CommandTypeDelegate alloc] init];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [gestures count];
}
-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 64;
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[gestures objectAtIndex:row];
    
    if ([col isEqualToString:@"gesture"]) {
        return [act image];
    }
    if ([col isEqualToString:@"name"]) {
        return [act name];
    }
    if ([col isEqualToString:@"type"]) {
        return CommandType::ToString(act.cmd.type);
    }
    if ([col isEqualToString:@"cmd"]) {
        return [act name];
    }
    return nil;
}

-(void) tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[gestures objectAtIndex:row];
    
    if([col isEqualToString:@"type"])
    {
        act.cmd.type=[commandTypeDelegate index:object];
    }
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if([[tableColumn identifier] isEqual:@"type"] && [cell isKindOfClass:[NSComboBoxCell class]])
    {
        [cell setRepresentedObject:[commandTypeDelegate typeList]];
        [cell reloadData];
    }
}
@end
