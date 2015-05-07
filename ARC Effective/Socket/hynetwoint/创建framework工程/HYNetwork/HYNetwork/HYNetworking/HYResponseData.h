//
//  HYResponseData.h
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//



/*!
 请求响应数据返回基类，该类有两个属性，分别为
 返回的字符串和二进制数据。派生类可以扩展属性，已
 适应业务。
 */

#import <Foundation/Foundation.h>

@interface HYResponseData : NSObject

/*!
 请求返回的字符串数据
 */
@property (retain) NSString* responseString;

/*!
 请求返回的二进制数据
 */
@property (retain) NSData* responseData;



@end
