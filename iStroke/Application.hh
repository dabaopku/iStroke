//
//  Application.h
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Action.hh"
#import "Gesture.hh"
#include <fstream>

#define ApplicationPasteType @"ApplicationPasteType"
#define GesturePasteType @"GesturePasteType"

namespace iStroke {
   struct MatchResult
    {
        double score;
        Action *action;
    };
}

@interface Application : NSObject{
    NSString *identifier;
    NSString *name;
    NSMutableArray *actions;
    
    Application *parent;
    NSMutableArray *children;
}

@property(retain) NSMutableArray *actions;
@property(retain) NSString *identifier;
@property(retain) NSString *name;
@property(retain) NSMutableArray *children;
@property(retain) Application *parent;

-(NSArray*) allAction;
-(iStroke::MatchResult) matchAction:(iStroke::Stroke *)stroke;
-(void) addChildApplication:(Application *)app;
-(void) removeFromParent;

-(NSDictionary *) save;
-(id) initWithDict:(NSDictionary *)dict;

@end
