//
//  DrawStrokeView.h
//  iStroke
//
//  Created by dabao on 12-2-12.
//  Copyright 2012年 PKU. All rights reserved.
//

@interface DrawStrokeView : NSView {
    NSBezierPath *path;
}

-(void) addPoint:(int)x :(int)y;
-(void) clear;

@end
