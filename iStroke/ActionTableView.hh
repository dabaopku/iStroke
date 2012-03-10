//
//  ActionTableView.h
//  iStroke
//
//  Created by dabao on 12-3-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Application;
@interface ActionTableView : NSTableView {
    Application *app;
}

@property(retain) Application *app;
@end
