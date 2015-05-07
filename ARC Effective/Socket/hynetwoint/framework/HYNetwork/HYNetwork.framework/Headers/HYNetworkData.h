//
//  HYNetworkData.h
//  HYNetworking
//
//  Created by zhangke on 13-4-17.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 该类是网络组件请求数据通用类，直接传入请求，
 无需考虑具体的数据内容。
 */

#import <Foundation/Foundation.h>

@interface HYNetworkData : NSObject

/*!
 请求url
 */
@property (retain) NSURL* URL;

/*!
 请求体
 */
@property (retain) NSDictionary* body;

/*!
 任何类实例，当请求结果返回后可以直接操作该对象
 */
@property (retain) id classInstance;

/*!
 接口名，当请求结果返回后可以知道使那个接口返回以便操作
 */
@property (retain) NSString* interfaceName;


/*!
 @method 类级别init方法
 @param
 @return  类对象
 */
+(HYNetworkData*)networkData;


@end
