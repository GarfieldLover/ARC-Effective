//
//  MBRegisterViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBRegisterViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *userEmail;
@property (retain, nonatomic) IBOutlet UITextField *userPassword;
@property (retain, nonatomic) IBOutlet UITextField *userNickname;
@property (retain, nonatomic) IBOutlet UITextField *userDescription;
@property (retain, nonatomic) IBOutlet UIButton *navBackButton;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScroller;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIButton *userHead;





- (IBAction)startRegister:(id)sender;
- (IBAction)pushBack:(id)sender;
- (IBAction)chooseUserHead:(id)sender;
- (IBAction)tapTouch:(id)sender;

@end
