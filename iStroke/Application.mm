//
//  Application.m
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Application.hh"
#import "Action.hh"
#import "NSTextFieldCell+VerticalCenter.h"

@implementation Application

@synthesize name;
@synthesize identifier;
@synthesize actions;
@synthesize children;
@synthesize parent;

-(id) init
{
    self=[super init];
    if(self)
    {
        children=[NSMutableArray new];
        parent=nil;
        actions=[NSMutableArray new];
        //commandTypeDelegate=[[CommandTypeDelegate alloc] init];
    }
    return self;
}
-(void) addAction:(id)action
{
    assert([action isKindOfClass:[Action class]]);
    [self.actions addObject:[action retain]];
}

-(void) dealloc
{
    [actions release];
    [children release];
    [commandTypeDelegate release];
}

-(NSArray *) allAction
{
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.actions];
    Application *p=parent;
    
    while (p) {
        [array addObjectsFromArray:p.actions];
        p=p->parent;
    }
    return array;
}

-(iStroke::MatchResult) matchAction:(iStroke::Stroke *)stroke
{
    Application *p=self;
    iStroke::MatchResult res;
    res.action=nil;
    res.score=0;
    
    while (p) {
        for (NSInteger i=0,n=[p.actions count]; i<n; ++i) {
            Action *act=[p.actions objectAtIndex:i];
            iStroke::Stroke * s=act.gesture.stroke;
            double cmp=s->compare(*stroke);
            if (cmp>res.score) {
                res.action=act;
                res.score=cmp;
            }
        }
        
        p=p->parent;
    }
    
    return res;
}

#pragma mark - NSTableView


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [actions count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[actions objectAtIndex:row];
    
    if ([col isEqualToString:@"gesture"]) {
        return [act image];
    }
    if ([col isEqualToString:@"name"]) {
        return [act name];
    }
    if ([col isEqualToString:@"type"]) {
        return CommandType::ToString(act.cmd.type);
    }
    if ([col isEqualToString:@"cmd"]) {
        return [act name];
    }
    return nil;
}

-(void) tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[actions objectAtIndex:row];
    
    if([col isEqualToString:@"type"])
    {
        act.cmd.type=[commandTypeDelegate index:object];
    }
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    if([[tableColumn identifier] isEqual:@"type"] && [cell isKindOfClass:[NSComboBoxCell class]])
    {
        [cell setRepresentedObject:[commandTypeDelegate typeList]];
        [cell reloadData];
    }
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        [cell setVerticalCentering:YES];
    }
}


@end
