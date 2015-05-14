//
//  MBConfigureViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-21.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBConfigureViewController.h"

@interface MBConfigureViewController ()

@end

@implementation MBConfigureViewController

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
    [_configScroll setContentSize:CGSizeMake(320, 666)];
    [self.navigationItem setTitleView:_titleView];
    [_configButton setBackgroundImage:[[UIImage imageNamed:@"navigationbar_button_background"]stretchableImageWithLeftCapWidth:6 topCapHeight:10] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:_configButton]];
    
    
    
    
    for (UILabel *label in _badgedLabels) {
        [label.layer setCornerRadius:3.0];
        [label setClipsToBounds:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_configScroll release];
    [_titleView release];
    [_badgedLabels release];
    [_configButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setConfigScroll:nil];
    [self setTitleView:nil];
    [self setBadgedLabels:nil];
    [self setConfigButton:nil];
    [super viewDidUnload];
}

- (IBAction)quitCurrentAccount:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MY_USER_EMAIL];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MY_USER_NICKNAME];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MY_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MY_USER_DESCRIPTION];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_EMAIL]);
    [getAppDelegate() checkLogin];
}
@end
