//
//  HYGIIPRequestData.h
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 针对giip中间件设置的请求数据派生类，添加了giip
 独有的属性，重写了基类方法。
 */

#import <Foundation/Foundation.h>
#import "HYRequestData.h"
#import "HYDataEncryption.h"
#import "HYNetworkConfig.h"

@interface HYGIIPRequestData : HYRequestData

/*!
 请求接口名,用作返回后判断是那个接口   例：uploadFile
 */
@property (retain) NSString* interfaceName;

/*!
 请求参数
 */
@property (retain) NSString* parameters;

/*!
 用户id   例：2000003352600
 */
//@property (retain) NSString* userID;

/*!
 任何类实例，当请求结果返回后可以直接操作该对象
 */
@property (retain) id classInstance;

/*!
 @method  设置接口名、p参数、tid中u参数、请求体内容、任意请求返回后处理类实例
 @param  
 @return
 */
-(void)setInterfaceName:(NSString*)anyInterfaceName andParameters:(NSString*)anyParameters
              andUserID:(NSString*)anyUserID andRequestBody:(NSMutableDictionary*)anyRequestBody
                    andClassInstance:(id)anyClassInstance;

/*!
 @method 检验和组织HYNetworkData类数据，对象级方法，直接调用
 @param
 @return  检验对象的serverPath、interface、deviceID、userID等参数，如果成功返回HYNetworkData类数据，否则返回nil
 */
-(HYNetworkData*)checkAndOrganizeRequestData;


@end
