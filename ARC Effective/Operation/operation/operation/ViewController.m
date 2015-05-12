//
//  ViewController.m
//  operation
//
//  Created by zhangke on 15/5/12.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    http://alvinzhu.me/blog/2013/10/06/iosde-duo-xian-cheng-fen-lei-yu-ying-yong/
    http://hufeng825.github.io/2013/09/14/ios23/
    http://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/
    http://www.cnblogs.com/scorpiozj/archive/2011/05/26/2058167.html
    http://alvinzhu.me/blog/2013/10/06/iosde-duo-xian-cheng-fen-lei-yu-ying-yong/
    http://mobile.51cto.com/hot-403080_1.htm
    http://m.baidu.com/from=1086k/bd_page_type=1/ssid=0/uid=0/pu=usm%400%2Csz%401320_2002%2Cta%40iphone_1_8.3_2_5.8/baiduid=EA9B3496A54DAD1827406790D0A6913B/w=0_10_ios+%E5%A4%9A%E7%BA%BF%E7%A8%8B/t=iphone/l=3/tc?ref=www_iphone&lid=13080308476782563025&order=2&vit=osres&tj=www_normal_2_0_10_title&m=8&srd=1&cltj=cloud_title&dict=21&nt=wnor&title=iOS%E4%B8%AD%E7%9A%84%E5%A4%9A%E7%BA%BF%E7%A8%8B-%E5%82%B2%E9%A3%8E%E5%87%8C%E5%AF%92%E7%9A%84%E4%B8%AA%E4%BA%BA%E7%A9%BA%E9%97%B4-%E5%BC%80%E6%BA%90%E4%B8%AD%E5%9B%BD%E7%A4%BE%E5%8C%BA&sec=3412&di=b3e9fd39c24ca75e&bdenc=1&nsrc=IlPT2AEptyoA_yixCFOxXnANedT62v3IGwvPKjtX_j35nI3tfeSaUbBbXTXq2Sm5IUn7wyPQpxsGwHSi0_
   GCD  优点：不需要关心线程管理，数据同步的事情，可以把精力放在自己需要执行的操作上。

//    提供了在 GCD 中不那么容易复制的有用特性。
//    可以很方便的取消一个NSOperation的执行
//    可以更容易的添加任务的依赖关系
//    提供了任务的状态：isExecuteing, isFinished.
    
    
    
    
//    （一）NSThread
//    （二）Cocoa NSOperation
//    （三）GCD（全称：Grand Central Dispatch）
    
    [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];

    [self performSelectorInBackground:@selector(download) withObject:nil];
    
    NSThread* xxx= [[NSThread alloc] initWithTarget:self selector:@selector(download) object:nil];
    [xxx start];
    
    [self performSelectorInBackground:@selector(download) withObject:nil];

    //程序员管理线程
    
    NSLog(@"xxxx");
    
    
    
    //NSOperationQueue看作一个线程池，可往线程池中添加操作（NSOperation）到队列中
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:1];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download) object:nil];
    [queue addOperation:operation];
   
    
    NSBlockOperation* blockoper=[NSBlockOperation blockOperationWithBlock:^{
        [self download];
    }];
    [blockoper addDependency:operation];
    
    [queue addOperation:blockoper];
    
//    [queue cancelAllOperations];
    
    
    //线程在等待block执行完成，block在等待追加到线程，发生死锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //请求数据
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i2.sinaimg.cn/ty/nba/2015-05-12/U4345P6T12D7605115F44DT20150512130255.jpg"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSLog(@"%@",data);
            
        });
        
    });
    
    
    dispatch_queue_t dispatchqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatchqueue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
    });
    dispatch_group_async(group, dispatchqueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group2");
    });
    dispatch_group_async(group, dispatchqueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
    });
    
    dispatch_queue_t gcdtesqueue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(gcdtesqueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(gcdtesqueue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    dispatch_barrier_async(gcdtesqueue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
        
    });
    dispatch_async(gcdtesqueue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");   
    });
    
}

-(void)download
{
    @synchronized(self)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i2.sinaimg.cn/ty/nba/2015-05-12/U4345P6T12D7605115F44DT20150512130255.jpg"]];
        NSLog(@"%@,%@",[NSThread mainThread], [NSThread currentThread]);
        [self performSelectorOnMainThread:@selector(reload:) withObject:data waitUntilDone:YES];

    }

    //线程间通信 ,
    
}

-(void)reload:(NSObject*)object
{

}



@end
