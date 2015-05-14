//
//  MBLoginViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBLoginViewController.h"
#import "MBRegisterViewController.h"

@interface MBLoginViewController ()

@end

@implementation MBLoginViewController

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
    [self.navigationItem setTitleView:_titleView];
     [_findPasswordButton setBackgroundImage:[[UIImage imageNamed:@"navigationbar_button_background"]stretchableImageWithLeftCapWidth:6 topCapHeight:10] forState:UIControlStateNormal];
    [_signUpButton setBackgroundImage:[[UIImage imageNamed:@"login_signupbutton_background"]stretchableImageWithLeftCapWidth:7 topCapHeight:15] forState:UIControlStateNormal];
    [_signInButton setBackgroundImage:[[UIImage imageNamed:@"login_signinbutton_background"]stretchableImageWithLeftCapWidth:7 topCapHeight:15] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeKeyborad:(id)sender {
}

- (IBAction)startLogin:(id)sender {
    
    
    if ([[MBDBManager defaultManager]checkLoginWithEmail:_userEmail.text andPassword:_userPassword.text]) {
        UserEntity *myUserInfo=[[MBDBManager defaultManager]getUserAllInfoByEmail:_userEmail.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:myUserInfo.userEmail forKey:MY_USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setObject:_userPassword.text forKey:MY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:myUserInfo.userNickname forKey:MY_USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:myUserInfo.userDescription forKey:MY_USER_DESCRIPTION];
        [[NSUserDefaults standardUserDefaults] setObject:myUserInfo.userId forKey:MY_USER_ID];
        
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"用户名或者密码错误" message:@"注册失败" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }

    
}

- (IBAction)rewardToRegister:(id)sender {
    MBRegisterViewController *registView=[[[MBRegisterViewController alloc]init]autorelease];

    
    
    [self.navigationController pushViewController:registView animated:YES];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.view.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
    
    }
}

- (void)dealloc {
    [_userEmail release];
    [_userPassword release];
    [_findPasswordButton release];
    [_titleView release];
    [_signUpButton release];
    [_signInButton release];
    [super dealloc];
}
@end
