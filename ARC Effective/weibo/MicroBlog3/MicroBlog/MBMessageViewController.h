//
//  MBMessageViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-19.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MBMessageViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *sliderBar;
@property (retain, nonatomic) IBOutlet UIView *titleView;
- (IBAction)navigationTabClicked:(id)sender;

@end
