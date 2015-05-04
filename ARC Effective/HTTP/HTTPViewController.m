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
    //一个operation，内部创建nsrequest，NSURLConnection ，urlconnection start请求，返回结果各种block
    //NSURLConnectionDelegate 处理结果，然后Block回调
    
    //AFURLConnectionOperation
    //- (void)start {
    //- (void)operationDidStart {
    //  [self.connection start];
    
    
    
    //OSI分层
    
    
    //TCP，传输控制协议
    //三次握手策略，建立连接
    //1.发送端－》syn（synchronize）－》接收端
    //2.接收端－》syn/ack（acknowledgement）－》发送端
    //3.发送端－》ack－》接收端
    
    //IP,网际协议
    //把各种数据包传送给对方
    //IP地址和MAC地址
    
    //SSL，安全套接层
    
    
    //TSL，传输层安全协议
    
    
    //ARP，地址解析协议
    //IP地址解析为mac地址（媒介控制地址），边转发边解析，在路由控制表里有ip对应mac表
    
    //DNS，域名服务
    //提供域名到IP地址的解析服务
    
    
    //HTTP，超文本传输协议
    //流程：访问baidu.com
    //1.DNS解析为IP地址
    //2.生成HTTP请求报文
    //3.TCP将HTTP请求报文分割成报文段，并添加header
    //4.IP协议搜索对方IP地址，边中转边传输，ARP
    //5.接收方收到TCP的报文后重组请求报文
    //6.web应用处理HTTP请求内容
    //7.请求结果按照同样方式返回给用户
    
    //URL，统一资源定位符 ，协议名＋服务器地址＋端口号＋文件路径＋标示符
    
    //requestMessage，请求报文，请求方法＋URL＋协议版本＋header＋body
    //responseMessage，响应报文，版本＋状态码＋状态码原因＋header＋body
    
    //不保存状态，Cookie管理用户状态，响应返回set－Cookie，请求传Cookie
    
    //HTTP方法
    //GET：获取资源
    //POST：传输数据
    //PUT：传输文件，像ftp一样上传文件，不带验证机制，任何人都可以上传，存在安全性问题，很少用
    //HEAD：获得responseHeader
    //DELETE：删除文件，同PUT，一样不安全
    //OPTIONS：询问支持的方法，allow：GET，POST
    //TRACE：追踪路径，代理服务器的操作，很少用
    //CONNECT：用隧道协议连接代理，SSL，TSL，加密后传输
    
    //持久连接
    //HTTP 1.0 默认为短链接，建立TCP连接－》HTTP请求响应－》断开TCP连接，增加通信开销
    //HTTP 1.1 默认 ，keep－alive，减少了重复建立和断开造成的开销和负载，使响应速度提高。管线化，不用等待响应就能发送下一个请求
    
    
    //Message，报文
    //请求行（状态行）（GET ，HTTP 1.0，200 OK等），各种header ，\n\r ，body
    //content-type: multipart/form-data 多部分对象集合，表单文件上传。
    //range：500-700 ，范围请求
    //accept：返回合适内容
    
}



@end
