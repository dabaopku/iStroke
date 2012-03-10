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
    
    if ([actions count]>0) {
        NSMutableArray *actionArray=[NSMutableArray new];
        [dict setObject:actionArray forKey:@"action"];
        for (NSUInteger i=0,n=[actions count]; i<n; ++i) {
            [actionArray addObject:[(Action*)[actions objectAtIndex:i] save]];
        }
        [actionArray release];
    }
    return dict;
}

-(id) initWithDict:(NSDictionary *)dict
{
    self=[super init];
    
    if (self) {
        self.parent=nil;
        self.name=[dict objectForKey:@"name"];
        if (!name) {
            self.name=@"No name";
        }
        
        self.identifier=[dict objectForKey:@"id"];
        if (!identifier) {
            [name release];
            return nil;
        }
        
        self.actions=[NSMutableArray new];
        self.children=[NSMutableArray new];
        
        NSArray *childArray=[dict objectForKey:@"child"];
        if (childArray) {        
            for (NSUInteger i=0,n=[childArray count]; i<n; ++i) {
                Application *app=[[Application alloc] initWithDict:[childArray objectAtIndex:i]];
                if (app) {
                    [self addChildApplication:app];
                    [app release];
                }
            }
        }
        NSArray *actionArray=[dict objectForKey:@"action"];
        if (actionArray) {
            for (NSUInteger i=0,n=[actionArray count]; i<n; ++i) {
                Action *act=[[Action alloc] initWithDict:[actionArray objectAtIndex:i]];
                if (act) {
                    [actions addObject:act];
                    [act release];
                }
            }
        }
    }
    
    return self;    
    
}

@end
