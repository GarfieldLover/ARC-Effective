//
//  MBDBManager.h
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "TweetEntity.h"
#import <sqlite3.h>

@interface MBDBManager : NSObject
{
   // MBDBManager *defaultManager;
    sqlite3 *database;
}

+ (MBDBManager*)defaultManager;
- (BOOL)db_open;


//用户表相关方法

-(BOOL)createUserTable;


-(long long int)insertNewUser:(UserEntity*)aUser;
-(BOOL)checkIsRegisterd:(NSString*)aUserEmail;
-(BOOL)checkLoginWithEmail:(NSString*)aUserEmail andPassword:(NSString*)aPassword;
-(UserEntity*)getUserAllInfoByEmail:(NSString*)aUserEmail;


//微博表相关方法

-(BOOL)createTweetTable;

-(long long int)insertNewTweet:(TweetEntity*)aTweet;

//获取一条微博信息，并根据userId获得对应用户的简单信息
//sortType 1 按时间正序   -1  按时间倒序
//pageIndex 最小值为1 即 最新的一页
-(NSMutableArray *)getNewestTweetWithPageSize:(int)pageSize andPageIndex:(int)pageIndex andSortType:(int)sortType;


@end
