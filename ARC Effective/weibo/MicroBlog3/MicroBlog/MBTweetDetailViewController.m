//
//  MBTweetDetailViewController.m
//  MicroBlog
//
//  Created by Reese on 13-5-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBTweetDetailViewController.h"


@interface MBTweetDetailViewController ()
{
    float sliderDistance;
    float firstX;
    float firstY;
}

@end




@implementation MBTweetDetailViewController

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
    
    // Do any additional setup after loading the view from its nib.
    [getAppDelegate() hideTabbar];
    [super viewDidLoad];
    [self initSectionHeader];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc]initWithCustomView:_backButton]autorelease]];
    [self.navigationItem setTitleView:_titleView];
    retweetsArray=[[NSMutableArray alloc]init];
    commentsArray=[[NSMutableArray alloc]init];
    
    currentContentType=kTweetDetailContentTypeComments;

    
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userCell release];
    [_contentCell release];
    [_sectionHeaderView release];
    [_fowardButton release];
    [_commentButton release];
    [_sliderImage release];
    [_mainTable release];
    [_titleView release];
    [_backButton release];
    [_emptyCommentsCell release];
    [_emptyRetweetCell release];
    [super dealloc];
}



#pragma mark ———————tablview的delegates—————————


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        switch (currentContentType) {
            case kTweetDetailContentTypeComments:
                return commentsArray.count==0?1:commentsArray.count;
                break;
            case kTweetDetailContentTypeFowards:
                return retweetsArray.count==0?1:retweetsArray.count;
                break;
            default:
                break;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return _userCell;
        }
        
        
        if (indexPath.row==1) {
            return _contentCell;
        }
    }
    
    if (currentContentType==kTweetDetailContentTypeComments) {
        if (commentsArray.count==0) {
            return _emptyCommentsCell;
        }
    }else
    {
        if (retweetsArray.count==0) {
            return _emptyRetweetCell;
        }
    }
    
    static NSString *CellIdentifier=@"WBCell";
    
    
    
        
    UITableViewCell *weiboCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (weiboCell == nil) {
        weiboCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    //[weiboCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [weiboCell.textLabel setText:currentContentType==kTweetDetailContentTypeComments?@"这是一条评论内容":@"这是一条转发内容"];
    return weiboCell;
    
    
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return _sectionHeaderView;
        
    }
    else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 35;
    }else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 76;
        }
        
        
        if (indexPath.row==1) {
            return 144;
        }
    }
    
    if (currentContentType==kTweetDetailContentTypeComments) {
        if (commentsArray.count==0) {
            return 270;
        }
    }else
    {
        if (retweetsArray.count==0) {
            return 270;
        }
    }

    
    
    return 45;
}



-(void)initSectionHeader
{
    //[_commentButton setSelected:YES];
   // [_fowardButton setSelected:NO];
    sliderDistance=_commentButton.center.x-_fowardButton.center.x ;
    [_sliderImage.layer setPosition:CGPointMake(_sliderImage.layer.position.x+sliderDistance, _sliderImage.layer.position.y)];
    
    
}


- (IBAction)checkFowards:(id)sender {
    if ([_fowardButton isSelected]) {
        return;
    }
    else{
    [_fowardButton setSelected:YES];
    [_commentButton setSelected:NO];
    
        
        CABasicAnimation *moveSlider=[CABasicAnimation animationWithKeyPath:@"position"];
        [moveSlider setFromValue:[NSValue valueWithCGPoint:CGPointMake(_sliderImage.layer.position.x, _sliderImage.layer.position.y)]];
        [moveSlider setToValue:[NSValue valueWithCGPoint:CGPointMake(_sliderImage.layer.position.x-sliderDistance, _sliderImage.layer.position.y)]];
        [moveSlider setDuration:0.2f];
        [moveSlider setDelegate:self];
        [moveSlider setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_sliderImage.layer addAnimation:moveSlider forKey:nil];
        
        
        [_sliderImage.layer setPosition:CGPointMake(_sliderImage.layer.position.x-sliderDistance, _sliderImage.layer.position.y)];
        [self setTableContent:kTweetDetailContentTypeFowards];
        
    }
    
    
    

}



