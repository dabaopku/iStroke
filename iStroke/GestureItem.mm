//
//  GestureItem.m
//  iStroke
//
//  Created by dabao on 12-2-13.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "GestureItem.hh"


@implementation GestureItem

@synthesize key;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
