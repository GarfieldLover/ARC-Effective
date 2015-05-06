//
//  AppDelegate.m
//  Demo
//
//  Created by 达 坤 on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

typedef struct tagLostDataType
{
    int start;
    int size;
}LostDataType;

typedef struct tagDataType
{
    int start;
    int cell;   //块
    int size; 
    int totle;
    Byte data[CELL_SIZE];    
}DataType;

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [sock release];
    [recv release];
    
    dispatch_release(sockQueue);
    dispatch_release(recvQueue);
    
    [_window release];
    [super dealloc];
}

#define PORT    0x8888
#define PORT_1  0x9999

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //拷贝文件
    for (int i = 0; i < 2; i++) 
    {
        UIButton *send = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [send setFrame: CGRectMake(20+120*i, 40, 100, 30)];
        [send setTitle: (!i?@"发送":@"续传") forState: UIControlStateNormal];
        [send setTag: i+1];
        [send addTarget: self action: @selector(btnDidClicked:) 
       forControlEvents: UIControlEventTouchUpInside];
        [self.window addSubview: send];
    }
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame: CGRectMake(10, 100, 300, 200)];
    [self.window addSubview: imgv];
    [imgv release];
    
    [[imgv layer] setBorderWidth: 1.0];
    [imgv setTag: 3];
    
    UILabel *lable = [[UILabel alloc] initWithFrame: CGRectMake((300-150)/2.0, 
                                                                (200-30)/2.0, 
                                                                150, 30)];
    [lable setText: @"进度: %0"];
    [lable setFont: [UIFont boldSystemFontOfSize: 15.0]];
    [lable setTextAlignment: UITextAlignmentCenter];
    [imgv addSubview: lable];
    [lable release];
    
    [lable setTag: 4];
    
    [[DKFileManager sharedManager] setDelegate: self];
    
    sockQueue = dispatch_queue_create("sock", 0);
    recvQueue = dispatch_queue_create("recv", 0);
    
    sock = [[GCDAsyncUdpSocket alloc] initWithDelegate: self
                                         delegateQueue: sockQueue];
    
    recv = [[GCDAsyncUdpSocket alloc] initWithDelegate: self
                                         delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [recv setDelegate: self];
    if (![recv bindToPort: PORT error: nil])
    {
        NSLog(@"bind ERROR");
        return YES;
    }
    if (![recv beginReceiving: nil])
    {
        NSLog(@"receiving ERROR");
        return YES;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) btnDidClicked:(UIButton *) btn
{
    if (1 == btn.tag) 
    {
        //删除目录下的2.png文件
        [[NSFileManager defaultManager] removeItemAtPath: DOC(@"2.png") 
                                                   error: nil];
        //将1.PNG拷贝到目录下
        NSString *path = [[NSBundle mainBundle] pathForResource: @"1.PNG" ofType: nil];
        [[NSFileManager defaultManager] copyItemAtPath: path 
                                                toPath: DOC(@"1.PNG")
                                                 error: nil];
        
        [[DKFileManager sharedManager] splitFileData: DOC(@"1.PNG")];
    }
    else
    {
        //保存文件数据，并找出缺失数据
        [[DKFileManager sharedManager] saveTempDataIntoPath: @"1.PNG" 
                                                     toPath: DOC(@"2.png")];
    }
}

//拆分的数据
//zk,分割数据块发送
//TCP应该也一样，分割
int test = 0;
bool bLost = NO;
- (void) dkFileManagerDidSendFileData:(DKFileManager*) manager 
                                 data:(NSData *) data
                                start:(DKInt) start
                                index:(DKInt) index
{
    if (!(test++ % 10))
    {
        return ;
    }

    DataType type = {0};
    type.start = start;
    type.cell = index;
    type.size = [data length];
    type.totle = [[DKFileManager sharedManager] fileLength: DOC(@"1.PNG")];
    memcpy(type.data, [data bytes], [data length]);
    [sock sendData: [NSData dataWithBytes: &type length: sizeof(type)] 
            toHost: @"127.0.0.1" port: PORT withTimeout: -1 tag: 0];
}

//dkFileManager不能接收到数据，超时
- (void) dkFileManagerDidNoRecvData:(DKFileManager*) manager 
                               name:(NSString *) name
{
    NSLog(@"不能接收到数据，超时");
    [[DKFileManager sharedManager] saveTempDataIntoPath: name 
                                                 toPath: DOC(@"2.png")];
}
//dkFileManager接收数据完成
- (void) dkFileManagerDidFinishRecvData:(DKFileManager*) manager 
                                   name:(NSString *) name
{
    NSLog(@"接收数据完成");
    [[DKFileManager sharedManager] saveTempDataIntoPath: name 
                                                 toPath: DOC(@"2.png")];
}
//dkFileManager保存文件数据完成
- (void) dkFileManagerDidFinishSaveData:(DKFileManager*) manager 
                                   name:(NSString *) name
{
    NSLog(@"保存文件数据完成");
    UILabel *lable = (UILabel *)[self.window viewWithTag: 4];
    UIImageView *imgv = (UIImageView *)[self.window viewWithTag: 3];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [lable setHidden: YES];
        [imgv setImage: [UIImage imageWithContentsOfFile: DOC(@"2.png")]];
    });
}

