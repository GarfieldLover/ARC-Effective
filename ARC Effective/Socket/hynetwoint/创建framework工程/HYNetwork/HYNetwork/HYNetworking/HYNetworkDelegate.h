//
//  HYNetworkDelegate.h
//  HYNetworking
//
//  Created by zhangke on 13-4-11.
//  Copyright (c) 2013年 张科. All rights reserved.
//

/*!
 该类框架的代理方法，请求后通知调用者
 */

#import "HYResponseData.h"
#import "HYNetworkData.h"

@protocol HYNetworkDelegate <NSObject>

@optional

/*!
 @method 请求开始后通知代理者, 提示进度
 @param  classInstance调用者传入的任意对象，在请求结束后方便直接处理该对象
 @return
 */
-(void)networkStarted:(HYNetworkData*)networkData andProcess:(CGFloat)process;

/*!
 @method 请求结束通知代理者, 接收数据
 @param  HYResponseData对象强转为具体的业务数据类
 @return
 */
-(void)networkDidFinish:(HYNetworkData*)networkData andData:(HYResponseData*)data;

/*!
 @method 队列请求开始后通知代理者, 提示进度s
 @param
 @return
 */
-(void)queueStarted:(NSArray*)networkDataArray andProgress:(CGFloat)progress;

/*!
 @method 队列请求结束通知代理者, 接收数据
 @param  array对象为HYResponseData数组，强转后使用
 @return
 */
-(void)queueDidFinish:(NSArray*)networkDataArray andProgress:(CGFloat)progress;


@end