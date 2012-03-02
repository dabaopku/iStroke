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

-(void) dealloc
{
    [actions release];
    [children release];
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

@end

@implementation ApplicationManager

@synthesize applications;
@synthesize curApp;

-(id) init
{
    self=[super init];
    if (self) {
        applications=[NSMutableArray new];
        curApp=[[Application alloc] init];
        curApp.name=NSLocalizedString(@"Default", @"");
        [applications addObject:[curApp retain]];
    }
    return self;
}

-(void) dealloc
{
    [commandTypeDelegate release];
}

-(Application *) findApplication:(NSString *)identifier
{
    NSMutableArray *queue=[NSMutableArray new];
    [queue addObjectsFromArray:applications];
    while ([queue count]>0) {
        Application *app=[queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        if ([app.identifier isEqualToString:identifier]) {
            return app;
        }
        [queue addObjectsFromArray:app.children];
    }
    return nil;
}

-(void) addAction:(id)action
{
    assert([action isKindOfClass:[Action class]]);
    [curApp.actions addObject:[action retain]];
}

-(BOOL) addApplication:(NSString *)appIdentifier
{
    Application *app=[self findApplication:appIdentifier];
    if (app!=nil) {
        return NO;
    }
    app=[[Application alloc] init];
    app.identifier=appIdentifier;
    app.name=appIdentifier;
    
    Application *parent=curApp.parent;
    if (parent==nil) {
        [applications addObject:app];
    }
    else
    {
        [parent.children addObject:app];
    }
    return YES;
}

#pragma mark - NSOutlineView

-(id) outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item) {
        return [[(Application*)item children] objectAtIndex:index];
    }
    else
    {
        return [applications objectAtIndex:index];
    }
}

-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (!item) {
        return [applications count]>1;
    }
    return [[(Application*)item children] count]>0;
}

-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(item==nil)
        return [applications count];
    
    return [[(Application *)item children] count];
}

-(id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return ((Application*)item).name;
}


-(void) outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[Application class]]) {
        [(Application *)item setName:object];
    }
}


#pragma mark - NSTableView


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [curApp.actions count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[curApp.actions objectAtIndex:row];
    
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
    Action *act=[curApp.actions objectAtIndex:row];
    
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
        [(NSTextFieldCell *)cell setVerticalCentering:YES];
    }
}


@end











