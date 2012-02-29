//
//  Action.h
//  iStroke
//
//  Created by dabao on 12-2-25.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.hh"
#import "Command.hh"

@interface Action : NSObject {
	Gesture *gesture;
    NSImage *image;
	NSString *name;
	Command *cmd;
}

@property(retain) Gesture *gesture;
@property(retain) NSImage *image;
@property(retain) NSString *name;
@property(retain) Command *cmd;

-(id) initWithStroke:(Stroke *)s;

@end
