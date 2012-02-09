//
//  EventListener.h
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

typedef enum
{
    kLeftButton =0,
	kRightButton,
	kMiddleButton,
} EnumMouseButton;

typedef enum
{
    kSleep =0,
	kListen,
	kFindWindow,
} EnumWorkState;

@interface EventListener : NSObject {
    CFMachPortRef eventTap;  
    CFRunLoopSourceRef runLoopSource;
    CGEventMask eventFilter;
    
    CGEventMask maskDown,maskUp,maskDrag,maskMove;

    EnumMouseButton mouseButton;

    EnumWorkState state;
}

-(void) start;
-(void) stop;

-(CGEventRef) callback:(CGEventTapProxy) proxy
                      :(CGEventType) type
                      :(CGEventRef) event
                      :(void *) refcon;

-(void) setMouseButton:(EnumMouseButton) button;

-(void) chooseWindowMode;

@end
