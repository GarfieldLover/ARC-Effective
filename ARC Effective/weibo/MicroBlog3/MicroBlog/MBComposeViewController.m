//
//  MBComposeViewController.m
//  MicroBlog
//
//  Created by Reese on 13-5-8.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBComposeViewController.h"
#import "TweetEntity.h"
#import "MBDBManager.h"


#define YUANCHUANGWEIBO [NSNumber numberWithInt:0]
#define ZHUANFAWEIBO [NSNumber numberWithInt:1]

@interface MBComposeViewController ()

@end

@implementation MBComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [getAppDelegate() hideTabbar];
    
    [_contentText becomeFirstResponder];
    
    [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"navigationbar_button_background"]stretchableImageWithLeftCapWidth:6 topCapHeight:10] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[[UIImage imageNamed:@"navigationbar_button_background"]stretchableImageWithLeftCapWidth:6 topCapHeight:10] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_cancelButton];
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [barButtonItem release];
    barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_sendButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
    [_userNickname setText:[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_NICKNAME]];
    
    [self.navigationItem setTitleView:_titleView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleView release];
    [_cancelButton release];
    [_sendButton release];
    [_contentText release];

    [_publicText release];
    [_publicButton release];
    [_privateText release];
    [_privateButton release];
    [_userNickname release];
    [super dealloc];
}
- (IBAction)pushBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [getAppDelegate() showTabbarWithAnimation:YES];
}

- (IBAction)publicClicked:(id)sender {
    [_publicButton setHidden:YES];
    [_publicText setHidden:YES];
    [_privateButton setHidden:NO];
    [_privateText setHidden:NO];
}

- (IBAction)privateButtonClicked:(id)sender {
    [_publicButton setHidden:NO];
    [_publicText setHidden:NO];
    [_privateButton setHidden:YES];
    [_privateText setHidden:YES];
}
- (IBAction)publishThisTweet:(id)sender {
    TweetEntity *thisTweet=[[[TweetEntity alloc]init]autorelease];
    [thisTweet setTweetContent:_contentText.text];
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDate=[NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];

    [thisTweet setTimestamp:currentDate];
    [thisTweet setTrendCount:[NSNumber numberWithInt:1]];
    [thisTweet setIsRetweet:YUANCHUANGWEIBO];
    [thisTweet setRetweetCount:[NSNumber numberWithInt:0]];
    [thisTweet setTweetAttachment:[NSNumber numberWithInt:0]];
    [thisTweet setOwnerId:[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_ID]];
    [thisTweet setFavorCount:[NSNumber numberWithInt:1]];
    [thisTweet setCommentCount:[NSNumber numberWithInt:1]];
    [thisTweet setIsInSendBox:[NSNumber numberWithInt:0]];
    [thisTweet setDeviceInfo:@"iPhone客户端"];
    [thisTweet setLocation:@"重庆市"];
    
    
    //插入数据库
    int rowId= [[MBDBManager defaultManager]insertNewTweet:thisTweet];
    if (rowId==0) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"发送微博失败" message:@"失败原因：未知" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [av show];
        [av release];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [getAppDelegate() showTabbarWithAnimation:YES];

}
@end
