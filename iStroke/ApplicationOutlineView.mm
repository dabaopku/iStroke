//
//  ApplicationOutlineView.mm
//  iStroke
//
//  Created by dabao on 12-3-6.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "ApplicationOutlineView.hh"


@implementation ApplicationOutlineView

@synthesize appManager;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) addApplication:(NSString *)identifier {
	BOOL res=[appManager addApplication:identifier :identifier];
	if (res) {
        [self reloadData];
    }
}

-(void) addGroup
{
    NSString *name=@"New Group";
    NSString *identifier=[NSString stringWithFormat:@"%ld",(long)(100*(double)[[NSDate date] timeIntervalSince1970])];
    
    BOOL res=[appManager addApplication:identifier :name];
	if (res) {
        [self reloadData];
    }
}

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
        [appManager deleteApplication];
        [self reloadData];
    }
    else
    {
        [super keyDown:event];
    }
}

-(void) reloadData
{
    [super reloadData];
    [appManager save];
    [self expandItem:nil expandChildren:YES];
}

-(void) awakeFromNib
{
    [appManager load];
    [self expandItem:nil expandChildren:YES];
}
@end
