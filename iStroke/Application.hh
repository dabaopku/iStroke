//
//  Application.h
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application:NSMutableArray{
    NSString *identifier;
    NSString *name;
}

-(void) addObject:(id)anObject;

@end