//
//  EventListener.mm
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "EventListener.h"
#import "ProcessHooker.h"
#import "iStrokeAppDelegate.hh"

@implementation EventListener

static EventListener *sharedObj = nil;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	[sharedObj
			callback:proxy :type :event :refcon];
	return event;
}

- (id)init {
	if (sharedObj) {
		return sharedObj;
	}
	self = [super init];

	eventFilter = CGEventMaskBit(kCGEventLeftMouseDown)
			| CGEventMaskBit(kCGEventLeftMouseDragged) | CGEventMaskBit(kCGEventLeftMouseUp) | CGEventMaskBit(kCGEventMouseMoved) | CGEventMaskBit(kCGEventRightMouseDown) | CGEventMaskBit(kCGEventRightMouseDragged) | CGEventMaskBit(kCGEventRightMouseUp) | CGEventMaskBit(kCGEventOtherMouseDown) | CGEventMaskBit(kCGEventOtherMouseDragged) | CGEventMaskBit(kCGEventOtherMouseUp);

	if (self) {
		eventTap = nil;
		runLoopSource = nil;
		[self setMouseButton:kRightButton];
	}

	sharedObj = self;
	return self;

}

- (void)start {
	state = kListen;
	CGEventTapEnable(eventTap, true);
}

- (void)stop {
	state = kSleep;
	CGEventTapEnable(eventTap, false);
}

- (void)findActiveProcess {
	NSString *process = [ProcessHooker getActiveProcessIdentifier];
    
    [self setMouseButton:kRightButton];
	state = kListen;
	iStrokeAppDelegate *app = [[NSApplication sharedApplication] delegate];
	[app doneChooseWindow:process];
    
}

- (CGEventRef)callback:(CGEventTapProxy)proxy :(CGEventType)type :(CGEventRef)event :(void *)refcon {
	if (state == kFindWindow) {
		if (type == kCGEventLeftMouseUp) {
			[self performSelector:@selector(findActiveProcess) withObject:nil afterDelay:0.2];
		}
		return event;
	}
    if (state==kListen) {
        if (type==maskDown) {
            trackNum=0;
            CGEventSetType(event, kCGEventNull);
        }
        if (type==maskUp) {
            if (trackNum>5) {
                iStrokeAppDelegate *app = [[NSApplication sharedApplication] delegate];
                [app doneStroke];
            }
            trackNum=0;
        }
        if (type==maskDrag) {
            trackNum++;
            iStrokeAppDelegate *app = [[NSApplication sharedApplication] delegate];
            CGPoint pos=CGEventGetLocation(event);
            [app addPoint:pos.x :pos.y];
        }       
    }
	return event;
}

- (void)setMouseButton:(EnumMouseButton)button {
	mouseButton = button;
	maskMove = kCGEventMouseMoved;
	switch (mouseButton) {
		case kLeftButton:
	        maskDown = kCGEventLeftMouseDown;
	        maskDrag = kCGEventLeftMouseDragged;
	        maskUp = kCGEventLeftMouseUp;
	        break;
		case kRightButton:
	        maskDown = kCGEventRightMouseDown;
	        maskDrag = kCGEventRightMouseDragged;
	        maskUp = kCGEventRightMouseUp;
	        break;
		case kMiddleButton:
	        maskDown = kCGEventOtherMouseDown;
	        maskDrag = kCGEventOtherMouseDragged;
	        maskUp = kCGEventOtherMouseUp;
	        break;
		default:
	        maskDown = kCGEventNull;
	        maskDrag = kCGEventNull;
	        maskUp = kCGEventNull;
	        break;
	}

	if (eventTap) {
		[self stop];
	}
	if (runLoopSource) {
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
	}
	eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventFilter, myCGEventCallback, NULL);
	runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
}

- (void)chooseWindowMode {
	[self setMouseButton:kLeftButton];
	state = kFindWindow;
}

@end
