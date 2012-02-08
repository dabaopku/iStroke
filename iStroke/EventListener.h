//
//  EventListener.h
//  iStroke
//
//  Created by dabao on 12-2-9.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@interface EventListener : NSObject {
    CFMachPortRef eventTap;  
    CFRunLoopSourceRef runLoopSource;
}

-(id) init;
-(void) start;
-(void) stop;

-(CGEventRef) callback:(CGEventTapProxy) proxy
                      :(CGEventType) type
                      :(CGEventRef) event
                      :(void *) refcon;

@end
