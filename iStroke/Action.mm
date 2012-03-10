//
//  Action.mm
//  iStroke
//
//  Created by dabao on 12-2-25.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Action.hh"

@implementation Action

@synthesize gesture;
@synthesize image;
@synthesize name;
@synthesize cmd;

- (id)initWithStroke:(iStroke::Stroke *)s
{
    self = [super init];
    if (self) {
        Gesture *g=[[Gesture alloc] initWithStroke:s];
        self.gesture=g;
        [g saveImage];
        self.image=[g loadImage];
        self.name=@"gesture";
        self.cmd=[[Command alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	if(gesture) [gesture release];
    if(image) [image release];
    if(name) [name release];
    if(cmd) [cmd release];
    [super dealloc];
}

-(NSDictionary *) save
{
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setObject:name forKey:@"name"];
    [dict setObject:@"nil" forKey:@"cmd"];
    [dict setObject:[gesture save] forKey:@"gesture"];
    
    return dict;
}

-(id) initWithDict:(NSDictionary *)dict
{
    self=[super init];
    if(self)
    {
        self.name=[dict objectForKey:@"name"];
        self.gesture=[[Gesture alloc] initWithDict:[dict objectForKey:@"gesture"]];
        cmd=nil;
        self.image=[gesture loadImage];
    }
    
    return self;
}

@end
