//
//  DrawStrokeView.m
//  iStroke
//
//  Created by dabao on 12-2-12.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "DrawStrokeView.hh"

@implementation DrawStrokeView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

-(void)awakeFromNib
{
    path=[[NSBezierPath bezierPath] retain];
    [path setLineWidth:5.0];
}

- (void)dealloc
{
    [path release];
    [super dealloc];
}

-(BOOL) isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    if ([path isEmpty]) {
        return;
    }
    
    [[NSColor redColor] set];
    [path stroke];
}

-(void) addPoint:(int)x :(int)y
{
    if ([path isEmpty]) {
        [path moveToPoint:NSMakePoint(x, y)];
    }
    else
    {
        [path lineToPoint:NSMakePoint(x, y)];
    }
}
-(void)clear
{
    [path removeAllPoints];
    return;
}

@end
