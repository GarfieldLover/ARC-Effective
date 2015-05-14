//
//  MBHomeViewController.h
//  MicroBlog
//
//  Created by Reese on 13-4-15.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface MBHomeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *currentTweetArray;
    EGORefreshTableHeaderView *_refreshHeaderView;
    int currentPageNum;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIImageView *popoverBg;
@property (retain, nonatomic) IBOutlet UIView *popoverView;
@property (retain, nonatomic) IBOutlet UITableView *weiboTable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
@property (retain, nonatomic) IBOutlet UIButton *realRefreshButton;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UILabel *floatingText;



//弹出视图

- (IBAction)dropDown:(id)sender;
- (IBAction)refreshTable:(id)sender;
- (IBAction)composeATweet:(id)sender;

@end
