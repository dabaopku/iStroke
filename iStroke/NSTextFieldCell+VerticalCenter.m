//
//  NSTextFieldCell+VerticalCenter.m
//  iStroke
//
//  Created by dabao on 12-3-1.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "NSTextFieldCell+VerticalCenter.h"


@implementation NSTextFieldCell (NSTextFieldCell_VerticalCenter)

- (void)setVerticalCentering:(BOOL)centerVertical
{
    _cFlags.vCentered = (int)centerVertical;
    
}

@end
