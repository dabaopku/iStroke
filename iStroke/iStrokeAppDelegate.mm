//
//  iStrokeAppDelegate.m
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "iStrokeAppDelegate.hh"

using namespace iStroke;

@implementation iStrokeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[window setLevel:NSDockWindowLevel];
    
    curStroke=new Stroke();
    preStroke=new Stroke();
    
	eventListener = [[EventListener alloc] init];
	[eventListener start];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[eventListener release];
    
    delete curStroke;
    delete preStroke;
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
    
}

-(void)addPoint:(double)x :(double)y
{
    curStroke->addPoint(x,y);
}
-(void)doneStroke
{
    NSLog(@"Comparing two stroke");
    if (preStroke->size()==0) {
        NSLog(@"no previou stroke");
    }
    else
    {
        double res=curStroke->compare(*preStroke);
        NSLog(@"Distance: %f",res);
    }
    delete preStroke;
    preStroke=curStroke;
    curStroke=new Stroke();
}
@end