- (void) dkFileManagerDidLostData:(DKFileManager*) manager 
                             name:(NSString *) name
                              array:(NSArray *) lost
{
    for (NSDictionary * dic in lost) 
    {
        //丢失的文件段落
        LostDataType type = {0};
        type.size = [[dic objectForKey: DKFILE_SIZE] longValue];
        type.start = [[dic objectForKey: DKFILE_START] longValue];
        [sock sendData: [NSData dataWithBytes: &type length: sizeof(type)] 
                toHost: @"127.0.0.1" port: PORT withTimeout: -1 tag: 0];
        
        return ;
    }
}

#pragma mark -
#pragma mark GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)udp didConnectToAddress:(NSData *)address
{
    NSLog(@"%@ 已连接",address);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)udp didNotConnect:(NSError *)error
{
    NSLog(@"%@ 没有连接", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)udp didSendDataWithTag:(long)tag
{
	NSLog(@"didSendDataWithTag");   
}

- (void)udpSocket:(GCDAsyncUdpSocket *)udp didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"didNotSendDataWithTag");
}

//统一处理接收到的消息
- (void)udpSocket:(GCDAsyncUdpSocket *)udp didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    //zk 得到4112字节，address有16字节，然后再组合
    //接受数据块合并
    //数据块前可以加header确定到底是哪个文件的
    //不过一般im的文件处理都是http了
    NSLog(@"didReceiveData = %d", [data length]);
    if ([data length] != sizeof(LostDataType))
    {
        DataType type = {0};
        memcpy(&type, [data bytes], [data length]);
        
        //接收的数据
        length += type.size;
        
        UILabel *lable = (UILabel *)[self.window viewWithTag: 4];
        CGFloat rot = length*1.0/type.totle;
        dispatch_async(dispatch_get_main_queue(), ^{
            [lable setText: [NSString stringWithFormat: @"进度: %.2f", rot]];
        });
        
        //组合数据块
        //range不是｛0，size｝，是｛length－size，length｝
        NSData* newdata= [NSData dataWithBytes: type.data length: type.size];
        [[DKFileManager sharedManager] mergeFileData: @"1.PNG"
                                                data: newdata
                                               start: type.start
                                               totle: type.totle];
    }
    else
    {
        //丢失的数据需要重新发送
        LostDataType type = {0};
        memcpy(&type, [data bytes], [data length]);
        
        //发送丢失部分的数据
        [[DKFileManager sharedManager] catchFileSubData:DOC(@"1.PNG") 
                                                  start:type.start 
                                                   size:type.size];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
