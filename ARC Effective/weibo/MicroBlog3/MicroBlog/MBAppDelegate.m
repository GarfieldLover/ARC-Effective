//
//  MBAppDelegate.m
//  MicroBlog
//
//  Created by Reese on 13-4-15.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBAppDelegate.h"
#import "MBLoginViewController.h"




@implementation MBAppDelegate

- (void)dealloc
{
    [_window release];
    [_homeNav release];
    [_mainTab release];
    [_customTab release];
    [_messageNav release];
    [_profileNav release];
    [_discoverNav release];
    [_moreNav release];
    [_loginNav release];
    [_homeTab release];
    [_windowBg release];
    [_windowShadow release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    
    
    
    
    
    NSLog(@"1111");
    [_homeNav.view.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [_homeNav.view.layer setShadowOffset:CGSizeMake(-10, 0)];
    [_homeNav.view.layer setShadowOpacity:0.5];
    
    
    [_homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [_messageNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [_profileNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [_discoverNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [_moreNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [_loginNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    
    

    
    
    [_mainTab.tabBar setHidden:YES];
   
    [_customTab setFrame:CGRectMake(0, _mainTab.view.bounds.size.height-49, 320, 49)];
    
    [_mainTab.view addSubview:_customTab];
    [self checkLogin];
    
    
    //血的警告与教训
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//检测用户是否登陆
- (void)checkLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_EMAIL]==nil ) {
        

        [_homeNav presentViewController:_loginNav animated:YES completion:nil];
        
        for (int i=10001; i<=10005; i++) {
            UIButton *temp=(UIButton*)[_customTab viewWithTag:i];
            [temp setEnabled:temp.tag==10001?NO:YES];
        }
        [_mainTab setSelectedIndex:0];
        
    }else
    {
       return; 
    }
}



- (IBAction)tabbarItemClick:(id)sender {
    UIButton *but=sender;
    [_mainTab setSelectedIndex:but.tag-10001];
    [sender setEnabled:NO];
    
    for (int i=10001; i<=10005; i++) {
        UIButton *temp=(UIButton*)[_customTab viewWithTag:i];
        [temp setEnabled:temp.tag==but.tag?NO:YES];
    }
    
}

- (void)showTabbarWithAnimation:(BOOL)animation{
    if (animation) {
        CABasicAnimation *moveSlider=[CABasicAnimation animationWithKeyPath:@"position"];
        [moveSlider setFromValue:[NSValue valueWithCGPoint:CGPointMake(_customTab.layer.position.x, _customTab.layer.position.y)]];
        [moveSlider setToValue:[NSValue valueWithCGPoint:CGPointMake(_customTab.layer.position.x+320, _customTab.layer.position.y)]];
        [moveSlider setDuration:0.26f];
        [moveSlider setDelegate:self];
        [moveSlider setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_customTab.layer addAnimation:moveSlider forKey:nil];
    }
    

   // [_customTab performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.25f];
    [_customTab setHidden:NO];
    
    
}

- (void)hideTabbar
{
    CABasicAnimation *moveSlider=[CABasicAnimation animationWithKeyPath:@"position"];
    [moveSlider setFromValue:[NSValue valueWithCGPoint:CGPointMake(_customTab.layer.position.x, _customTab.layer.position.y)]];
    [moveSlider setToValue:[NSValue valueWithCGPoint:CGPointMake(_customTab.layer.position.x-320, _customTab.layer.position.y)]];
    [moveSlider setDuration:0.26f];
    [moveSlider setDelegate:self];
    [moveSlider setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_customTab.layer addAnimation:moveSlider forKey:nil];
    [_customTab performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.26f];
    

}


-(UIImageView *)getWindowBg
{
    return _windowBg;
}
-(UIView *)getWindowShadow
{
    return _windowShadow;
}
@end
