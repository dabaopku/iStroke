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
    LeftButton=0,
    RightButton,
    MiddleButton,
}  MouseButton;

@interface EventListener : NSObject {
    CFMachPortRef eventTap;  
    CFRunLoopSourceRef runLoopSource;
    CGEventMask eventFilter;
    

    MouseButton mouseButton;
}

-(id) init;
-(void) start;
-(void) stop;

-(CGEventRef) callback:(CGEventTapProxy) proxy
                      :(CGEventType) type
                      :(CGEventRef) event
                      :(void *) refcon;

-(void) setMouseButton:(MouseButton) button;

@end
