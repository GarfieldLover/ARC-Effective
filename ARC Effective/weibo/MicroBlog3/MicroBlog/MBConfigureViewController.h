//
//  MBConfigureViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-21.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MBConfigureViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *configScroll;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *badgedLabels;
@property (retain, nonatomic) IBOutlet UIButton *configButton;


- (IBAction)quitCurrentAccount:(id)sender;

@end
