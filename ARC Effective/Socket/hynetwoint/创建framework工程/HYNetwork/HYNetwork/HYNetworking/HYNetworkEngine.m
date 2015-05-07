//
//  HYNetworkEngine.m
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "HYNetworkEngine.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "ASINetworkQueue.h"

/*
 触发请求类型
 */
typedef enum{
    callerStart,
    finishStart
} startType;

@interface HYNetworkEngine ()<ASIHTTPRequestDelegate,ASIProgressDelegate>

@end

@implementation HYNetworkEngine
@synthesize delegate;



-(void)dealloc
{
    [requestArray release];
    [queueArray release];
    [startedBlock release];
    [finishBlock release];
    [queueProgress release];
    [queueStartBlock release];
    [queueFinishBlock release];
    [super dealloc];
}

+(HYNetworkEngine*)shareHYNetworkEngine
{
    static HYNetworkEngine* networkEngine=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkEngine=[[HYNetworkEngine alloc] init];
        [HYDataEncryption shareInstance];
    });
    return networkEngine;
}

-(id)init
{
    self=[super init];
    if(self){
        //初始化，默认数据
        requestArray=[[NSMutableArray alloc] init];
        queueArray=[[NSMutableArray alloc] init];
        queueProgress=[[UIProgressView alloc] init];
        removeDataIndex=0;
        [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(uploadLog) userInfo:Nil repeats:YES];
    }
    return self;
}

+(HYNetworkConnection)checkNetworkConnection
{
    Reachability* reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if([reach isReachable]==NO){
        return NotConnection;
    }else{
        if([reach isReachableViaWWAN]){
            return WANConnection;
        }else if([reach isReachableViaWiFi]){
            return WiFiConnection;
        }
    }
    return NotConnection;
}

-(void)setDeviceToken:(NSString*)deviceToken andDeviceTokenKey:(NSString*)deviceTokenKey
{
    if(_deviceToken){
        [_deviceToken release];
    }
    _deviceToken=[deviceToken retain];
    if(_deviceTokenKey){
        [_deviceTokenKey release];
    }
    _deviceTokenKey=[deviceTokenKey retain];
}


//--------------------------------------------创建并设置请求内容---------------------------------------------
/*
 @method 创建设置ASIFormDataRequest，根据传入的body的不同类型设置
 @param   HYNetworkData对象
 @return   ASIFormDataRequest对象
 */
-(ASIFormDataRequest*)requestWithNetworkData:(HYNetworkData*)data
{
    LOG(@"  实例化request");
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:data.URL];
    request.networkData=data;
    
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic setValue:@"iOS" forKey:@"systemName"];
    [dic setValue:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    id CFBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    id CFBundleShortVersionString=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* appVersion=[NSString stringWithFormat:@"%@(%@)",CFBundleShortVersionString,CFBundleVersion];
    [dic setValue:appVersion forKey:@"appVersion"];
    id CFBundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    [dic setValue:CFBundleIdentifier forKey:@"appName"];
    if(_deviceTokenKey!=nil && _deviceToken!=nil){
        [dic setValue:_deviceToken forKey:_deviceTokenKey];
    }
    [dic setValue:@"2.0" forKey:@"_giip_version_"];
    [dic setValue:@"YES" forKey:@"encrypt"];
    
    request.requestHeaders=dic;
    [dic release];
    LOG(@"  request.requestHeaders:%@",request.requestHeaders);
    NSArray* keys=[data.body allKeys];
    for(NSString* key in keys){
        id value=[data.body valueForKey:key];
        //如果该值是二进制类型
        if([value isKindOfClass:[NSData class]]){
            [request setData:value forKey:key];
            LOG(@"  执行[request setData:value forKey:key]");
            //如果值是字符串类型
        }else if([value isKindOfClass:[NSString class]]){
            //如果是以文件路径传入
            if([[NSFileManager defaultManager] fileExistsAtPath:value]){
                [request setFile:value forKey:key];
                LOG(@"  执行[request setFile:value forKey:key]");
            }else{
                //如果是字符串：json、xml
                value=[[HYDataEncryption shareInstance] encryptStringUseDES:value];
                [request setPostValue:value forKey:key];
                LOG(@"  执行[request setPostValue:value forKey:key]");
            }
        }
    }
    return request;
}


