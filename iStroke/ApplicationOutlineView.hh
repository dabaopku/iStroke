//
//  ApplicationOutlineView.hh
//  iStroke
//
//  Created by dabao on 12-3-6.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.hh"

@interface ApplicationOutlineView : NSOutlineView {

    IBOutlet ApplicationManager *appManager;
    
}

@property(retain) ApplicationManager *appManager;

- (void)addApplication:(NSString *)identifier;
-(void) addGroup;

@end
