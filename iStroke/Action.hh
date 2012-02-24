//
//  Action.h
//  iStroke
//
//  Created by dabao on 12-2-25.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.hh"

@interface Action : NSObject {
	Gesture *gesture;
    NSImage *image;
	NSString *name;
	NSObject *cmd;
}

@property(retain) Gesture *gesture;
@property(retain) NSImage *image;
@property(retain) NSString *name;
@property(retain) NSObject *cmd;

-(id) initWithStroke:(Stroke *)s;

@end