- (IBAction)checkComments:(id)sender {
    if ([_commentButton isSelected]) {
        return;
    }
    else{
        [_fowardButton setSelected:NO];
        [_commentButton setSelected:YES];
        
        
        CABasicAnimation *moveSlider=[CABasicAnimation animationWithKeyPath:@"position"];
        [moveSlider setFromValue:[NSValue valueWithCGPoint:CGPointMake(_sliderImage.layer.position.x, _sliderImage.layer.position.y)]];
        [moveSlider setToValue:[NSValue valueWithCGPoint:CGPointMake(_sliderImage.layer.position.x+sliderDistance, _sliderImage.layer.position.y)]];
        [moveSlider setDuration:0.2f];
        [moveSlider setDelegate:self];
        [moveSlider setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_sliderImage.layer addAnimation:moveSlider forKey:nil];
        
        
        [_sliderImage.layer setPosition:CGPointMake(_sliderImage.layer.position.x+sliderDistance, _sliderImage.layer.position.y)];
        [self setTableContent:kTweetDetailContentTypeComments];
        
    }
    
    
}

-(void)setTableContent:(MBTweetDetailContentType) aType
{
    switch (aType) {
        case kTweetDetailContentTypeFowards:
            //更改table的数据源为该微博的所有转发内容
            currentContentType=kTweetDetailContentTypeFowards;
            [_mainTable reloadData];
            
            break;
        case kTweetDetailContentTypeComments:
            //更改table的数据源为该微博的所有评论内容
            currentContentType=kTweetDetailContentTypeComments;
            [_mainTable reloadData];
            break;
        default:
            break;
    }
    
    
    return;
}

- (IBAction)navBack:(id)sender {
    [getAppDelegate() showTabbarWithAnimation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setEmptyCommentsCell:nil];
    [self setEmptyRetweetCell:nil];
    [super viewDidUnload];
}





-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    static float fisrtX;
    
    CGPoint touchPoint=[gestureRecognizer locationInView:self.view];
    fisrtX=touchPoint.x;
    NSLog(@"第一次触摸的位置:%f",fisrtX);
    [gestureRecognizer setCancelsTouchesInView:NO];
    
    return YES;
    
    
}


- (IBAction)rightSwipe:(UIGestureRecognizer*)gesture
{
    static float currentX=320.0;
    static float fisrtX;
    
    if (gesture.state==UIGestureRecognizerStateEnded) {
        NSLog(@"touchEnd");
        
        float currentCenter=self.navigationController.view.center.x;
        
        
        
        
        
        if (currentCenter>320) {
            
            [self performSelector:@selector(popBack) withObject:nil afterDelay:0.2f];
            
            CABasicAnimation *posAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [posAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y)]];
            [posAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(160+320, self.navigationController.view.center.y)]];
            [posAnim setDelegate:self];
            [posAnim setDuration:0.2f];
            [posAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [self.navigationController.view.layer addAnimation:posAnim forKey:nil];
            
            return;
            
        }

        CABasicAnimation *posAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [posAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y)]];
        [posAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.navigationController.view.center.y)]];
        [posAnim setDelegate:self];
        [posAnim setDuration:0.2f];
        [posAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.navigationController.view.layer addAnimation:posAnim forKey:nil];
        [self.navigationController.view setCenter:CGPointMake(160, self.navigationController.view.center.y)];

        currentX=320.0;
        return;
    }
    
    
   
    CGPoint touchPoint=[gesture locationInView:self.view];
    if (currentX==320.0) {
        fisrtX=touchPoint.x;
    }
   
    
    float panDist=touchPoint.x-fisrtX;
    if (panDist>=0) {
        NSLog(@"在往右边滑");
        
        
    }
    else {
        NSLog(@"在往左边滑");
    }
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.navigationController.view setCenter:CGPointMake(self.navigationController.view.center.x+panDist, self.navigationController.view.center.y)];
    [self scale:[getAppDelegate() getWindowBg]  level:(self.navigationController.view.center.x-160)*0.03/160
     ];
    
    [[getAppDelegate() getWindowShadow]setAlpha:0.6-(self.navigationController.view.center.x-160)*0.3/160];
    [CATransaction commit];
    
    currentX=touchPoint.x;
   // NSLog(@"触摸点的坐标:%f,%f",touchPoint.x,touchPoint.y);
    
    
}


-(void)popBack
{
    [getAppDelegate() showTabbarWithAnimation:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)scale:(UIImageView*)aImageView level:(float)aLevel
{
    [aImageView.layer setTransform:CATransform3DScale(CATransform3DIdentity, 0.95+aLevel, 0.95+aLevel, 1.0)];
    NSLog(@"当前缩放：%f",1.0-aLevel);
}
@end
