//
//  User.h
//  JsonParser
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Name.h"


@interface User : NSObject<NSCoding>

@property (nonatomic,assign) int UserID;
@property (nonatomic,strong) Name* Name;
@property (nonatomic,strong) NSString* Email;


@end
