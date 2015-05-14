//
//  MBMessageViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-19.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBMessageViewController.h"

@interface MBMessageViewController ()

@end

@implementation MBMessageViewController

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
    //self.navigationItem.title=@"消息" ;
    self.navigationItem.titleView=_titleView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_sliderBar release];
    [_titleView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSliderBar:nil];
    [self setTitleView:nil];
    [super viewDidUnload];
}
- (IBAction)navigationTabClicked:(id)sender {
    
    UIButton* but=sender;
    
    [self removeSliderTo:but];
    
    
    
    
    
    
    
    
    
    
}

- (void)removeSliderTo:(UIButton*) aButton
{
 
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration =0.25f;
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _sliderBar.layer.position.x, _sliderBar.layer.position.y);
    CGPathAddLineToPoint(path, NULL, aButton.layer.position.x, _sliderBar.layer.position.y); //添加一条路径
    positionAnimation.path = path; //设置移动路径为刚才创建的路径
    CGPathRelease(path);
    positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [_sliderBar.layer addAnimation:positionAnimation forKey:@"sliderMove"];
    [_sliderBar setCenter:CGPointMake(aButton.center.x, _sliderBar.center.y)];
}
@end
