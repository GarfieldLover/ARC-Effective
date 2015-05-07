//
//  HYNetworkData.m
//  HYNetworking
//
//  Created by zhangke on 13-4-17.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "HYNetworkData.h"

@implementation HYNetworkData
@synthesize body;
@synthesize URL;
@synthesize classInstance;
@synthesize interfaceName;

-(void)dealloc
{
    [body release];
    [URL release];
    [classInstance release];
    [interfaceName release];
    [super dealloc];
}

+(HYNetworkData*)networkData
{
    HYNetworkData* data=[[[HYNetworkData alloc] init] autorelease];
    return data;
}


@end
