//
//  MBAppDelegate.h
//  MicroBlog
//
//  Created by Reese on 13-4-15.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *homeNav;
@property (retain, nonatomic) IBOutlet UINavigationController *messageNav;
@property (retain, nonatomic) IBOutlet UINavigationController *profileNav;
@property (retain, nonatomic) IBOutlet UINavigationController *discoverNav;
@property (retain, nonatomic) IBOutlet UINavigationController *moreNav;
@property (retain, nonatomic) IBOutlet UINavigationController *loginNav;
@property (retain, nonatomic) IBOutlet UITabBarController *mainTab;
@property (retain, nonatomic) IBOutlet UIButton *homeTab;

@property (retain, nonatomic) IBOutlet UIView *customTab;
- (IBAction)tabbarItemClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *windowBg;
@property (retain, nonatomic) IBOutlet UIView *windowShadow;


//显示自定tabbar
- (void)showTabbarWithAnimation:(BOOL)animation;

- (void)hideTabbar;

@end
