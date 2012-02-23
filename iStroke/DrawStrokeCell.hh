//
//  DrawStrokeCell.h
//  iStroke
//
//  Created by dabao on 12-2-13.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.hh"

@interface DrawStrokeCell : NSImageCell {
}

-(id) initWithGesture:(Gesture *)g;

@end
