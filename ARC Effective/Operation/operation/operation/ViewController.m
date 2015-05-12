//
//  ViewController.m
//  operation
//
//  Created by zhangke on 15/5/12.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

　哈希表（Hash Table）是一种根据关键字直接访问内存存储位置的数据结构


//xmpp就是 在GCDAsyncSocket上的封装，定了很多通信的协议，发送和接收
- (void)keepAlive
[asyncSocket writeData:keepAliveData
           withTimeout:TIMEOUT_XMPP_WRITE
                   tag:TAG_XMPP_WRITE_STREAM];
//发送心跳，保持在线, 怕断


MPP以Jabber协议为基础，而Jabber是即时通讯中常用的开放式协议。

XMPPStream：xmpp基础服务类
XMPPRoster：好友列表类
XMPPRosterCoreDataStorage：好友列表（用户账号）在core data中的操作类
XMPPvCardCoreDataStorage：好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
XMPPvCardTemp：好友名片实体类，从数据库里取出来的都是它
xmppvCardAvatarModule：好友头像
XMPPReconnect：如果失去连接,自动重连
XMPPRoom：提供多用户聊天支持
XMPPPubSub：发布订阅

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
//发送消息
[[self xmppStream] sendElement:mes];
//好友上下线通知
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
//获取完好友列表
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
//更新自己的名片信息
- (void)updateMyvCardTemp:(XMPPvCardTemp *)vCardTemp;
//收到添加好友的请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
  [self xmppRoster] removeUser:jid];

//初始化聊天室
XMPPJID *roomJID = [XMPPJID jidWithString:ROOM_JID];

xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
//加入聊天室，使用昵称
[xmppRoom joinRoomUsingNickname:@"quack" history:nil];
//获取聊天室信息
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    [xmppRoom fetchConfigurationForm];
    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
    [xmppRoom fetchModeratorsList];
}



NSData *outgoingData = [outgoingStr dataUsingEncoding:NSUTF8StringEncoding];

XMPPLogSend(@"SEND: %@", outgoingStr);
numberOfBytesSent += [outgoingData length];

[asyncSocket writeData:outgoingData
           withTimeout:TIMEOUT_XMPP_WRITE
                   tag:tag];



@implementation ViewController

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if 0
    http://alvinzhu.me/blog/2013/10/06/iosde-duo-xian-cheng-fen-lei-yu-ying-yong/
    http://hufeng825.github.io/2013/09/14/ios23/
    http://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/
    http://www.cnblogs.com/scorpiozj/archive/2011/05/26/2058167.html
    http://alvinzhu.me/blog/2013/10/06/iosde-duo-xian-cheng-fen-lei-yu-ying-yong/
    http://mobile.51cto.com/hot-403080_1.htm
    http://m.baidu.com/from=1086k/bd_page_type=1/ssid=0/uid=0/pu=usm%400%2Csz%401320_2002%2Cta%40iphone_1_8.3_2_5.8/baiduid=EA9B3496A54DAD1827406790D0A6913B/w=0_10_ios+%E5%A4%9A%E7%BA%BF%E7%A8%8B/t=iphone/l=3/tc?ref=www_iphone&lid=13080308476782563025&order=2&vit=osres&tj=www_normal_2_0_10_title&m=8&srd=1&cltj=cloud_title&dict=21&nt=wnor&title=iOS%E4%B8%AD%E7%9A%84%E5%A4%9A%E7%BA%BF%E7%A8%8B-%E5%82%B2%E9%A3%8E%E5%87%8C%E5%AF%92%E7%9A%84%E4%B8%AA%E4%BA%BA%E7%A9%BA%E9%97%B4-%E5%BC%80%E6%BA%90%E4%B8%AD%E5%9B%BD%E7%A4%BE%E5%8C%BA&sec=3412&di=b3e9fd39c24ca75e&bdenc=1&nsrc=IlPT2AEptyoA_yixCFOxXnANedT62v3IGwvPKjtX_j35nI3tfeSaUbBbXTXq2Sm5IUn7wyPQpxsGwHSi0_
