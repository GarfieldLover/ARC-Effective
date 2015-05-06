//
//  AppDelegate.m
//  UDPSocketServer
//
//  Created by zhangke on 15/5/6.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

/*
 *UDP/IP应用编程接口（API）
 *服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机
 *地址以及一个本地端口号绑定，接收到一个客户端时，服务器显示该客户端的IP地址，并将字串
 *返回给客户端。
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    int ser_sockfd;
    ssize_t len;
    //int addrlen;
    socklen_t addrlen;
    char seraddr[100];
    struct sockaddr_in ser_addr;
    /*建立socket*/
    ser_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(ser_sockfd<0)
    {
        printf("I cannot socket success\n");
    }
    /*填写sockaddr_in 结构*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&ser_addr,addrlen);
    ser_addr.sin_family=AF_INET;
    ser_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    ser_addr.sin_port=htons(1024);
    /*建立地址和套接字的联系，捆绑*/
    if(bind(ser_sockfd,(struct sockaddr *)&ser_addr,addrlen)<0)
    {
        printf("connect");
    }
    
    //server没有这2项
    //listen服务器端侦听客户端的请求
    //accept服务器端等待从编号为Sockid的Socket上接收客户连接请求
    //client 没有connect
    
    while(1)
    {
        bzero(seraddr,sizeof(seraddr));
        //发送/接收数据
        // 面向无连接：
        len=recvfrom(ser_sockfd,seraddr,sizeof(seraddr),0,(struct sockaddr*)&ser_addr,&addrlen);
        /*显示client端的网络地址*/
        printf("receive from %s\n",inet_ntoa(ser_addr.sin_addr));
        /*显示客户端发来的字串*/
        printf("recevce : %s",seraddr);
        /*将字串返回给client端*/
        
        //发送/接收数据
        // 面向无连接：
        sendto(ser_sockfd,seraddr,len,0,(struct sockaddr*)&ser_addr,addrlen);
    }

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
