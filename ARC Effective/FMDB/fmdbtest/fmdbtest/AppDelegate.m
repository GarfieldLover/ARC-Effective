//
//  AppDelegate.m
//  fmdbtest
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIImage* image= [UIImage imageNamed:@"A3DFC8D23566E7949F4CC392143A5469.png"];
    NSData* data=UIImageJPEGRepresentation(image, 1.0);
    
    dispatch_queue_t conqueue=dispatch_queue_create("xxxxxxxx", DISPATCH_QUEUE_CONCURRENT);
    
    //高并发，是在for循环内读吗。如果是那就是顺序执行啊。
    //应该不是，这就不是并发了，
    
    //要么就串行，要么就栅栏
//    dispatch_async(conqueue, ^{
//        
//        for(int i=0;i<100000;i++){
//            NSString* string=[NSString stringWithFormat:@"Documents/test%d.png",i];
//            NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:string];
//            [data writeToFile:path atomically:YES];
//            NSLog(@"%@",[NSThread currentThread]);
//            
//            
//        }
//        
//
//    });
    
    //磁盘和内存都会爆增，大量分配线程去读，崩溃
    //GCD一直去开辟线程，可能是512，就会暴涨
    
    //－－－》 io放到串行队列里，同时访问数降低，
    //如果我们创建一个custom queue然后将所有的文件读写任务放入这个队列，磁盘资源的同时访问数会大大降低
    
    //限制数量，内存问题就解决了，
    //——》 最简单的方法就是使用信号量来限制同时执行的任务数量。这样内存就不吃紧了
    
    //－总的来说就是限制同时执行任务数量，磁盘和内存的考虑
    
    
    //    find paths  ------>  read  ----------->  process
    //    ...
    //    write <-----------  process
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t ioQueue = dispatch_queue_create("com.dreamingwish.imagegcd.io", NULL);
    NSUInteger cpuCount = [[NSProcessInfo processInfo] processorCount];
    dispatch_semaphore_t jobSemaphore = dispatch_semaphore_create(cpuCount * 2);
    
    
    for(int i=0;i<100000;i++){
        dispatch_semaphore_wait(jobSemaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_group_async(group, ioQueue, ^{
            NSString* string=[NSString stringWithFormat:@"Documents/test%d.png",i];
            NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:string];
            
//            NSLog(@"out  %@",[NSThread currentThread]);
            
            NSData *data = [NSData dataWithContentsOfFile: fullPath];
            
            dispatch_group_async(group, conqueue, ^{
//                NSLog(@"process  %@",[NSThread currentThread]);

                dispatch_group_async(group, ioQueue, ^{
//                    NSLog(@"int  %@",[NSThread currentThread]);
                    //处理完一个才会处理里边的
                    [data writeToFile:fullPath atomically:YES];
                    dispatch_semaphore_signal(jobSemaphore);

                });
                
            });
            
        });
        

    }
    

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