#endif
    
    Run loops是线程的基础架构部分。一个run loop就是一个事件处理循环，用来不停的调配工作以及处理输入事件。使用run loop的目的是使你的线程在有工作的时候工作，没有的时候休眠。
    每个线程，包括程序的主线程（main thread）都有与之相应的run loop对象。但是，自己创建的次线程是需要手动运行run loop的。

    
    //*** RunLoop的字面意思就是“运行回路”，听起来像是一个循环。实际它就是一个循环，它在循环监听着事件源，把消息分发给线程来执行。R
    
//    NSRunLoop只处理两种源：输入源、时间源
    Run loop模式是所有要监视的输入源和定时源以及要通知的注册观察者的集合。
    。基于端口的源监听程序相应的端口，而自定义输入源则关注自定义的消息。至于run loop
    两类输入源的区别在于如何显示的：基于端口的源由内核自动发送，而自定义的则需要人工从其他线程发送。
    并使用NSPort的方法将端口对象加入到run loop
    
    
    //    系统中的NSURLConnection就是基于NSSocketPort进行通信的，所以当在后台线程中使用NSURLConnection 时，需要手动启动RunLoop, 因为后台线程中的RunLoop默认是没有启动的，后面会讲到。
//    
//    定时源就是NSTimer了，定时源在预设的时间点同步地传递消息。因为Timer是基于RunLoop的，也就决定了它不是实时的。
//    
//    一直在循环该线程中的输入源和定时源
//    
//    Run loop入口
//    Run loop将要开始定时
//    Run loop将要处理输入源
//    Run loop将要休眠
//    Run loop被唤醒但又在执行唤醒事件前
//    Run loop终止
//    
//    入口－》开始定时－》处理输入源－》休眠－》唤醒－》终止
//    
//    NSURLConnection 启动线程的runloop
    如果基于端口的源准备好并处于等待状态，立即启动；并进入步骤9。
    通知观察者线程进入休眠
    将线程之于休眠直到任一下面的事件发生
    
    
    Run loops使创建一个长期生存的线程而使用很少的资源成为可能性。因为当线程没事可做的时候，一个run loop可以使线程休眠
    为线程提供一个Run loop那，就是为了减少线程在等待异步时间的时候，对资源的消耗。所以如果理解了Run loop自然线程如何使用就显而易见了。
    
    
    //等待事件触发的线程
    [cocoaCondition lock];
    while (timeToDoWork <= 0)
        [cocoaCondition wait];  //等待
    
    timeToDoWork--;
    
    // Do real work here.
    
    [cocoaCondition unlock];
    
    //出发事件的线程
    [cocoaCondition lock];
    timeToDoWork++;
    [cocoaCondition signal];  //唤醒等待的线程
    [cocoaCondition unlock];  

    
    
    
    //    提供了在 GCD 中不那么容易复制的有用特性。
//    可以很方便的取消一个NSOperation的执行
//    可以更容易的添加任务的依赖关系
//    提供了任务的状态：isExecuteing, isFinished.
    
    
    
    
//    （一）NSThread
//    （二）Cocoa NSOperation
//    （三）GCD（全称：Grand Central Dispatch）
    
//    优点：NSThread比其他两个轻量级
//    缺点：需要自己管理线程的生命周期，线程同步。线程同步对数据的加锁会有一定的系统开销
    
//    NSLock *theLock = [[NSLock alloc] init];
//    [theLock lock];
//    [theLock unlock];
//    
//    NSCondition * x=[[NSCondition alloc] init];
//    [x lock];
//    [x signal];
//    [x wait];
//    
//    
//    
//    @synchronized(self)
//    {
//        // Everything between the braces is protected by the @synchronized directive.
//    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSURLRequest* req=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i2.sinaimg.cn/ty/nba/2015-05-12/U4345P6T12D7605115F44DT20150512130255.jpg"]];
        NSURLConnection* dd=  [[NSURLConnection alloc] initWithRequest:req delegate:self];
        //
        //明白NSURLConnection的运行，实际也是需要当前线程具备run loop。
        //将加入指定的run loop中运行，
        //启动run loop
        //在后台都要启动runloop
        //NSURLSessionDataTask，专门上传下载
        
