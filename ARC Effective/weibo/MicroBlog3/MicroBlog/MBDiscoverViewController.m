//
//  MBDiscoverViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-20.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBDiscoverViewController.h"

@interface MBDiscoverViewController ()

@end

@implementation MBDiscoverViewController

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
    
    [_mainScroller setContentSize:CGSizeMake(960, 320)];
    for (UIButton *but in _appIcons) {
        [but setBackgroundImage:[[UIImage imageNamed:@"interest_list_book"]stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];
            
        
    }
    
}


#pragma mark —————scrollView delegate—————————


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageCount= scrollView.contentOffset.x/320;
    [_pageController setCurrentPage:pageCount];
}


#pragma mark —————————searchBar的 delegate—————————————
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //上移获得焦点
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration =0.25f;
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y);
    CGPathAddLineToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y-44); //添加一条路径
    positionAnimation.path = path; //设置移动路径为刚才创建的路径
    CGPathRelease(path);
    positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [self.navigationController.view.layer addAnimation:positionAnimation forKey:@"searchBarFocus"];
    
    
    [self.navigationController.view setCenter:CGPointMake(160, self.navigationController.view.center.y-44)];
    [_mainScroller setHidden:YES];
    [_searchType setHidden:NO];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    
}




-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //下移 取消焦点
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration =0.25f;
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y);
    CGPathAddLineToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y+44); //添加一条路径
    positionAnimation.path = path; //设置移动路径为刚才创建的路径
    CGPathRelease(path);
    positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [self.navigationController.view.layer addAnimation:positionAnimation forKey:@"searchBarFocus"];
    
    
    [self.navigationController.view setCenter:CGPointMake(160, self.navigationController.view.center.y+44)];
    [_mainScroller setHidden:NO];
    [_searchType setHidden:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleView release];
    [_appIcons release];
    [_mainScroller release];
    [_pageController release];
    [_searchType release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleView:nil];
    [self setAppIcons:nil];
    [self setMainScroller:nil];
    [self setPageController:nil];
    [self setSearchType:nil];
    [super viewDidUnload];
}
@end
