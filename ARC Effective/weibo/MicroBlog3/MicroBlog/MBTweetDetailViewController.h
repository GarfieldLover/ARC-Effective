//
//  MBTweetDetailViewController.h
//  MicroBlog
//
//  Created by Reese on 13-5-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef enum{
	kTweetDetailContentTypeFowards = 0,
	kTweetDetailContentTypeComments,
} MBTweetDetailContentType;


@interface MBTweetDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    MBTweetDetailContentType currentContentType;
    NSMutableArray *retweetsArray;
    NSMutableArray *commentsArray;
    
    
}

- (IBAction)rightSwipe:(id)sender;

@property (retain, nonatomic) IBOutlet UITableViewCell *userCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (retain, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (retain, nonatomic) IBOutlet UIButton *fowardButton;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;
@property (retain, nonatomic) IBOutlet UITableView *mainTable;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)checkFowards:(id)sender;
- (IBAction)checkComments:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *sliderImage;
- (IBAction)navBack:(id)sender;
@property (retain, nonatomic) IBOutlet UITableViewCell *emptyCommentsCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *emptyRetweetCell;

@end
