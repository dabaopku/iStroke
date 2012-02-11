//
//  DrawStrokeView.m
//  iStroke
//
//  Created by dabao on 12-2-12.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "DrawStrokeView.h"

@implementation DrawStrokeView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    
    return self;
}

-(void)awakeFromNib
{
    strokePoint=[[NSMutableArray alloc]init];
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
    if([strokePoint count]<8)
        return;
    
    NSGraphicsContext *context=[NSGraphicsContext currentContext];
	CGContextRef contextRef		= (CGContextRef) [context graphicsPort];
    
    CGContextSetRGBStrokeColor(contextRef, 1, 0, 0, 1);
    
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef,[[strokePoint objectAtIndex:0] intValue],[[strokePoint objectAtIndex:1] intValue]);
    CGContextSetLineWidth(contextRef, 4);
    
    for (NSUInteger i=1,n=[strokePoint count]/2; i<n; ++i) {
        CGContextAddLineToPoint(contextRef,[[strokePoint objectAtIndex:2*i] intValue],[[strokePoint objectAtIndex:2*i+1] intValue]);	
    }
    CGContextDrawPath(contextRef,kCGPathStroke);
}

-(void) addPoint:(int)x :(int)y
{
    [strokePoint addObject:[[NSNumber alloc] initWithInt:x]];
    [strokePoint addObject:[[NSNumber alloc] initWithInt:y]];
}
-(void)clear
{
    [strokePoint removeAllObjects];
}
@end
