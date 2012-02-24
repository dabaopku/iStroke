//
//  Gesture.h
//  iStroke
//
//  Created by dabao on 12-2-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#include <vector>
#include <string>
#import "Stroke.hh"
using namespace iStroke;

#define STROKE_IMAGE_SIZE 256
#define STROKE_IMAGE_MARGIN 16

@interface Gesture : NSObject {

@private
    Stroke * stroke;
    std::string name;
    long key;
}
@property(assign) long key;
@property(assign) Stroke * stroke;

-(id) initWithStroke:(Stroke*)stk;

-(bool) saveImage;
-(NSImage *) loadImage;

@end