//----------------------------------------------单个请求-------------------------------------------------

-(void)startRequestWithNetworkData:(HYNetworkData*)data
{
    if(data){
        ASIFormDataRequest* request=[self requestWithNetworkData:data];
        request.delegate=self;
        request.uploadProgressDelegate=self;
        request.downloadProgressDelegate=self;
        [requestArray addObject:request];
    }
    [self startRequestWith:callerStart];
}

/*
 @method  根据触发类型和当前缓存数组确定是否发起请求
 @param   startType
 @return
 */
-(void)startRequestWith:(startType)type
{
    if((type==callerStart && requestArray.count==1) || (type==finishStart && requestArray.count>0)){
        [[requestArray objectAtIndex:removeDataIndex] startAsynchronous];
        LOG(@"  执行新的请求");
    }
}

/*
 @method  根据请求结束的ASIHTTPRequest和解析后的HYResponseData通过代理和block返回
 @param   ASIHTTPRequest对象，HYResponseData对象（实际上是具体业务类型对象）
 @return
 */
-(void)respondsToFinishDelegateWith:(ASIHTTPRequest*)request addResponseData:(HYResponseData*)data
{
    LOG(@"  请求完毕，执行解析和代理");
    HYResponseData* returnData=[HYResponseData responseDataProcessWithData:data];
    if(delegate && [delegate respondsToSelector:@selector(networkDidFinish:andData:)]){
        [delegate networkDidFinish:request.networkData andData:returnData];
    }
    if(finishBlock){
        finishBlock(request.networkData , returnData);
    }
    if(request.queueNumber==NO && requestArray.count>0){
        [requestArray removeObjectAtIndex:removeDataIndex];
        LOG(@"  当前请求数量：%d",requestArray.count);
        [self startRequestWith:finishStart];
    }
}

- (void)setStartedBlock:(HYNetworkStartedBlock)aStartedBlock
{
    [startedBlock release];
	startedBlock = [aStartedBlock copy];
}

-(void)setFinishBlock:(HYNetworkFinishBlock)aFinishBlock
{
    [finishBlock release];
	finishBlock = [aFinishBlock copy];
}


//---------------------------------------------队列请求-----------------------------------------------

-(void)startRequestWithNetworkDataArray:(NSArray*)array
{
    LOG(@"  组织NetworkQueue");
    ASINetworkQueue* queue=[[ASINetworkQueue alloc] init];
    queue.delegate=self;
    queue.showAccurateProgress=YES;
    queue.shouldCancelAllRequestsOnFailure=YES;
    queue.networkDataArray=array;
    [queue setQueueDidFinishSelector:@selector(queueDidFinish:)];
    
    for(int i=0;i<array.count;i++){
        if([[array objectAtIndex:i] isKindOfClass:[HYNetworkData class]]){
            ASIFormDataRequest* request=[self requestWithNetworkData:[array objectAtIndex:i]];
            request.delegate=self;
            request.downloadProgressDelegate=self;
            request.queueNumber=YES;
            [queue addOperation:request];
        }
    }
    [queueArray addObject:queue];
    [queue release];
    
    [self startQueueWith:callerStart];
}

/*
 @method  根据触发类型和当前缓存数组确定是否发起队列请求，并设置该队列的进度代理和计时器
 @param   startType
 @return
 */
-(void)startQueueWith:(startType)type
{
    if((type==callerStart && queueArray.count==1) || (type==finishStart && queueArray.count>0)){
        queueProgress.progress=0.0f;
        ASINetworkQueue* queue=[queueArray objectAtIndex:removeDataIndex];
        queue.uploadProgressDelegate=queueProgress;
        [queue go];
        queueTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(returnQueueProgress:) userInfo:nil repeats:YES];
        LOG(@"  执行新的请求队列");
    }
}

