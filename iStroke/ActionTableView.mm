//
//  ActionTableView.m
//  iStroke
//
//  Created by dabao on 12-3-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "ActionTableView.hh"
#import "Application.hh"

@implementation ActionTableView

@synthesize app;

-(void) keyDown:(NSEvent *)event
{
    BOOL deleteKeyEvent = NO;
    BOOL dealt=NO;
    
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
        if([[self selectedRowIndexes] count]>0)
        {
            [app.actions removeObjectsAtIndexes:[self selectedRowIndexes]];             
            [self reloadData];
            dealt=YES;
        }
    }
    
    if(!dealt)
    {
        [super keyDown:event];
    }
}


@end
