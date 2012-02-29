//
//  Command.m
//  iStroke
//
//  Created by dabao on 12-2-28.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Command.hh"

#define kKeyboard   @"Keyboard"
#define kMouse      @"Mouse"
#define kMenu       @"Menu"
#define kOther      @"Other"
#define kNone       @"NoneCMD"

namespace iStroke {
    NSString* CommandType::ToString(Type t)
    {
        switch (t) {
            case Keyboard:
                return NSLocalizedString(kKeyboard,@"");
            case Mouse:
                return NSLocalizedString(kMouse,@"");
            case Menu:
                return NSLocalizedString(kMenu,@"");
            case Other:
                return NSLocalizedString(kOther, @"");
            default:
                return NSLocalizedString(kNone,@"");
        }
    }
}

@implementation Command

@synthesize type;
@synthesize value;

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

@end


@implementation CommandTypeDelegate

@synthesize typeList;

-(id)init
{
    self=[super init];
    if(self)
    {
        typeList=[[NSArray alloc] initWithObjects:
                  NSLocalizedString(kKeyboard, @""),
                  NSLocalizedString(kMouse, @""),
                  NSLocalizedString(kMenu, @""),
                  NSLocalizedString(kOther, @""),
                  NSLocalizedString(kNone, @""),
                  nil];
    }
    return self;
}


-(id) comboBoxCell:(NSComboBoxCell *)cell objectValueForItemAtIndex:(NSInteger)index
{
    NSArray *value=[cell representedObject];
    if(value==nil)
        return @"";
    else
        return [value objectAtIndex:index];
}

-(int)numberOfItemsInComboBoxCell:(NSComboBoxCell*)cell
{
    return (int)[typeList count];
}

-(int)comboBoxCell:(NSComboBoxCell*)cell indexOfItemWithStringValue:(NSString*)st
{
    NSArray *values = [cell representedObject];
    if(values == nil)
        return NSNotFound;
    else
        return (int)[values indexOfObject:st];
}

-(iStroke::CommandType::Type) index:(NSString *)str
{
    NSUInteger idx=[typeList indexOfObject:str];
    if (idx==NSNotFound) {
        idx=[typeList count]-1;
    }
    
    return (iStroke::CommandType::Type)idx;
}

@end