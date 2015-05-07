//
//  HYGIIPResponseData.h
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 该类为请求响应的具体业务派生类，该类中具体设定了
 返回给调用者的数据项和错误类型等。
 */

/*
 请求返回编号及说明
 */
typedef enum{
    notConnection =-2,                   //因为无网络发出去的请求失败
    notProcess = -1,                     /*没有处理:
                                          1.因为超时没有到达服务端;
                                          2.在请求队列里某一个请求出错，后续的不再处理
                                          3.默认为此 */
    normalProcess = 1,                   //正常处理
    tidError = 1000,                      //安全验证参数为空
    md5Error = 1001,                    //md5校验失败
    timestampError = 1002,              //时间戳验证失败
    deviceError = 1003,                  //设备被禁用
    deviceInexistence = 1004,            //设备未注册
    decryptError = 1005,                 //解密失败
    tidFormError = 1006,                //安全验证参数格式错误
    interfaceInexistence = 2001,          //接口不存在
    interfaceForbidden = 2002,           //接口被禁用
    interfaceDataTypeError = 2003,       //接口使用了不允许的返回数据类型
    interfaceUnusual= 2004,              //接口返回了未经允许的异常
    inputParamError = 3001,             //输入参数错误
    canNotAccess = 3002,               //业务系统不能访问
    internalError = 3003,                 //业务系统内部错误
    otherError = 3004,                   //其他未知接口内部异常
    giipError = 4001,                     //中间件未知异常   中间件错误，500，401，404，失败
    fileError  = 5001,                    //处理附件上传失败
    fileEncodeError = 5002,              //处理附件上传失败,不支持的编码
    
} GIIPRequestResult;


#import "HYResponseData.h"

@interface HYGIIPResponseData : HYResponseData

/*!
 返回的服务器时间  例："2013-01-01 12:12:12"
 */
@property (retain) NSString* time;

/*!
 返回的请求结果  例：normalProcess
 */
@property (assign) GIIPRequestResult result;

/*!
 返回的失败原因  例：@""md5校验失败""
 */
@property (retain) NSString* failReason;

/*!
 返回的stringObject数据
 */
@property (retain) id stringObject;

/*!
 返回的二进制数据
 */
@property (retain) NSData* data;


@end
