//
//  EventListener.m
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "EventListener.h"
#import "ProcessHooker.h"

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

    eventFilter=CGEventMaskBit(kCGEventLeftMouseDown)
        | CGEventMaskBit(kCGEventLeftMouseDragged)
        | CGEventMaskBit(kCGEventLeftMouseUp)
        | CGEventMaskBit(kCGEventMouseMoved)
        | CGEventMaskBit(kCGEventRightMouseDown)
        | CGEventMaskBit(kCGEventRightMouseDragged)
        | CGEventMaskBit(kCGEventRightMouseUp)
        | CGEventMaskBit(kCGEventOtherMouseDown)
        | CGEventMaskBit(kCGEventOtherMouseDragged)
        | CGEventMaskBit(kCGEventOtherMouseUp);
    
    if(self){
        eventTap=nil;
        runLoopSource=nil;
        [self setMouseButton:eRightButton];
    }
    
    sharedObj=self;
    return self;
    
}

-(void) start
{
    state= eListen;
    CGEventTapEnable(eventTap, true);
}

-(void) stop
{
    state= eSleep;
    CGEventTapEnable(eventTap, false);
}

-(CGEventRef) callback:(CGEventTapProxy)proxy :(CGEventType)type :(CGEventRef)event :(void *)refcon
{
    if (state==eFindWindow)
    {
        if(type==kCGEventLeftMouseUp)
        {
            NSString *process=[ProcessHooker getActiveProcessIdentifier];
            NSLog(@"%@",process);
            state= eListen;
        }
        else if (type==kCGEventLeftMouseDown)
        {
        }
        return event;
    }
    return event; 
}

-(void) setMouseButton:(EnumMouseButton)button
{
    mouseButton=button;
    maskMove=kCGEventMouseMoved;
    switch (mouseButton) {
        case eLeftButton:
            maskDown=kCGEventLeftMouseDown;
            maskDrag=kCGEventLeftMouseDragged;
            maskUp=kCGEventLeftMouseUp;
            break;
        case eRightButton:
            maskDown=kCGEventRightMouseDown;
            maskDrag=kCGEventRightMouseDragged;
            maskUp=kCGEventRightMouseUp;
            break;
        case eMiddleButton:
            maskDown=kCGEventOtherMouseDown;
            maskDrag=kCGEventOtherMouseDragged;
            maskUp=kCGEventOtherMouseUp;
            break;
        default:
            maskDown=kCGEventNull;
            maskDrag=kCGEventNull;
            maskUp=kCGEventNull;
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
    state=eFindWindow;
}

@end