/*
 @method  由NSTimer调用，每隔1秒返回给调用者当前队列请求进度
 @param   NSTimer
 @return
 */
-(void)returnQueueProgress:(NSTimer*)timer
{
    if(delegate && [delegate respondsToSelector:@selector(queueStarted:andProgress:)]){
        if(queueArray.count>0){
            [delegate queueStarted:[[queueArray objectAtIndex:removeDataIndex] networkDataArray] andProgress:queueProgress.progress];
        }
    }
    if(queueStartBlock){
        if(queueArray.count>0){
            queueStartBlock([[queueArray objectAtIndex:removeDataIndex] networkDataArray],queueProgress.progress);
        }
    }
    if(queueProgress.progress==1.0f){
        [timer invalidate];
    }
}

/*
 @method  队列请求结束调用，结束后通过代理和block返回数据
 @param   ASINetworkQueue
 @return
 */
-(void)queueDidFinish:(ASINetworkQueue*)queue
{
    LOG(@"  队列请求完毕，执行解析和代理");
    if(delegate && [delegate respondsToSelector:@selector(queueDidFinish:andProgress:)]){
        if(queueArray.count>0){
            [delegate queueDidFinish:[[queueArray objectAtIndex:removeDataIndex] networkDataArray] andProgress:queueProgress.progress];
        }
    }
    if(queueFinishBlock){
        if(queueArray.count>0){
            queueFinishBlock([[queueArray objectAtIndex:removeDataIndex] networkDataArray],queueProgress.progress);
        }
    }
    if(queueArray!=Nil){
        if(queueArray.count>0){
            [queueArray removeObjectAtIndex:removeDataIndex];
            [self startQueueWith:finishStart];
        }
    }}


- (void)setQueueStartedBlock:(HYQueueStartBlock)aStartedBlock
{
    [queueStartBlock release];
	queueStartBlock = [aStartedBlock copy];
}

- (void)setQueueFinishBlock:(HYQueueFinishBlock)aFinishBlock
{
    [queueFinishBlock release];
    queueFinishBlock=[aFinishBlock copy];
}


//------------------------------------------请求代理--------------------------------------------

/*
 @method  ASIHTTPRequest的代理，通过代理返回当前请求传输进度
 @param
 @return
 */
-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    request.uploadProgress+=(CGFloat)bytes/(CGFloat)request.postLength;
    if(delegate && [delegate respondsToSelector:@selector(networkStarted:andProcess:)]){
        [delegate networkStarted:request.networkData andProcess:request.uploadProgress];
    }
    if(startedBlock){
        startedBlock(request.networkData,request.uploadProgress);
    }
}

-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    CGFloat contentLength=[[request.responseHeaders valueForKey:@"Content-Length"] longLongValue];
    request.downloadProgress+=(CGFloat)bytes/contentLength;
    if(delegate && [delegate respondsToSelector:@selector(networkStarted:andProcess:)]){
        [delegate networkStarted:request.networkData andProcess:request.downloadProgress];
    }
    if(startedBlock){
        startedBlock(request.networkData,request.downloadProgress);
    }
}


