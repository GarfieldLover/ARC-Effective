//
//  HYResponseData.m
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "HYResponseData.h"

@implementation HYResponseData
@synthesize responseString;
@synthesize responseData;

-(void)dealloc
{
    [responseString release];
    [responseData release];
    [super dealloc];
}

@end
