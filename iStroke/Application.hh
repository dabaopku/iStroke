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

@end

@interface ApplicationManager:NSObject
    <NSOutlineViewDataSource,NSOutlineViewDelegate,NSTableViewDataSource,NSTableViewDelegate> {
        
    NSMutableArray * applications;
    Application * curApp;

    IBOutlet CommandTypeDelegate *commandTypeDelegate;
    IBOutlet NSTableView * gestureTableView;
    IBOutlet NSOutlineView *applicationOutlineView;
}

@property(retain) NSMutableArray * applications;
@property(retain) Application *curApp;

-(Application *) findApplication:(NSString *)identifier;

-(void) addAction:(id)action;
-(BOOL) addApplication:(NSString *)appIdentifier;
-(void) addGroup;

@end