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
    [[EventListener alloc]
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
        eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, kCGEventMaskForAllEvents, myCGEventCallback, NULL);
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
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
@end
