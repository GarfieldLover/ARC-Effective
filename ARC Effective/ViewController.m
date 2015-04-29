//
//  ViewController.m
//  ARC Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id obj=[[NSObject alloc] init];
    id temp=obj;
    id tempxx=temp;

    //__strong修饰符，引用技术加1
    NSLog(@"1 %p",obj);
    NSLog(@"2 %p",obj);
    NSLog(@"3 %p",temp);
    NSLog(@"4 %p",temp);

}




@end
