//
//  MBMicroBlogCell.m
//  MicroBlog
//
//  Created by Reese on 13-4-16.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBMicroBlogCell.h"

@implementation MBMicroBlogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    
    
    [_userHead.layer setCornerRadius:4.0];
    [_userHead setClipsToBounds:YES];
    [super layoutSubviews];
}


- (void)setTweetType:(MBTweetType)aType
{
    switch (aType) {
        case TweetTypeNormal:
        {
            [_leftView setCenter:CGPointMake(30, _leftView.center.y)];
            [_rightView setCenter:CGPointMake(60+130, _rightView.center.y)];
            [_bottomView setCenter:CGPointMake(60+130, _bottomView.center.y)];
        }
            break;
        case TweetTypeMine:
        {
            [_leftView setCenter:CGPointMake(260+36, _leftView.center.y)];
            [_rightView setCenter:CGPointMake(140, _rightView.center.y)];
            [_bottomView setCenter:CGPointMake(140, _bottomView.center.y)];

        }
            break;
        default:
            break;
    }
    
    
}


- (void)dealloc {
    [_tweetContent release];
    [_tweetAttachmentImage release];
    [_userHead release];
    [_userNickname release];
    [_leftView release];
    [_rightView release];
    [_bottomView release];
    [super dealloc];
}
@end
