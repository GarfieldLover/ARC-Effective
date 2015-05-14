//
//  MBMicroBlogCell.h
//  MicroBlog
//
//  Created by Reese on 13-4-16.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef enum{
	TweetTypeNormal = 0,
	TweetTypeMine,
	TweetTypeReward,
} MBTweetType;

@interface MBMicroBlogCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *tweetContent;
@property (retain, nonatomic) IBOutlet UIImageView *tweetAttachmentImage;
@property (retain, nonatomic) IBOutlet UIImageView *userHead;
@property (retain, nonatomic) IBOutlet UILabel *userNickname;
@property (retain, nonatomic) IBOutlet UIView *leftView;
@property (retain, nonatomic) IBOutlet UIView *rightView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;



- (void)setTweetType:(MBTweetType)aType;
@end
