//
//  AppDelegate.m
//  UDPSocketClient
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

/*
 *UDP/IP应用编程接口（API）
 *客户端的工作流程：首先调用socket函数创建一个Socket，填写服务器地址及端口号，
 *从标准输入设备中取得字符串，将字符串传送给服务器端，并接收服务器端返回的字
 *符串。最后关闭该socket。
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    int cli_sockfd;
    ssize_t len;
    socklen_t addrlen;
    char seraddr[14]="192.168.1.100";
    struct sockaddr_in cli_addr;

    /* 建立socket*/
    cli_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(cli_sockfd<0)
    {
        printf("I cannot socket success\n");
        return 1;
    }
    
    /* 填写sockaddr_in*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&cli_addr,addrlen);
    cli_addr.sin_family=AF_INET;
    cli_addr.sin_addr.s_addr=inet_addr(seraddr);
    //cli_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    cli_addr.sin_port=htons(1024);
    
    //将内存（字符串）前n个字节清零
    //bzero(buffer,sizeof(buffer));
    
    char buffer[256]="zhangke test ooookkkkk";
    
    /* 从标准输入设备取得字符串*/
    //len=read(STDIN_FILENO,buffer,sizeof(buffer));
    len=sizeof(buffer);
    
    /* 将字符串传送给server端*/
    ssize_t result= sendto(cli_sockfd,buffer,len,0,(struct sockaddr*)&cli_addr,addrlen);
    //zk,好像也有发送失败,应该是内部不负责重发
    
    
    /* 接收server端返回的字符串*/
    len=recvfrom(cli_sockfd,buffer,sizeof(buffer),0,(struct sockaddr*)&cli_addr,&addrlen);
    
    //printf("receive from %s\n",inet_ntoa(cli_addr.sin_addr));
    printf("receive: %s,%ld",buffer,len);
    
    close(cli_sockfd);
    
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
