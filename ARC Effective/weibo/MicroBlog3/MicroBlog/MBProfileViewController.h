//
//  MBProfileViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-19.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MBProfileViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIImageView *titleArrow;
@property (retain, nonatomic) IBOutlet UIView *popoverView;
@property (retain, nonatomic) IBOutlet UIImageView *popoverBg;
@property (retain, nonatomic) IBOutlet UIView *tableShadow;



//弹出视图
- (IBAction)dropDown:(id)sender;

@end
