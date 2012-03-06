//
//  Application.m
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Application.hh"
#import "Action.hh"

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

-(void) addChildApplication:(Application *)app
{
    app.parent=self;
    [children addObject:app];
}

-(void) removeFromParent
{
    if (parent) {
        [parent.children removeObject:self];
    }
    parent=nil;
}

-(NSDictionary *) save
{
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setObject:name forKey:@"name"];
    [dict setObject:identifier forKey:@"id"];
    
    if ([children count]>0) {
        NSMutableArray *childArray=[NSMutableArray new];
        [dict setObject:childArray forKey:@"child"];
        for (NSUInteger i=0,n=[children count]; i<n;++i) {
            [childArray addObject:[(Application*)[children objectAtIndex:i] save]];
        }
        [childArray release];
    }
    return dict;
}

-(BOOL) load:(NSDictionary *)dict
{
    [name release];
    if (!(name=[dict objectForKey:@"name"])) {
        return NO;
    }
    [identifier release];
    if (!(identifier=[dict objectForKey:@"id"])) {
        return NO;
    }
    
    NSArray *childArray=[dict objectForKey:@"child"];
    if (!childArray) {
        return YES;
    }
    
    for (NSUInteger i=0,n=[childArray count]; i<n; ++i) {
        Application *app=[[Application alloc] init];
        [app load:[childArray objectAtIndex:i]];
        [self addChildApplication:app];
    }
    return YES;
}

@end
