//
//  AppDelegate.m
//  TCPSocketClient
//
//  Created by zhangke on 15/5/6.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    int err;
    int fd=socket(AF_INET, SOCK_STREAM  , 0);
    BOOL success=(fd!=-1);
    struct sockaddr_in addr;
    
    if (success) {
        NSLog(@"socket success");
        memset(&addr, 0, sizeof(addr));
        addr.sin_len=sizeof(addr);
        addr.sin_family=AF_INET;

        addr.sin_addr.s_addr=INADDR_ANY;
        err=bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
        success=(err==0);
        
        if (success) {
            //连接地址
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len=sizeof(peeraddr);
            peeraddr.sin_family=AF_INET;
            peeraddr.sin_port=htons(1024);
            //            peeraddr.sin_addr.s_addr=INADDR_ANY;
            peeraddr.sin_addr.s_addr=inet_addr("192.168.1.100");
            //            这个地址是服务器的地址，
            socklen_t addrLen;
            addrLen =sizeof(peeraddr);
            NSLog(@"connecting");
            
            //zk客户端请求连接
            err=connect(fd, (struct sockaddr *)&peeraddr, addrLen);
            success=(err==0);
            
            if (success) {
//                getsockname()函数用于获取一个套接字的名字。它用于一个已捆绑或已连接套接字s，本地地址将被返回。本调用特别适用于如下情况：未调用bind()就调用了connect()，这时唯有getsockname()调用可以获知系统内定的本地地址。
                err =getsockname(fd, (struct sockaddr *)&addr, &addrLen);
                success=(err==0);

                if (success) {
                    NSLog(@"connect success,local address:%s,port:%d",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));
                    
                    //发送/接收数据
                    //面向连接：
                    char buf[1024]="zhangke test ooookkkkk";
                    ssize_t result= send(fd, buf, 1024, 0);
                    if(result==-1){
                        //发送失败，重发啥的。
                    }
                    char exitbuf[1024]="exit";
                    send(fd, exitbuf, 1024, 0);

                }
            }
            else{
                NSLog(@"connect failed");
            }
        }
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
