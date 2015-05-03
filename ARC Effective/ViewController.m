//
//  ViewController.m
//  ARC Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#include <objc/objc-runtime.h>
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
    
    id __strong obj1=[[NSObject alloc] init];
    
    @autoreleasepool {
        //arc  __autoreleasing 计数＋1
        //weak 不＋1
        id __autoreleasing o=obj1;
//        id __weak o=obj1;

    }
    
    //strong,计数为1，arc，weak直接释放
    self.obj11=[[NSObject alloc] init];

    NSLog(@"%@",self.obj11);
    
}




@end
