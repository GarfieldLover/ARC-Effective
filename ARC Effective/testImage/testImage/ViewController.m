//
//  ViewController.m
//  testImage
//
//  Created by zhangke on 15/5/28.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* filePath=[[NSBundle mainBundle] pathForResource:@"Snip20150528_1" ofType:@"png"];
    
    //本来只有6M，读出来因为不绘制，只需要知道有多少像素，可能还有描述rgba值的部分
//    NSData* data=[NSData dataWithContentsOfFile:filePath];
    
    
    //width＊height＊4  ， 2880*1800*4/1024/1024=19.775M，那就对了，绘制的内存大小。rgba
    //内部绘制就是用bitmap画的，＊4 用4个字节表示r ， g， b，a值，所以乘4.
    //如果不绘制就是16.3M，初始化值
    UIImage* image=[UIImage imageWithContentsOfFile:filePath];

    UIImageView* imagev=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imagev.image=image;
    //只要绘制图新，就是36.2M
    [self.view addSubview:imagev];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
