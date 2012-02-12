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

- (void)dealloc
{
    [super dealloc];
}

-(BOOL) isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(strokePoint.size()<8)
        return;
    
    std::list<int>::iterator it=strokePoint.begin();
    int x,y;
    
    NSGraphicsContext *context=[NSGraphicsContext currentContext];
	CGContextRef contextRef		= (CGContextRef) [context graphicsPort];
    
    CGContextSetRGBStrokeColor(contextRef, 1, 0, 0, 1);
    
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef,x=*it++,y=*it++);
    CGContextSetLineWidth(contextRef, 4);
    
    while (it!=strokePoint.end()) {
        CGContextAddLineToPoint(contextRef,x=*it++,y=*it++);
    }
    CGContextDrawPath(contextRef,kCGPathStroke);
}

-(void) addPoint:(int)x :(int)y
{
    strokePoint.push_back(x);
    strokePoint.push_back(y);
}
-(void)clear
{
    strokePoint.clear();
}
@end
