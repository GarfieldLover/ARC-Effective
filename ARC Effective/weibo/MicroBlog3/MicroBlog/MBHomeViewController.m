//
//  MBHomeViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-15.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBHomeViewController.h"
#import "MBMicroBlogCell.h"
#import "MBComposeViewController.h"
#import "MBDBManager.h"
#import "MBTweetDetailViewController.h"

@interface MBHomeViewController ()

@end

@implementation MBHomeViewController

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
    currentPageNum=1;
    
    NSLog(@"当前登陆用户的userId为%@",[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_ID] );
    //currentTweetArray=[[NSMutableArray alloc]initWithObjects:@"北风网5周年庆典，回馈新老客户,48小时课程疯抢，精品课程限量、限时抢购，全面3-5折，买到就是赚到。● 活动对象:所有北风网用户",@"其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！",@"其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！", @"其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！",@"其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！",@"其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！其实今天我想要更交流。再回来！拜拜宁波的朋友们！再见！我爱你们！", nil];
    currentTweetArray=[[[MBDBManager defaultManager]getNewestTweetWithPageSize:10 andPageIndex:currentPageNum andSortType:-1]retain];
    
    
    [self.navigationItem setTitleView:_titleView];
    [_popoverBg setImage:[[UIImage imageNamed:@"popover_background.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
    
    
    [_popoverView setCenter:CGPointMake(160, 44+117+17)];
    //[_userName setText:[self randChineseWithLenth:4]];
    [_floatingText.layer setCornerRadius:20.0];
    
    
    
    
    //下拉刷新初始化
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _weiboTable.bounds.size.height, self.view.frame.size.width, _weiboTable.bounds.size.height)];
		view.delegate = self;
		[_weiboTable addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    //初始化最后刷新时间为当前页面加载完毕
    [_refreshHeaderView refreshLastUpdatedDate];

    
    // Do any additional setup after loading the view from its nib.
//    CATransform3D trans=CATransform3DIdentity;
//    
//    
//    
//    trans.m34 = 0.007983; // 透视效果
//    [self.view.layer setTransform:CATransform3DRotate(trans,(M_PI/180*40), 0.120984, 1, 0)];
//    

    
    
}



#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self fetchSomeData];
    
    //此方法  将在高仿微博第3期实现
    
    
	_reloading = YES;
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [_actIndicator stopAnimating];
    [_realRefreshButton setHidden:NO];
    
    //刷新结束弹出浮动层动画
    CABasicAnimation *floatDown=[CABasicAnimation animationWithKeyPath:@"position"];
    [floatDown setFromValue:[NSValue valueWithCGPoint:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y)]];
    [floatDown setToValue:[NSValue valueWithCGPoint:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y+_floatingText.frame.size.height)]];
    [floatDown setDuration:1.0];
    [floatDown setDelegate:self];
    [floatDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_floatingText.layer addAnimation:floatDown forKey:nil];
    
    
    [_floatingText.layer setPosition:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y+_floatingText.frame.size.height)];
    
    [self performSelector:@selector(resetFloatingText) withObject:nil afterDelay:3.0];
    
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_weiboTable];
	    
}


- (void)resetFloatingText
{
    //刷新结束弹出浮动层动画消失
    CABasicAnimation *floatDown=[CABasicAnimation animationWithKeyPath:@"position"];
    [floatDown setFromValue:[NSValue valueWithCGPoint:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y)]];
    [floatDown setToValue:[NSValue valueWithCGPoint:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y-_floatingText.frame.size.height)]];
    [floatDown setDuration:1.0];
    [floatDown setDelegate:self];
    [floatDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_floatingText.layer addAnimation:floatDown forKey:nil];
    
    [_floatingText.layer setPosition:CGPointMake(_floatingText.layer.position.x, _floatingText.layer.position.y-_floatingText.frame.size.height)];
}


//- (IBAction)startRefresh:(id)sender {
//    [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
//    
//}
////移出浮动层
//
//-(void)removeActFloat
//{
//    
//    CATransition *animation = [CATransition  animation];
//    animation.delegate = self;
//    animation.duration = 0.8;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromTop;
//    [_actFloatingView setAlpha:0.0f];
//    [_actFloatingView.layer addAnimation:animation forKey:@"pushOut"];
//    [_actFloatingView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.8];
//    
//    
//}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}



- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [_actIndicator startAnimating];
    [_realRefreshButton setHidden:YES];
    
    
    
    
    
       
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_titleView release];
    [_popoverBg release];
    [_popoverView release];
    [_weiboTable release];
    [_actIndicator release];
    [_realRefreshButton release];
    [_userName release];
    [_floatingText release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleView:nil];
    [self setPopoverBg:nil];
    [self setPopoverView:nil];
    [self setWeiboTable:nil];
    [self setActIndicator:nil];
    [self setRealRefreshButton:nil];
    [self setUserName:nil];
    [self setFloatingText:nil];
    [super viewDidUnload];
}
- (IBAction)dropDown:(id)sender {
    if (_popoverView.superview == self.navigationController.view) {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [_popoverView setAlpha:0.0f];
        [_popoverView.layer addAnimation:animation forKey:@"DropDown"];
        [_popoverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        
        
        
    }else
    {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [_popoverView setAlpha:1.0f];
        [_popoverView.layer addAnimation:animation forKey:@"DropDown"];
        //[_timePicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        
        
        
        
        [self.navigationController.view addSubview:_popoverView];
    }
    
    
}

- (IBAction)refreshTable:(id)sender {
    
    [_weiboTable setContentOffset:CGPointMake(0, -65.0f) animated:YES];
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    
    
    [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
    
}

- (IBAction)composeATweet:(id)sender {
    MBComposeViewController *composeView=[[[MBComposeViewController alloc]init]autorelease];
    
    CATransition *pushAnim=[[CATransition alloc]init];
    [pushAnim setType:kCATransitionPush];
    [pushAnim setSubtype:kCATransitionFromTop];
    [pushAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [pushAnim setDuration:0.25];
    [pushAnim setDelegate:self];
    
    [self.navigationController.view.layer addAnimation:pushAnim forKey:nil];
    
    
    [composeView setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:composeView animated:NO];
    
    
}

#pragma mark ———————tablview的delegates—————————


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentTweetArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"WBCell";

    

    [_weiboTable registerNib:[UINib nibWithNibName:@"MBMicroBlogCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];

    
    MBMicroBlogCell *weiboCell = [_weiboTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (weiboCell == nil) {
        weiboCell = [[[MBMicroBlogCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    [weiboCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *string=[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"tweetContent"];
    CGRect orginFrame=weiboCell.tweetContent.frame;
    CGSize textSize=[string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(orginFrame.size.width, 190) lineBreakMode:NSLineBreakByCharWrapping];
    [weiboCell.tweetContent setFrame:CGRectMake(orginFrame.origin.x, orginFrame.origin.y, orginFrame.size.width,textSize.height )];
    [weiboCell.tweetContent setText:[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"tweetContent"]];
    
    [weiboCell.userHead setImage:[UIImage imageWithContentsOfFile:[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"userHead"]]];
    NSNumber *userId;
    userId=[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"ownerId"];
    if (userId==[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_ID]) {
        [weiboCell setTweetType:TweetTypeMine];
        
        [weiboCell.userNickname setText:@"我"];
    }else {
        [weiboCell setTweetType:TweetTypeNormal];
        [weiboCell.userNickname setText:[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"userNickname"]];
    }
    
    
    
    
    [weiboCell.tweetAttachmentImage setCenter:CGPointMake(weiboCell.tweetAttachmentImage.center.x, weiboCell.tweetAttachmentImage.center.y+weiboCell.tweetContent.frame.size.height-orginFrame.size.height)];
    
    
    
    
    
   
    
    return weiboCell;
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string=[[currentTweetArray objectAtIndex:indexPath.row]objectForKey:@"tweetContent"];
    CGSize textSize=[string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(241, 190) lineBreakMode:NSLineBreakByCharWrapping];
    
    
    return textSize.height+192;
}



-(void)fetchSomeData
{
    currentTweetArray=[[[MBDBManager defaultManager]getNewestTweetWithPageSize:10 andPageIndex:currentPageNum andSortType:-1]retain];
    
    [_weiboTable reloadData];
    return;
}


-(NSString*)randChineseWithLenth:(int)len{
    NSString *result =@"";
    for (int i = 0; i <len; i++) {
        
        NSString *str = @"";
        int hightPos, lowPos; // 定义高低位
        

       // srand((unsigned)time(0));
        hightPos = (176 + fabs(fmod(arc4random(), 39)));//获取高位值
        
        lowPos = (161 + fabs(fmod(arc4random(), 93)));//获取低位值
        
        Byte b[2];
        
        b[0] = ((Byte)hightPos);
        
        b[1] = ((Byte)lowPos);

        str=[[NSString alloc]initWithBytes:b length:2 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        if (str!=nil)
            result=[result stringByAppendingString:str];
        [str release];
    }
    
    
    return result;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_userName setText:[[NSUserDefaults standardUserDefaults]objectForKey:MY_USER_NICKNAME]];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBTweetDetailViewController *tweetDetail=[[[MBTweetDetailViewController alloc]init]autorelease];
    [tweetDetail setHidesBottomBarWhenPushed:YES];
    
    //截图
    UIGraphicsBeginImageContext(CGSizeMake(320,self.tabBarController.view.bounds.size.height));

    [self.tabBarController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    //以png格式返回指定图片的数据
    //NSData *imgData = UIImageJPEGRepresentation(aImage, 1.0);
    
    CGRect rect =self.tabBarController.view.bounds;
    
    UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([aImage CGImage], rect)];
    [[getAppDelegate() getWindowBg] setImage:res ];

    
    
    
    
    [self.navigationController pushViewController:tweetDetail animated:YES];
   
}


@end
