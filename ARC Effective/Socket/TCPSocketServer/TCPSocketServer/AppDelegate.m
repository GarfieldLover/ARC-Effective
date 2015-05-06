//
//  AppDelegate.m
//  TCPSocketServer
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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    
    //AF = Address Family，意思就是 AF_INET 主要是用于互联网地址，Ipv4网络协议；
    //SOCK_STREAM提供面向连接的稳定数据传输，即TCP协议
    int err;
    
    //创建套接字
    int fd= socket(AF_INET, SOCK_STREAM, 0);
    
    BOOL success=(fd!=-1);
    if(success){
        NSLog(@"socket success");
        
        //此数据结构用做bind、connect、recvfrom、sendto等函数的参数，指明地址信息。
        struct sockaddr_in addr;
//        __uint8_t	sin_len;   长度
//        sa_family_t	sin_family;  地址族
//        in_port_t	sin_port;   端口
//        struct	in_addr sin_addr;   地址
//        char		sin_zero[8];
        
        memset(&addr, 0, sizeof(addr));
        
        addr.sin_len=sizeof(addr);
        
        addr.sin_family=AF_INET;
        
        addr.sin_port=htons(1024);
        
        addr.sin_addr.s_addr=INADDR_ANY;
        //建立地址和套接字的联系，捆绑
        err=bind(fd, (const struct sockaddr*)&addr, sizeof(addr));
        
        success=(err==0);
        
        if(success){
            NSLog(@"bind success");
            //服务器端侦听客户端的请求
            err=listen(fd, 5);
            
            success=(err==0);
            
            if(success){
                NSLog(@"listen success");
                
                while (true) {
                    struct sockaddr_in peeraddr;
                    
                    int peerfd;
                    
                    socklen_t addrLen;
                    
                    addrLen=sizeof(peeraddr);
                    
                    NSLog(@"prepare accept");
                    //服务器端等待从编号为Sockid的Socket上接收客户连接请求
                    peerfd=accept(fd, (struct sockaddr*)&peeraddr, &addrLen);
                    //阻塞，所以才要用gcd
                    success=(peerfd!=-1);
                    
                    NSLog(@"prepare accept success");

                    if(success){
                        NSLog(@"accept success,add:%s , port:%d",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
                        char buf[1024];
                        ssize_t count;
                        size_t len=sizeof(buf);
                        
                        do{
                            //发送/接收数据
                            //面向连接：
                            count=recv(peerfd, buf, len, 0);
                            NSString* string=[NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                            NSLog(@"recv____%@",string);
                        }while (strcmp(buf, "exit")!=0);
                        
                    }
                    //释放套接字
                    close(peerfd);
                }
            }
        }
    }

    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
