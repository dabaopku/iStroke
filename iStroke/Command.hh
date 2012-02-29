//
//  Command.h
//  iStroke
//
//  Created by dabao on 12-2-28.
//  Copyright 2012年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - CommandType

namespace iStroke {
    class CommandType
    {
    public:
        typedef enum{
            Keyboard = 0,
            Mouse = 1,
            Menu = 2,
            Other = 3,
            None = 4,
        } Type;
        
        static NSString* ToString(Type t);
    };
}

#pragma mark - Command

@interface Command : NSObject {
@private
    iStroke::CommandType::Type type;
    NSString * value;
    
}

@property(assign) iStroke::CommandType::Type type;
@property(retain) NSString * value;

@end

#pragma mark - CommandTypeDelegate

@interface CommandTypeDelegate : NSObject<NSComboBoxDelegate> {

    NSArray *typeList;
}

@property(retain) NSArray *typeList;

-(iStroke::CommandType::Type) index:(NSString *)str;

@end
