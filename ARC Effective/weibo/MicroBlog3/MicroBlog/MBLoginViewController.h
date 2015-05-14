//
//  MBLoginViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBDBManager.h"
#import <QuartzCore/QuartzCore.h>

@interface MBLoginViewController : UIViewController<UIGestureRecognizerDelegate>
- (IBAction)closeKeyborad:(id)sender;
- (IBAction)startLogin:(id)sender;
- (IBAction)rewardToRegister:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *userEmail;
@property (retain, nonatomic) IBOutlet UITextField *userPassword;
@property (retain, nonatomic) IBOutlet UIButton *findPasswordButton;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIButton *signUpButton;
@property (retain, nonatomic) IBOutlet UIButton *signInButton;

@end
