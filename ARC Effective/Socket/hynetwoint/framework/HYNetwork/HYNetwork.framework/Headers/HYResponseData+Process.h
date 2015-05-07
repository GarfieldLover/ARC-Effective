//
//  HYResponseDataProcess.h
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 HYResponseData (Process)
 该类是HYResponseData的类别，用来处理根据业务
 要求细化处理返回结果。
 */

#import <Foundation/Foundation.h>
#import "HYResponseData.h"
#import "HYNetworkConfig.h"

@interface HYResponseData(Process)

/*!
 @method 根据业务要求把传入的基类解析为具体的业务派生类，如果其他具体业务重写该方法
 @param  请求响应数据基类对象
 @return  返回的是基类，在使用时强转为派生类
 */
+(HYResponseData*)responseDataProcessWithData:(HYResponseData*)data;

@end
