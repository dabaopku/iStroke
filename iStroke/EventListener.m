//
//  EventListener.m
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "EventListener.h"


@implementation EventListener

static EventListener *sharedObj = nil;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,  CGEventRef event, void *refcon) {
    [sharedObj
        callback:proxy :type :event :refcon];
    return event;
}

-(id) init
{
    if (sharedObj) {
        return sharedObj;
    }
    self = [super init];
    
    if(self){
        eventTap=nil;
        runLoopSource=nil;
        [self setMouseButton:RightButton];
    }
    
    sharedObj=self;
    return self;
    
}

-(void) start
{
    CGEventTapEnable(eventTap, true);
}

-(void) stop
{
    CGEventTapEnable(eventTap, false);
}

-(CGEventRef) callback:(CGEventTapProxy)proxy :(CGEventType)type :(CGEventRef)event :(void *)refcon
{
    printf("%u\n", (uint32_t)type);
    return event; 
}

-(void) setMouseButton:(MouseButton)button
{
    mouseButton=button;
    switch (mouseButton) {
        case LeftButton:
            eventFilter=CGEventMaskBit(kCGEventLeftMouseDown)
                | CGEventMaskBit(kCGEventLeftMouseDragged)
                | CGEventMaskBit(kCGEventLeftMouseUp)
                | CGEventMaskBit(kCGEventMouseMoved);
            break;
        case RightButton:
            eventFilter=CGEventMaskBit(kCGEventRightMouseDown)
            | CGEventMaskBit(kCGEventRightMouseDragged)
            | CGEventMaskBit(kCGEventRightMouseUp)
            | CGEventMaskBit(kCGEventMouseMoved);
            break;
        case MiddleButton:
            eventFilter=CGEventMaskBit(kCGEventOtherMouseDown)
            | CGEventMaskBit(kCGEventOtherMouseDragged)
            | CGEventMaskBit(kCGEventOtherMouseUp)
            | CGEventMaskBit(kCGEventMouseMoved);
            break;
        default:
            eventFilter=kCGEventNull;
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
@end
