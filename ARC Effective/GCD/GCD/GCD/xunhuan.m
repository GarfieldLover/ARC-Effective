//
//  xunhuan.m
//  GCD
//
//  Created by zhangke on 15/5/16.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "xunhuan.h"

@implementation xunhuan

-(void)loadString:(testBlock)block
{
//    sleep(2);
    
    aBlock=[block copy];
    
    block(@"testtest",0.3);
    
    
}


@end
