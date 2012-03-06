//
//  ApplicationManager.hh
//  iStroke
//
//  Created by dabao on 12-3-6.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Application.hh"
#import "NSTextFieldCell+VerticalCenter.h"

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

-(void) save;
-(void) load;
@end