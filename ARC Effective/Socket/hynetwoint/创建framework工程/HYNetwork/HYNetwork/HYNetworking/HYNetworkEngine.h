//
//  HYNetworkEngine.h
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 该类是网络组件核心类，利用了数据缓存机制进行数据
 传输，使用该类首先设置代理，可以判断当前联网状态后，
 进行数据传输，由代理或block方法返回数据。
 该类使用了传入传出数据的基类作为处理对象，所以不
 需要修改该类里的内容。
 */


#import <Foundation/Foundation.h>
#import "HYNetworkDelegate.h"
#import "HYRequestData.h"
#import "HYResponseData.h"
#import "HYResponseData+Process.h"
#import "HYNetworkConfig.h"
#import "HYDataEncryption.h"

/*
 网络连接类型
 */
typedef enum{
    NotConnection,             //当前无连接
    WANConnection,            //3G连接
    WiFiConnection             //wifi连接
} HYNetworkConnection;

/*
 自定义block
 */
typedef void (^HYNetworkStartedBlock)(HYNetworkData* , CGFloat);
typedef void (^HYNetworkFinishBlock)(HYNetworkData* , HYResponseData*);
typedef void (^HYQueueStartBlock)(NSArray* , CGFloat);
typedef void (^HYQueueFinishBlock)(NSArray* , CGFloat);


@interface HYNetworkEngine : NSObject{
    
	//单个请求开始后执行的block
    HYNetworkStartedBlock startedBlock;
    
    //单个请求开始后执行的block
    HYNetworkFinishBlock finishBlock;
    
    //数组请求开始后执行的block
    HYQueueStartBlock queueStartBlock;
    
    //数组请求结束后执行的block
    HYQueueFinishBlock queueFinishBlock;
    
    //请求缓存数组
    NSMutableArray* requestArray;
    
    //请求队列缓存数组
    NSMutableArray* queueArray;
    
    //删除标记
    NSInteger removeDataIndex;
    
    //进度
    UIProgressView* queueProgress;
    
    //队列计时
    NSTimer* queueTimer;
    
    NSString* _deviceToken;
    
    NSString* _deviceTokenKey;
}

/*!
 代理
 */
@property (nonatomic,assign) id<HYNetworkDelegate> delegate;


/*!
 @method 初始化单例类
 @param
 @return  HYNetworkEngine单例对象
 */
+(HYNetworkEngine*)shareHYNetworkEngine;

/*!
 @method 检查当前网络类型
 @param
 @return  HYNetworkConnection网络连接类型
 */
+(HYNetworkConnection)checkNetworkConnection;


/*!
 @method 传入HYNetworkData对象数据，自动开始请求,通过代理返回数据及进度
 @param  HYNetworkData对象
 @return
 */
-(void)startRequestWithNetworkData:(HYNetworkData*)data;

/*!
 @method 传入HYNetworkData对象数组，自动开始请求,通过代理返回数据及进度
 @param  HYNetworkData对象的数组
 @return
 */
-(void)startRequestWithNetworkDataArray:(NSArray*)array;


/*!
 @method 设置单个请求开始后的block方法
 @param
 @return  返回block对应类型数据
 */
- (void)setStartedBlock:(HYNetworkStartedBlock)aStartedBlock;

/*
 @method 设置单个请求结束的block方法
 @param
 @return  返回block对应类型数据
 */
- (void)setFinishBlock:(HYNetworkFinishBlock)aFinishBlock;

/*!
 @method 设置数组请求开始后的block方法
 @param
 @return  返回block对应类型数据
 */
- (void)setQueueStartedBlock:(HYQueueStartBlock)aStartedBlock;

/*!
 @method 设置数组请求结束的block方法
 @param
 @return  返回block对应类型数据
 */
- (void)setQueueFinishBlock:(HYQueueFinishBlock)aFinishBlock;

-(void)setDeviceToken:(NSString*)deviceToken andDeviceTokenKey:(NSString*)deviceTokenKey;

/*!
 @method 将日志输出到文件
 @param
 @return
 */
- (void)redirectNSLogToDocumentFolder;

/*!
 @method 取消全部或者当前请求
 @param
 @return
 */
-(void)cancelRequset:(BOOL)allRequestOrCurrentRequest;

/*!
 @method 取消全部或者当前队列
 @param
 @return
 */
-(void)cancelQueue:(BOOL)allQueueOrCurrentQueue;

@end