/*
 @method  ASIHTTPRequest的代理，通过代理返回请求结果数据
 @param
 @return
 */
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    LOG(@"  request.responseString==%@",request.responseString);
    LOG(@"  request.responseString==%@",[[HYDataEncryption shareInstance] decryptStringUseDES:request.responseString]);
    LOG(@"  request.responseData.length==%d",request.responseData.length);
    HYResponseData* data=[[HYResponseData alloc] init];
    
    if(request.responseStatusCode==500 || request.responseStatusCode==401 || request.responseStatusCode==404){
        data.responseString=[NSString stringWithFormat:@"%d",request.responseStatusCode];
    }else{
        data.responseString=[[HYDataEncryption shareInstance] decryptStringUseDES:request.responseString];
        data.responseData=request.responseData;
    }
    [self respondsToFinishDelegateWith:request addResponseData:data];
    [data release];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    LOG(@"  request.responseString==%@",request.responseString);
    LOG(@"  request.responseString==%@",[[HYDataEncryption shareInstance] decryptStringUseDES:request.responseString]);
    LOG(@"  request.responseData.length==%d",request.responseData.length);
    if(queueArray.count>0){
        [[queueArray objectAtIndex:removeDataIndex] cancelAllOperations];
    }
    if(request.responseStatusCode==500 || request.responseStatusCode==401 || request.responseStatusCode==404){
        HYResponseData* data=[[HYResponseData alloc] init];
        data.responseString=[NSString stringWithFormat:@"%d",request.responseStatusCode];
        [self respondsToFinishDelegateWith:request addResponseData:data];
        [data release];
    }else if(request.responseStatusCode==0){      //请求超时重试 , 可添加其他 //测试具体编号
        HYResponseData* data=nil;
        if([HYNetworkEngine checkNetworkConnection]==NotConnection){
            LOG(@"  当前无网络，请求失败");
            data=[[HYResponseData alloc] init];
            data.responseString=@"当前无网络";
        }else{
            LOG(@"  当前网络异常，请稍后重试");
            data=[[HYResponseData alloc] init];
            data.responseString=@"当前网络异常，请稍后重试";
        }
        [self respondsToFinishDelegateWith:request addResponseData:data];
        [data autorelease];
    }
}

-(void)cancelRequset:(BOOL)allRequestOrCurrentRequest;
{
    if(allRequestOrCurrentRequest==YES){
        for(ASIHTTPRequest* request in requestArray){
            [request cancel];
        }
        [requestArray removeAllObjects];
        LOG(@"  当前请求数量：%d",requestArray.count);
    }else{
        [[requestArray objectAtIndex:removeDataIndex] cancel];
        [requestArray removeObjectAtIndex:removeDataIndex];
        LOG(@"  当前请求数量：%d",requestArray.count);
        [self startRequestWith:finishStart];
    }
}

-(void)cancelQueue:(BOOL)allQueueOrCurrentQueue
{
    if(allQueueOrCurrentQueue==YES){
        for(ASINetworkQueue* queue in queueArray){
            [queue cancelAllOperations];
        }
        [queueArray removeAllObjects];
        LOG(@"  当前请求数量：%d",queueArray.count);
    }else{
        [[queueArray objectAtIndex:removeDataIndex] cancelAllOperations];
        [queueArray removeObjectAtIndex:removeDataIndex];
        LOG(@"  当前请求数量：%d",queueArray.count);
        [self startQueueWith:finishStart];
    }
}

- (void)redirectNSLogToDocumentFolder
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString* logPath=[documentsDirectory stringByAppendingPathComponent:@"Logs"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:logPath]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
    
    NSDate* date= [NSDate date];
    NSDateFormatter* dateFor=[[NSDateFormatter alloc] init];
    dateFor.dateStyle=NSDateFormatterShortStyle;
    NSString *fileName =[NSString stringWithFormat:@"/%@/%@.log",@"Logs", [dateFor stringFromDate:date]];
    [dateFor release];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

-(void)uploadLog
{
    if([HYNetworkEngine checkNetworkConnection]!=NotConnection){
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
        NSDate* date= [NSDate date];
        NSDateFormatter* dateFor=[[NSDateFormatter alloc] init];
        dateFor.dateStyle=NSDateFormatterShortStyle;
        NSString *fileName =[NSString stringWithFormat:@"/%@/%@.log",@"Logs", [dateFor stringFromDate:date]];
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:logFilePath]){
            HYGIIPRequestData* log=[[HYGIIPRequestData alloc] init];
            NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:logFilePath,@"fileContent",@"contentJson",@"contentJson",nil];
            [log setInterfaceName:@"giip_upload_logfile" andParameters:[NSString stringWithFormat:@"fileName=%@.log",[dateFor stringFromDate:date]] andUserID:[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] andRequestBody:dic andClassInstance:Nil];
            HYNetworkData* logData=[log checkAndOrganizeRequestData];
            [self startRequestWithNetworkData:logData];
            [log release];
        }
        [dateFor release];
    }
}



@end
