//
//  UserEntity.h
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserEntity : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * userPassword;
@property (nonatomic, retain) NSNumber * userStatus;
@property (nonatomic, retain) NSString * userNickname;
@property (nonatomic, retain) NSNumber * userLevel;
@property (nonatomic, retain) NSNumber * userVerify;
@property (nonatomic, retain) NSString * userHead;
@property (nonatomic, retain) NSString * userDescription;

@end
