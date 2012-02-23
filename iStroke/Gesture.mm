//
//  Gesture.m
//  iStroke
//
//  Created by dabao on 12-2-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Gesture.hh"


@implementation Gesture

@synthesize key;
@synthesize stroke;

-(id)initWithStroke:(iStroke::Stroke*)stk
{
    if ((self=[super init])!=nil) {
        stroke=stk->clone();
        key=(long)(100*(double)[[NSDate date] timeIntervalSince1970]);
    }
    return self;
}

-(void) release
{
    delete stroke;
    [super release];
}

-(void)draw:(NSImage*)img
{
    [img setFlipped:YES];
    [img lockFocus];
    [[NSGraphicsContext currentContext]
        setImageInterpolation:NSImageInterpolationHigh];
    
    NSColor *red=[NSColor redColor];
    NSColor *blue=[NSColor blueColor];
    NSBezierPath *path=[NSBezierPath bezierPath];    
    [path setLineWidth:4.0];
    
    for (int i=0,n=stroke->size()-1; i<n; ++i) {
        Stroke::Point p=stroke->point(i),
            np=stroke->point(i+1);
        [[red blendedColorWithFraction:p.t ofColor:blue] set];
        [path moveToPoint:NSMakePoint(p.x*(STROKE_IMAGE_SIZE-4)+2,
                                      p.y*(STROKE_IMAGE_SIZE-4)+2)];
        [path lineToPoint:NSMakePoint(np.x*(STROKE_IMAGE_SIZE-4)+2,
                                      np.y*(STROKE_IMAGE_SIZE-4)+2)];
        [path stroke];
        [path removeAllPoints];
    }    
    [img unlockFocus];
}

-(void)save:(NSImage*)img
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dir=[NSHomeDirectory() stringByAppendingFormat:@"/Library/iStroke/image/"];
    NSString *path=[dir stringByAppendingFormat:@"%ld.jpg",key];
    
    BOOL isDir=YES;
    if (![fm fileExistsAtPath:dir isDirectory:&isDir]) {
        if (![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil]) 
        {
            NSLog(@"Error: Create folder failed %@",dir);
            return;
        }
    }
    
    NSData *imgData=[img TIFFRepresentation];
    NSBitmapImageRep *imgRep=[NSBitmapImageRep imageRepWithData:imgData];
    NSDictionary *imgProps=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    imgData=[imgRep representationUsingType:NSJPEGFileType properties:imgProps];
    [imgData writeToFile:path atomically:NO];
}

-(bool)saveToImage
{
    if(stroke->size()<10)
        return NO;
    
    NSImage *img=[[NSImage alloc] initWithSize:NSMakeSize(STROKE_IMAGE_SIZE, STROKE_IMAGE_SIZE)];
    [self draw:img];
    [self save:img];
    [img release];
    
    return YES;
}

@end