//
//  Application.h
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.hh"
#import "Gesture.hh"

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

@end

@interface ApplicationManager:NSObject
    <NSOutlineViewDataSource,NSOutlineViewDelegate,NSTableViewDataSource,NSTableViewDelegate> {
        
    NSMutableArray * applications;
    Application * curApp;

    IBOutlet CommandTypeDelegate *commandTypeDelegate;
}

@property(retain) NSMutableArray * applications;
@property(retain) Application *curApp;

-(void) addAction:(id)action;


@end