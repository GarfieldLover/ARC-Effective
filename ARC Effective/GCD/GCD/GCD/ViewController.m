//
//  ViewController.m
//  GCD
//
//  Created by zhangke on 15/5/16.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "xunhuan.h"

@interface ViewController ()<NSURLConnectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //并行：是严格的同时执行，多核CPU执行多个任务，是真正的同时执行
    //A：10  B：10   Total：10
    //并发：并不是严格的同时执行，而是以时间片为单位交替执行，所以不需要多处理器。单核的，在多个任务间调度执行
    //A：10+B：10= Total：20
    

    //举个例子：
    //A和B需要各自挖一个坑，各自挖好需要时间10分钟。那么并行，就是同时执行，10分钟后，两个大坑就挖好了。而并发(单核)，则20分钟后，两个坑才挖好。因为A和B是交替执行的。这一秒A挖，下一秒B挖，，，，，如此交替下去。。。。
    
    
    //GCD，追加block的FIFO队列， atomic 的排他控制信号量 ，管理线程的C语言容器，数组，链表吧
    
    //instrament，arc下差不多什么问题，mrc循环引用查不出，其它能查出,
    //---------------ciyle能查出循环引用
    //NSNotificationCenter timer等 也查不出来
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xx) name:@"xxx" object:nil];

    
    dispatch_queue_t mainQ=dispatch_get_main_queue();
    dispatch_queue_t globalQ=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t serialQ=dispatch_queue_create("serial.zhangke", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrent=dispatch_queue_create("concurrent.zhangke", DISPATCH_QUEUE_CONCURRENT);
    
    
//    dispatch_sync(queue, block) 做了两件事情
//    
//    将 block 添加到 queue 队列；
//    阻塞调用线程，等待 block() 执行结束，回到调用线程。
//    同步派发和异步派发的区别，就是看是否阻塞调用线程。
    
    
//    当信号个数为 0 时，则线程阻塞，等待发送新信号；一旦信号个数大于 0 时，就开始处理任务。
//    
//    dispatch_semaphore_create：创建一个semaphore
//    
//    dispatch_semaphore_signal：发送一个信号，信号个数加1
//    
//    dispatch_semaphore_wait：等待信号
    

    
    //GCD的同步锁就是放在串行队列中
    
    
    //1.死锁，阻塞主线程，等待block执行并返回，block等待线程让它执行
    //async的话block确实在下边代码后执行，线程在代码间选择执行
    //sync，顺序执行代码，异步在代码间偏移执行，先执行早注册的，后执行后注册的异步代码
    //执行完本函数的同步代码，再跳回来来执行异步
#if 0
    dispatch_sync(mainQ, ^{
        NSLog(@"dispatch_sync, mainQ");
        NSLog(@"______%@", [NSThread currentThread]);
    });
#endif
    
    //2.同步执行代码，等待返回，卡当前线程，其实还是main，但是还不清楚为什么
    //****反正就是不等待返回就能执行下面代码
    //反正就是阻塞执行代码，等待返回，不管是什么queue，都在main上执行
    //没多大作用，使用多线程就是要异步
    //同步等待，sleep，还是等待返返回结果，返回void
    //在自己开辟的queue能执行，只能认为是加了标记，但是当前的thread还是main
#if 0
    dispatch_sync(globalQ, ^{
        NSLog(@"dispatch_sync,globalQ3");
        sleep(4);
        NSLog(@"______%@", [NSThread currentThread]);
        if([NSThread currentThread]==[NSThread mainThread]){
            NSLog(@"就是main。。");
        }
    });
    dispatch_sync(globalQ, ^{
        NSLog(@"dispatch_sync,globalQ1");
        sleep(4);
        NSLog(@"______%@", [NSThread currentThread]);
    });
    dispatch_sync(globalQ, ^{
        NSLog(@"dispatch_sync,globalQ2");
        NSLog(@"______%@", [NSThread currentThread]);
    });
#endif
    
    //3.在串行当然是顺序，但是是新线程
    //在并发不是一个线程，是多个，不知道具体是哪个先执行
#if 0
    dispatch_async(serialQ, ^{
        NSLog(@"dispatch_sync,globalQ3");
        NSLog(@"______%@", [NSThread currentThread]);
    });
    dispatch_async(serialQ, ^{
        NSLog(@"dispatch_sync,globalQ1");
        NSLog(@"______%@", [NSThread currentThread]);
    });
    dispatch_async(serialQ, ^{
        NSLog(@"dispatch_sync,globalQ2");
        NSLog(@"______%@", [NSThread currentThread]);
    });
#endif
    
    //-->>sync，同步等待返回，下边代码不执行，mainQ死锁 ，serialQ，concurrentQ都是顺序执行返回，并且都是mainThread
    //-->>async, mainQ，异步执行，先执行下边代码，直到所有同步代码执行完了，才会回来执行加入的异步代码
    //-->>async, serialQ，concurrentQ，串行或并发执行了，不阻塞也不延迟，调度执行，
    //感觉就和同步就是一定要顺序执行，异步在mainQ就是回调 按照加入的顺序执行，异步在子线程就是调度，其实时间是一样的，体验不一样
    //并行是真正的分开执行，而不是在来回调度
    
    //调度，CPU使用率，吞吐量（单位时间内的执行任务数量），周转时间，响应时间
    //先到先调度－队列，最短作业－先做时间短的，优先级－优先级高的可以抢占
    
    NSLog(@"不阻塞");
    
#if 0
    //OperationQueue最多还是开64个，除去主线程，都是子线程
    NSOperationQueue* operQ=[[NSOperationQueue alloc] init];
    
    __block int i=0;
    while (1) {
        NSBlockOperation* oper=[NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"%d   %@", i++ ,[NSThread currentThread]);
        }];
        [operQ addOperation:oper];
        
