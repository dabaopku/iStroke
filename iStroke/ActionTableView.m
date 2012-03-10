//
//  ActionTableView.m
//  iStroke
//
//  Created by dabao on 12-3-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "ActionTableView.h"


@implementation ActionTableView


-(void) keyDown:(NSEvent *)event
{
    BOOL deleteKeyEvent = NO;
    
    if ([event type] == NSKeyDown)
    {
        NSString* pressedChars = [event characters];
        if ([pressedChars length] == 1)
        {
            unichar pressedUnichar =
            [pressedChars characterAtIndex:0];
            
            if ( (pressedUnichar == NSDeleteCharacter) ||
                (pressedUnichar == 0xf728) )
            {
                deleteKeyEvent = YES;
            }
        }
    }
    
    if (deleteKeyEvent)
    {
        NSLog(@"Delete");
    }
    else
    {
        [super keyDown:event];
    }
}


@end
