//
//  Application.m
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Application.hh"
#import "Action.hh"

@implementation Application

-(void) addObject:(id)anObject
{
    assert([anObject isKindOfClass:[Action class]]);
    [super addObject:anObject];
}

@end
