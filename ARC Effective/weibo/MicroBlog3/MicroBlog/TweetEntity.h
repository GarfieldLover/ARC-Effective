//
//  TweetEntity.h
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TweetEntity : NSObject

@property (nonatomic, retain) NSNumber * tweetId;
@property (nonatomic, retain) NSString * tweetContent;
@property (nonatomic, retain) NSNumber * tweetAttachment;
@property (nonatomic, retain) NSNumber * isRetweet;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * deviceInfo;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSNumber * retweetCount;
@property (nonatomic, retain) NSNumber * trendCount;
@property (nonatomic, retain) NSNumber * favorCount;
@property (nonatomic, retain) NSString * attachment;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * locationX;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, retain) NSNumber * ownerId;
@property (nonatomic, retain) NSNumber * isInSendBox;

@end
