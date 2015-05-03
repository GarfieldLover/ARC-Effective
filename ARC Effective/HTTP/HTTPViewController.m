//
//  HTTPViewController.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/5/3.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "HTTPViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface HTTPViewController ()

@end

@implementation HTTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL* url=[NSURL URLWithString:@"http://img1.gtimg.com/sports/pics/hv1/172/199/1832/119176717.jpg"];
    [self.imageView  setImageWithURL:url];
    
    //单独对象，从来没有单例请求的，各管各请求的
    AFHTTPRequestOperationManager* httpMa=[AFHTTPRequestOperationManager manager];
    httpMa.responseSerializer = [AFHTTPResponseSerializer serializer];
    //默认jsonresponse 只认识 @"application/json", @"text/json", @"text/javascript",不支持test／html，报错
    //，_acceptableContentTypes 如果设置为nil，不清楚为什么
    [httpMa GET:@"http://sports.qq.com/a/20150503/025309.htm" parameters:nil success:^(AFHTTPRequestOperation* op , id response){
        NSLog(@"%@",response);
        
    } failure:^(AFHTTPRequestOperation* op , NSError* error){
    
        
    }];
    
    
//    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//    [runLoop run];
    
    
    
    //创建RequestOperationManager，实例的，设置请求和响应Serializer ，get。post。put。delete等，创建
    一个operation，内部创建nsrequest，NSURLConnection ，urlconnection start请求，返回结果各种block
    NSURLConnectionDelegate 处理结果，然后Block回调
    
    AFURLConnectionOperation
    - (void)start {
    - (void)operationDidStart {
       [self.connection start];
}



@end
