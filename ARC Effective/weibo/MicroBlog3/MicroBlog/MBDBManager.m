//
//  MBDBManager.m
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//  单例

#import "MBDBManager.h"

@implementation MBDBManager

static MBDBManager *defaultManager;

+(MBDBManager*) defaultManager
{
    if (defaultManager==nil) {
        defaultManager =[[MBDBManager alloc]init];
    }
    return defaultManager;
}


-(id)init
{
    [self db_open];
   self= [super init];
    return self;
}

- (BOOL)db_open{
    NSString *dbPath =pathInCacheDirectory(@"WBDatabase");
    if (sqlite3_open([dbPath UTF8String], &database)==SQLITE_OK) {
        return YES;
    }
    return NO;
}




#pragma mark —————————————用户表———————————————————
-(BOOL)createUserTable
{
    NSString *createTableSQLStr = [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS 'userTable' ('userId' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'userEmail' TEXT, 'userPassword' TEXT, 'userStatus' INTEGER, 'userNickname' TEXT, 'userLevel' INTEGER, 'userVerify' INTEGER, 'userHead' TEXT, 'userDescription' TEXT)"];
    
    const char *createTableSQL = [createTableSQLStr cStringUsingEncoding:NSASCIIStringEncoding];
    char *errMsg;
    if (sqlite3_exec(database, createTableSQL, NULL, NULL, &errMsg)==SQLITE_OK) {
        return YES;
    }else{
            NSLog(@"SQL:%@发生错误:%s",createTableSQLStr,errMsg);
    }
    return NO;

}


-(long long int)insertNewUser:(UserEntity*)aUser
{
    if (![self createUserTable]) {
        NSLog(@"数据库建表失败");
        return 0;
    }
    NSString *stringInsertSQL = [NSString stringWithFormat:@"INSERT INTO 'userTable' ('userEmail','userPassword','userNickname','userLevel','userVerify','userHead','userDescription') VALUES ('%@','%@','%@',%@,%@,'%@','%@')",aUser.userEmail,aUser.userPassword,aUser.userNickname,aUser.userLevel,aUser.userVerify,aUser.userHead,aUser.userDescription];
    const char *charInsertSQL = [stringInsertSQL cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *insertStmt;
    if (sqlite3_prepare_v2(database, charInsertSQL, -1, &insertStmt, NULL)==SQLITE_OK) {
        if (sqlite3_step(insertStmt)==SQLITE_DONE) {
            return sqlite3_last_insert_rowid(database);
        }else{
            NSLog(@"SQL执行:%@失败:%s",stringInsertSQL,sqlite3_errmsg(database));
        }
    }else{
        NSLog(@"SQL执行:%@失败:%s",stringInsertSQL,sqlite3_errmsg(database));
    }
    
    return 0;
    
}


-(BOOL)checkIsRegisterd:(NSString*)aUserEmail{
    NSString *stringQuerySQL = [NSString stringWithFormat:@"SELECT userEmail FROM userTable where userEmail='%@'",aUserEmail];
    const char *charQuerySQL = [stringQuerySQL cStringUsingEncoding:NSUTF8StringEncoding];
    
    sqlite3_stmt *queryStatement;
    if (sqlite3_prepare_v2(database, charQuerySQL, -1, &queryStatement, NULL)==SQLITE_OK) {
        while (sqlite3_step(queryStatement)==SQLITE_ROW) {
            return YES;
        }
        return NO;
    }
    return NO;
}

-(BOOL)checkLoginWithEmail:(NSString*)aUserEmail andPassword:(NSString*)aPassword
{
    NSString *stringQuerySQL = [NSString stringWithFormat:@"SELECT userEmail,userPassword FROM userTable where userEmail='%@'",aUserEmail];
    const char *charQuerySQL = [stringQuerySQL cStringUsingEncoding:NSUTF8StringEncoding];
    
    sqlite3_stmt *queryStatement;
    if (sqlite3_prepare_v2(database, charQuerySQL, -1, &queryStatement, NULL)==SQLITE_OK) {
        while (sqlite3_step(queryStatement)==SQLITE_ROW) {
            NSString *password=[NSString stringWithFormat:@"%s",sqlite3_column_text(queryStatement, 1) ] ;
            
            
            if ([password isEqualToString:aPassword]) return YES;
        }
        return NO;
    }
    return NO;
}
-(UserEntity*)getUserAllInfoByEmail:(NSString*)aUserEmail{
    NSString *stringQuerySQL = [NSString stringWithFormat:@"SELECT userId,userEmail,userNickname,userDescription FROM userTable where userEmail='%@'",aUserEmail];
    const char *charQuerySQL = [stringQuerySQL cStringUsingEncoding:NSUTF8StringEncoding];
    
    sqlite3_stmt *queryStatement;
    UserEntity *thisUser=[[[UserEntity alloc]init]autorelease];
    
    
    if (sqlite3_prepare_v2(database, charQuerySQL, -1, &queryStatement, NULL)==SQLITE_OK) {
        while (sqlite3_step(queryStatement)==SQLITE_ROW) {
            [thisUser setUserId:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 0)] ];
            [thisUser setUserEmail:[NSString stringWithFormat:@"%s",sqlite3_column_text(queryStatement, 1) ]] ;
            [thisUser setUserNickname:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 2)] ];
            [thisUser setUserDescription:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 3)] ] ;
            
            
            if (thisUser.userId!=nil) return thisUser;
                else return nil;
        }
        return nil;
    }
    return nil;

}



