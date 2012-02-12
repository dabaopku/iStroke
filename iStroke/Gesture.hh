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

@interface Gesture : NSObject {

@private
    Stroke stroke;
    std::string name;
    int key;
}
@property(assign) int key;
@property(assign) Stroke stroke;

@end
