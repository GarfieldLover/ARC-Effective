//
//  MBDiscoverViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-20.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MBDiscoverViewController : UIViewController<UISearchBarDelegate,UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScroller;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *appIcons;
@property (retain, nonatomic) IBOutlet UIPageControl *pageController;
@property (retain, nonatomic) IBOutlet UISegmentedControl *searchType;

@end