//        number = 112,
//        number = 80,
        //尼玛，GCD 搞不清楚到底能开多少个
//        dispatch_async(globalQ, ^{
//            NSLog(@"%@", [NSThread currentThread]);
//        });
    }
#endif
    
    
    //反正就是sync在等待block执行完成去执行下边代码，block在等待sync执行它
    
    
    //不使用变量就是 __NSGlobalBlock__
    //使用变量就是 ， __NSStackBlock__
    //aBlock=[block copy];  手动copy，copy后的就是__NSMallocBlock__
    //特么的不管事arc还是mrc
    
    //只和copy，self。retain有关
    __block id xxx=[NSObject alloc];
    xunhuan* block=[[xunhuan alloc] init];

    [block loadString:^(NSString* string, float process){
        self.xxxx=string;
        NSLog(@"%@",xxx);
        xxx=nil;
    }];
    
    
    //runtime解析json
    //block的用法，block内赋值，block内self，或xx＝self。xxx 的循环引用
    
    //runtime的东西，
    //多线程的3个
    //线程调度
    //runloop的
    
    
    dispatch_async(globalQ, ^{
        
        
        NSURLRequest* req=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i2.sinaimg.cn/ty/nba/2015-05-12/U4345P6T12D7605115F44DT20150512130255.jpg"]];
        NSURLConnection* dd=  [[NSURLConnection alloc] initWithRequest:req delegate:self];
        
        //运行下，加进入
        //将该对象配置到一个run loop
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        [dd scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        [dd start];
        
        //common 组合模式，default和uitracking
        
        //来设置NSURLConnection和NSStream的Run Loop以及模式，而且设置的Mode要设置为NSRunLoopCommonModes，因为NSRunLoopCommonModes默认会包含NSDefaultRunLoopMode和UITrackingRunLoopMode，这样无论Run Loop运行在哪个模式，都可以保证NSURLConnection或者NSStream的回调可以被调用。
        
        
    });
    
    
    //fmdb读取和写入是不是加锁啊，根本没想起来啊，
    //完全不是啊，是 同步队列和事务
    
    //执行10000图片读出，改变，再写回文件。io操作，控制数量
    
    
    //coredata的 ，2个类操作一个数据，我认为是没啥问题，别说，就说是可以fentchrequestvc同步
    
    //ui外边点击的
    //设置边缘距离，应该可以
    //[buttonsetImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];// 设置button图片与四周的距离
    
    //操，设置edge再 hittest，判断 point在不在edge理，返回self， CGRectContainsPoint
    
    
    //算法的，链表，堆，栈，
    
    
    
    NSLog(@"不阻塞");

    NSLog(@"不阻塞");

    
    NSLog(@"不阻塞");

    
    NSLog(@"不阻塞");

    
    NSLog(@"不阻塞");

    
    NSLog(@"不阻塞");

    [self xxx];
    sleep(3);
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}


-(void)xxx
{
    NSLog(@"xxxx函数");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"xxx");
        NSLog(@"______%@", [NSThread currentThread]);
    });
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