#pragma mark   =========微博表增删改查==========


- (BOOL)createTweetTable
{
    NSString *createTableSQLStr = [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS 'tweetTable' ('tweetId' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  , 'tweetContent' TEXT, 'tweetAttachment' INTEGER, 'isRetweet' INTEGER, 'timestamp' TEXT, 'deviceInfo' TEXT, 'commentCount' INTEGER, 'retweetCount' INTEGER, 'trendCount' INTEGER, 'favorCount' INTEGER, 'attachment' TEXT, 'location' TEXT, 'locationX' DOUBLE, 'locationY' DOUBLE,'isInSendBox' INTEGER,'ownerId' INTEGER)"];
    
    const char *createTableSQL = [createTableSQLStr cStringUsingEncoding:NSASCIIStringEncoding];
    char *errMsg;
    if (sqlite3_exec(database, createTableSQL, NULL, NULL, &errMsg)==SQLITE_OK) {
        return YES;
    }else{
        NSLog(@"SQL:%@发生错误:%s",createTableSQLStr,errMsg);
    }
    return NO;
    
   
}


-(long long int)insertNewTweet:(TweetEntity*)aTweet
{
    if (![self createTweetTable]) {
        NSLog(@"数据库建表失败");
        return 0;
    }
    NSString *stringInsertSQL = [NSString stringWithFormat:@"INSERT INTO 'tweetTable' ('tweetContent','tweetAttachment','isRetweet','timestamp','deviceInfo','commentCount','retweetCount','trendCount','favorCount','location','locationX','locationY','isInSendBox','ownerId') VALUES ('%@',%@,%@,'%@','%@',%@,%@,%@,%@,'%@',%@,%@,%@,%@)",aTweet.tweetContent,aTweet.tweetAttachment,aTweet.isRetweet,aTweet.timestamp,aTweet.deviceInfo,aTweet.commentCount,aTweet.retweetCount,aTweet.trendCount,aTweet.favorCount,aTweet.location,aTweet.locationX,aTweet.locationY,aTweet.isInSendBox,aTweet.ownerId];
    const char *charInsertSQL = [stringInsertSQL cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *insertStmt;
    if (sqlite3_prepare_v2(database, charInsertSQL, -1, &insertStmt, NULL)==SQLITE_OK) {
        if (sqlite3_step(insertStmt)==SQLITE_DONE) {
            return sqlite3_last_insert_rowid(database);
        }else{
            NSLog(@"SQL执行:%@失败:%s",stringInsertSQL,sqlite3_errmsg(database));
        }
    }else{
        NSLog(@"SQL执行:%@失败:%s",stringInsertSQL,sqlite3_errmsg(database));
    }
    
    return 0;

}


-(NSMutableArray *)getNewestTweetWithPageSize:(int)pageSize andPageIndex:(int)pageIndex andSortType:(int)sortType
{
    NSString *sortTypeString=sortType==1?@"ASC":@"DESC";
    int fromIdex=(pageIndex-1)*pageSize;
    
    
    NSString *stringQuerySQL = [NSString stringWithFormat:@"SELECT  t.tweetContent,t.tweetAttachment,t.isRetweet,t.timestamp,t.deviceInfo,t.commentCount,t.retweetCount,t.trendCount,t.favorCount,t.location,t.isInSendBox,t.ownerId,u.userId,u.userNickname,u.userHead,u.userVerify  FROM tweetTable as t,userTable as u WHERE t.ownerId=u.userId ORDER BY t.tweetId %@ limit  %d,%d",sortTypeString,fromIdex,pageSize];
    const char *charQuerySQL = [stringQuerySQL cStringUsingEncoding:NSUTF8StringEncoding];
    
    sqlite3_stmt *queryStatement;
    NSMutableArray *resultArray=[[[NSMutableArray alloc]init]autorelease];
    
    
    if (sqlite3_prepare_v2(database, charQuerySQL, -1, &queryStatement, NULL)==SQLITE_OK) {
        while (sqlite3_step(queryStatement)==SQLITE_ROW) {
            NSMutableDictionary *thisTweet=[[[NSMutableDictionary alloc]init]autorelease];
            
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 0)]  forKey:@"tweetContent"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 1)]   forKey:@"tweetAttachment"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 2)]   forKey:@"isRetweet"];
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 3)]    forKey:@"timestamp"];
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 4)]   forKey:@"deviceInfo"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 5)]   forKey:@"commentCount"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 6)]   forKey:@"retweetCount"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 7)]   forKey:@"trendCount"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 8)]   forKey:@"favorCount"];
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 9)]   forKey:@"location"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 10)]   forKey:@"isInSendBox"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 11)]   forKey:@"ownerId"];
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 13)]   forKey:@"userNickname"];
            [thisTweet setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStatement, 14)]   forKey:@"userHead"];
            [thisTweet setObject:[NSNumber numberWithInt:sqlite3_column_int(queryStatement, 15)]  forKey:@"userVerify"];
            
            [resultArray addObject:thisTweet];
        }
        return resultArray;
    }
    NSLog(@"数据库查询失败");
    return nil;

}

@end
 