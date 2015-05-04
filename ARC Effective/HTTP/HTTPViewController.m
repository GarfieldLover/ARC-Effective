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
    //request.HTTPMethod GET
    
//    po request.allHTTPHeaderFields
//    {
//        "Accept-Language" = "en;q=1, fr;q=0.9, de;q=0.8, zh-Hans;q=0.7, zh-Hant;q=0.6, ja;q=0.5";
//        "User-Agent" = "ARC Effective/1.0 (iPhone Simulator; iOS 8.2; Scale/3.00)";
//    }
    
    
    //浏览器的原生 form 表单 URL-Form-Encoded Request
    //们使用表单上传文件时，multipart/form-data
    //application/json
    //test/html
    
    //zk文件的key放在了url里？查看数码照片等.
    NSDictionary *parameters = @{@"foo": @"bar"};
    [httpMa POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    status code: 404, headers {
//        "Cache-Control" = "max-age=604800";
//        "Content-Length" = 452;
//        "Content-Type" = "text/html";
//        Date = "Mon, 04 May 2015 15:25:39 GMT";
//        Expires = "Mon, 11 May 2015 15:25:39 GMT";
//        Server = "EOS (lax004/2821)";
    
    //下载任务，后台
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    //上传任务
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
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
    
    
    
#if 0
    
    //mrc
    //－》startAsynchronous，默认开启了sharedQueue，MaxConcurrentOperationCount 4，
    //[networkQueue go]; 自己创建的queue暂停为no，
    //－》Queue只是循环载体
    //setSuspended，暂停，设为NO，开始请求
    //－》设delegate返回结果，也有block了
    //－》startSynchronous，main函数，主线成处理，cfnetwork，
    //可以直接存储
    //－》内部用cfnetwork实现，最大区别
    //－》request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (CFStringRef)[self requestMethod], (CFURLRef)[self url], [self useHTTPVersionOne] ? kCFHTTPVersion1_0 : kCFHTTPVersion1_1);
    
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    
    //Customise our user agent, for no real reason
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    
    request.delegate=self;
    
    [request startAsynchronous];
    
    
    ASINetworkQueue* networkQueue = [[ASINetworkQueue alloc] init];
    networkQueue.delegate=self;
    networkQueue.requestDidFinishSelector=@selector(networkQueueFinish:);
    [networkQueue addOperation:request];
    [networkQueue go];
#endif
    

    
    
    
    
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
    
    //HTTP状态码
    //1xx，请求正在处理
    //2xx，正常处理完毕，200OK，请求被正常处理，204NoContent，请求成功但没有资源返回，206，响应范围请求
    //3xx，重定向，301永久性重定向，以后使用新的URL，302临时重定向，本次使用新URL，303seeother，资源存在另一个URL，304不符合条件，资源找到但不符合条件，
    //4xx，客户端错误，400坏请求，报文存在语法错误，401没有被认证，403拒绝访问，没有权限反问该资源，404URL的资源未找到
    //5xx，服务器错误，500内部错误，存在bug，503服务器超负荷或停机
    
    //协作web服务器
    //单台虚拟主机实现多个域名
    //转发程序服务器：代理（转发请求响应），网关（转发＋响应，自身就是服务器），隧道（SSL加密进行通信，确保进行安全通信）
    //缓存服务器，判断缓存实效请求
    
    //HTTP header
    //请求行，请求header，响应header，通用header，实体header
    //通用：Cache－Control，控制缓存，Date，创建日期，via，代理服务器
    //请求：Accept，可处理的媒体类型，Accept－Encoding，编码，Accept－Language，语言，Authorization，认证，Host，服务器，Range，范围，User－Agent，客户端信息
    //响应：Accept－Ranges，范围请求，Location，重定向URL，Retry－After，重试
    //实体：Allow，支持的HTTP方法，Content－Encoding，编码方式，Content－Length，body大小，Content－MD5，md5编码，Content－range，范围，content－type，媒体类型
    //keep－alive，set－Cookie，cookie，
    
    //HTTPS
    //http＋加密＋认证＋完整性
    //公钥加密，私钥解密，针对于敏感信息，密码，支付交易，
    //认证，证书＋密码，cookie管理状态
    //sql注入，破解密码，cookie修改，海量请求
    
    //html，xml可扩展标记语言，树形结构，json
    
}




@end