//        可以发现 NSTimer 是不准确的。被暂停了如果线程当前正在处理繁重的任务，比如循环，就有可能导致Timer本次延时，或者少执行一次
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        
        [dd scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    });
                   

    
//    4.1.1 互斥锁
//    互斥访问的意思就是同一时刻，只允许一个线程访问某个特定资源。为了保证这一点，每个希望访问共享资源的线程，首先需要获得一个共享资源的互斥锁。 对资源加锁会引发一定的性能代价。
//    4.1.2 原子性
//    从语言层面来说，在 Objective-C 中将属性以 atomic 的形式来声明，就能支持互斥锁了。事实上在默认情况下，属性就是 atomic 的。将一个属性声明为 atomic 表示每次访问该属性都会进行隐式的加锁和解锁操作。虽然最把稳的做法就是将所有的属性都声明为 atomic，但是加解锁这也会付出一定的代价。
//    4.1.3 死锁
//    互斥锁解决了竞态条件的问题，但很不幸同时这也引入了一些其他问题，其中一个就是死锁。当多个线程在相互等待着对方的结束时，就会发生死锁，这时程序可能会被卡住。
    
    
    
    [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];

    [self performSelectorInBackground:@selector(download) withObject:nil];
    
    NSThread* xxx= [[NSThread alloc] initWithTarget:self selector:@selector(download) object:nil];
    [xxx start];
    
    [self performSelectorInBackground:@selector(download) withObject:nil];
    
    
    NSLog(@"xxxx");
    
    
    //加进入会执行，本身是并发的，可以设置依赖关系
    //setMaxConcurrentOperationCount也可以做成串行的
    //NSOperationQueue会建立一个线程池，每个加入到线程operation会有序的执行。
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
    
    [blockoper cancel];
    
    //    [queue cancelAllOperations];
    
    
    //Operation设置依赖，设置操作个数，可以取消
    
    //GCD，更底层执行效率更高，不需要关心线程管理，把精力放在自己需要执行的操作上。
    //使用Blocks后代码易读
    
    
    
    //GCD  优点：数据同步的事情，可以把精力放在自己需要执行的操作上。

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
    
    
    //信号量 和 琐 的作用差不多,可以用来实现同步的方式. 但是信号量通常用在 允许几个线程同时访问一个资源,通过信号量来控制访问的线程个数.
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //1.先去网上下载图片
    dispatch_async(dispatchqueue, ^{
        
        // wait操作-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 开始下载
        // signal操作+1
        dispatch_semaphore_signal(semaphore);
    });
    
    
    // 2.等下载好了再在刷新主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // wait操作-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //显示图片
        // signal操作+1
        dispatch_semaphore_signal(semaphore);
    });


//    dispatch_get_global_queue   全局并发线程
//    dispatch_get_main_queue    主线程
//    dispatch_once              一次性执行
//    dispatch_after        延迟执行
//    dispatch_queue_create 创建队列
//    dispatch_group_async    加入group
//    dispatch_group_notify    group执行结束通知
    
    
    //NSURLSession 后台任务 ，只能做下载任务吧
    
//    myTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        // 后台任务到期执行，好像是10分钟，实际3分钟
//    }];
    
//    [[UIApplication sharedApplication] endBackgroundTask: myTask];
//    myTask = UIBackgroundTaskInvalid;
    
    
    
    
}






-(void)download
{
    @synchronized(self)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i2.sinaimg.cn/ty/nba/2015-05-12/U4345P6T12D7605115F44DT20150512130255.jpg"]];
        NSLog(@"%@,%@",[NSThread mainThread], [NSThread currentThread]);
        
        //线程间通信

        [self performSelectorOnMainThread:@selector(reload:) withObject:data waitUntilDone:YES];

    }

    //线程间通信 ,
}

-(void)reload:(NSObject*)object
{

}



@end
