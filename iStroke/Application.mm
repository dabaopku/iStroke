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
-(void) addAction:(id)action
{
    assert([action isKindOfClass:[Action class]]);
    [self.actions addObject:[action retain]];
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
