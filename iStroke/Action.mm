//
//  Action.mm
//  iStroke
//
//  Created by dabao on 12-2-25.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Action.hh"

@implementation Action

@synthesize gesture;
@synthesize image;
@synthesize name;
@synthesize cmd;

- (id)initWithStroke:(iStroke::Stroke *)s
{
    self = [super init];
    if (self) {
        Gesture *g=[[Gesture alloc] initWithStroke:s];
        self.gesture=g;
        [g saveImage];
        self.image=[g loadImage];
        self.name=@"gesture";
        self.cmd=[[Command alloc] init];
        [g release];
    }
    
    return self;
}

- (void)dealloc
{
	[gesture release];
    [image release];
    [name release];
    [cmd release];
    [super dealloc];
}

@end
