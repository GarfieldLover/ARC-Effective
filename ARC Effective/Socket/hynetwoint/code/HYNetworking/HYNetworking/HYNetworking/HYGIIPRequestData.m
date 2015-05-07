//
//  HYGIIPRequestData.m
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//


#import "HYGIIPRequestData.h"

static NSString* exceptionName=@"出现异常";

@implementation HYGIIPRequestData

@synthesize interfaceName;
@synthesize parameters;
//@synthesize userID;
@synthesize classInstance;


-(void)dealloc
{
    [classInstance release];
    [interfaceName release];
    [parameters release];
//    [userID release];    
    [super dealloc];
}

-(id)init
{
    self=[super init];
    if(self){
        //因为参数可能为nil，所以先设置为空字符串
        parameters=@"";
    }
    return self;
}

-(void)setInterfaceName:(NSString *)anyInterfaceName andParameters:(NSString *)anyParameters andUserID:(NSString *)anyUserID andRequestBody:(NSMutableDictionary*)anyRequestBody andClassInstance:(id)anyClassInstance;
{
    self.interfaceName=anyInterfaceName;
    self.parameters=anyParameters;
    self.userID=anyUserID;
    self.requestBody=anyRequestBody;
    self.classInstance=anyClassInstance;
}

-(HYNetworkData *)checkAndOrganizeRequestData
{
    NSString* serverPath=[[NSUserDefaults standardUserDefaults] valueForKey:@"serverPath"];
    NSString* deviceID=[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"];
    NSRange range=[serverPath rangeOfString:@"http://"];
    
    if((serverPath && range.location!=NSNotFound)==NO){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"serverPath为空或格式错误" userInfo:nil];
        @throw exception;
    }
    if(self.interfaceName==nil){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"interfaceName为空或格式错误" userInfo:nil];
        @throw exception;
    }
    range=[self.parameters rangeOfString:@" "];
    if(self.parameters!=nil && range.location!=NSNotFound){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"parameters格式错误" userInfo:nil];
        @throw exception;
    }
    if(self.userID==nil){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"userID为空" userInfo:nil];
        @throw exception;
    }
    if(deviceID==nil){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"deviceID为空" userInfo:nil];
        @throw exception;
    }
    
    if(serverPath && self.interfaceName && self.userID && deviceID){
        LOG(@"  检测参数完毕，执行组织HYNetworkData对象");
        HYNetworkData* data=[HYNetworkData networkData];
        data.URL=[self stitchGIIPURLWithPath:serverPath andDeviceID:deviceID];
        data.body=self.requestBody;
        data.classInstance=self.classInstance;
        data.interfaceName=self.interfaceName;
        return data;
    }
    return nil;
}

/*
 @method 根据传入的参数拼接url
 @param
 @return  返回url
*/
-(NSURL*)stitchGIIPURLWithPath:(NSString*)serverPath andDeviceID:(NSString*)deviceID
{
    NSString* mainURL=[serverPath stringByAppendingFormat:@"%@%@%@%@%@",@"/service?",
                       @"m=",self.interfaceName,@"&p=",self.parameters];
    NSString* md5=[mainURL MD5String];
    NSString* timeTmp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000];
    NSString* time=[[timeTmp componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString* tidString=[NSString stringWithFormat:@"u=%@&d=%@&t=%@&m=%@",self.userID,deviceID,time,md5];

    NSURL* url=[NSURL URLWithString:[mainURL stringByAppendingString:[self encryptTidString:tidString]]];
    LOG(@"  请求URL: %@",url);
    return url;
}

/*
 @method 使用加密工具类加密tid
 @param  tid字符串
 @return  返回加密后的字符串
*/
-(NSString*)encryptTidString:(NSString*)string
{
    NSString* tidBase64String= [[HYDataEncryption shareInstance] encryptRSAKeyWithType:KeyTypePublic plainText:string];
    if(tidBase64String==nil){
        NSException *exception =[NSException exceptionWithName:exceptionName reason:@"加密不成功，删除沙盒重试" userInfo:nil];
        @throw exception;
    }
    NSString* tidURLString =[@"&tid=" stringByAppendingString:[tidBase64String URLEncodedString]];
    return tidURLString;
}


@end
