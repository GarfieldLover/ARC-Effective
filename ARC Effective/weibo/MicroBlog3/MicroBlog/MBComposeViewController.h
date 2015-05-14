//
//  MBComposeViewController.h
//  MicroBlog
//
//  Created by Reese on 13-5-8.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBComposeViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
@property (retain, nonatomic) IBOutlet UITextView *contentText;
- (IBAction)pushBack:(id)sender;
- (IBAction)publicClicked:(id)sender;
- (IBAction)privateButtonClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *publicText;
@property (retain, nonatomic) IBOutlet UIButton *publicButton;
@property (retain, nonatomic) IBOutlet UILabel *privateText;
@property (retain, nonatomic) IBOutlet UIButton *privateButton;
@property (retain, nonatomic) IBOutlet UILabel *userNickname;


//发微博
- (IBAction)publishThisTweet:(id)sender;


@end
