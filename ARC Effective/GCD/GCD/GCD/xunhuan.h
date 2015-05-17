//
//  xunhuan.h
//  GCD
//
//  Created by zhangke on 15/5/16.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^testBlock)(NSString* test , float process);


@interface xunhuan : NSObject{
    testBlock aBlock;
}

@property (nonatomic, strong) id ooo;


-(void)loadString:(testBlock)block;

@end
