//
//  MBProfileViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-19.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBProfileViewController.h"

@interface MBProfileViewController ()

@end

@implementation MBProfileViewController

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
    [_popoverBg setImage:[[UIImage imageNamed:@"popover_background.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
    
    
    [_popoverView setCenter:CGPointMake(160, 44+117+17)];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleView release];
    [_titleArrow release];
    [_popoverView release];
    [_popoverBg release];
    [_tableShadow release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleView:nil];
    [self setTitleArrow:nil];
    [self setPopoverView:nil];
    [self setPopoverBg:nil];
    [self setTableShadow:nil];
    [super viewDidUnload];
}
- (IBAction)dropDown:(id)sender {
    //旋转三角尖
    if ([sender isSelected]) {
        [sender setSelected:NO];
        CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setFromValue:[NSNumber numberWithFloat:-M_PI]];
        [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
        [spinAnimation setDelegate:self];
        [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [spinAnimation setDuration:0.5];
        [_titleArrow.layer addAnimation:spinAnimation forKey:@"spin"];
        [_titleArrow.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
    }else{
        [sender setSelected:YES];
        CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
        [spinAnimation setToValue:[NSNumber numberWithDouble:-M_PI]];
        [spinAnimation setDelegate:self];
        [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [spinAnimation setDuration:0.3];
        [_titleArrow.layer addAnimation:spinAnimation forKey:@"spin"];
        [_titleArrow.layer setTransform:CATransform3DMakeRotation(-M_PI, 0, 0, 1)];
    }
    
    //弹出下拉菜单
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



#pragma mark ————uitablveView Delegate——————


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIndentifier=@"findCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (indexPath.section==1) {
        UIImageView *headView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults]objectForKey:@"myUserHead"]]];
        [headView setFrame:CGRectMake(2, 2, 30, 30)];
        
        
        [cell.contentView addSubview:headView];
        [cell.textLabel setText:@""];
    }
    
    //[cell.textLabel setText:@"我的朋友，还没做完"];
    return cell;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"我的资料";
            break;
        case 2:
            return @"最近联系人";
            break;
        default:
            return nil;
            break;
    }
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
    [_tableShadow setHidden:NO];
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
    [_tableShadow setHidden:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

@end
