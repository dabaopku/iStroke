//
//  DrawStrokeCell.m
//  iStroke
//
//  Created by dabao on 12-2-13.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "DrawStrokeCell.hh"

@implementation DrawStrokeCell

- (id)initWithGesture:(Gesture *)g
{
    self = [super init];
    if (self) {
        [g saveToImage];
        NSString * file=@"../../iStroke/a.png";
        NSImage *img=[[[NSImage alloc] initWithContentsOfFile:file] autorelease];
        [self setImage:img];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
