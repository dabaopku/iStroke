//
//  DrawStrokeView.h
//  iStroke
//
//  Created by dabao on 12-2-12.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DrawStrokeView : NSView {
@private
    NSMutableArray	*strokePoint;
}

-(void) addPoint:(int)x :(int)y;
-(void) clear;

@end
