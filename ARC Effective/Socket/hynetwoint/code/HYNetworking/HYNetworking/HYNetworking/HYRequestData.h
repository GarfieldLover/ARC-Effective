//
//  HYRequestData.h
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 请求数据基类,任意具体业务的请求数据类可以
 继承于该类。类中定义了一些通用的方法和属性，
 派生类可以重写这些方法和增加属性适应具体业务。
 */

#import <Foundation/Foundation.h>
#import "HYNetworkData.h"
#import "HYNetworkConfig.h"

@interface HYRequestData : NSObject{
    NSString* _serverPath;
    NSString* _deviceID;
    NSString* _userID;
}

/*!
 请求地址   例：http://192.168.1.57:8888/GIIP
 可以一次设置后，以后使用不用设置.
 */
@property (nonatomic, retain) NSString* serverPath;

/*!
 设备id   例：TEST_XL_SG
 可以一次设置后，以后使用不用设置.
 */
@property (nonatomic, retain) NSString* deviceID;


@property (nonatomic, retain) NSString* userID;

/*!
 请求体内容，可以设置多对键值
 例：[requestBody setValue:json forKey:@"content_json"];
 例：[requestBody setValue:@"Document/file/file.png" forKey:@"content_data"];
 如果没有key，设置key为空 [requestBody setValue:json forKey:@""];
 */
@property (retain) NSMutableDictionary* requestBody;

/*!
 @method 检验和组织HYNetworkData类数据，对象级方法，直接调用
 @param
 @return  检验成功则组织返回HYNetworkData类数据，否则返回nil
 */
-(HYNetworkData*)checkAndOrganizeRequestData;

/*!
 @method  设置请求地址、设备id、app版本
 @param  请求地址、设备id、app版本
 @return
 */
+(void)setServerPath:(NSString *)serverPath andDeviceID:(NSString *)deviceID andUserID:(NSString*)userID;

@end
