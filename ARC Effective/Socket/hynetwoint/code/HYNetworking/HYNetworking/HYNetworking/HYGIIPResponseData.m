//
//  HYGIIPResponseData.m
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "HYGIIPResponseData.h"

@implementation HYGIIPResponseData
@synthesize time;
@synthesize result;
@synthesize failReason;
@synthesize stringObject;
@synthesize data;

-(id)init
{
    self=[super init];
    if(self){
        time=@"";
        result=notProcess;
        failReason=@"";
    }
    return self;
}

-(void)dealloc
{
    [time release];
    [failReason release];
    [stringObject release];
    [data release];
    [super dealloc];
}


@end
