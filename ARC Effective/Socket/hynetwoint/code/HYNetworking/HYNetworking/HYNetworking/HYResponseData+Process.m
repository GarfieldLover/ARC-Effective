//
//  HYResponseDataProcess.m
//  HYNetworking
//
//  Created by zhangke on 13-4-18.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#define CONTENT @"content"
#define CURRENTTIME @"currentTime"
#define RESULT @"result"
#define SUCCESS @"SUCCESS"
#define FAILED @"FAILED"
#define ERRORMEG @"errorMsg"

#import "HYResponseData+Process.h"
#import "HYGIIPResponseData.h"

@implementation HYResponseData(Process)

+(HYResponseData*)responseDataProcessWithData:(HYResponseData*)data
{
    HYGIIPResponseData*  GIIPResponseData=[[HYGIIPResponseData alloc] init];
    if(data!=nil){
        GIIPResponseData.responseString=data.responseString;
        GIIPResponseData.responseData=data.responseData;
        GIIPResponseData.data=data.responseData;

        //不是下载文件接口，有字符串
        if(data.responseString!=nil){
            if([data.responseString isEqualToString:@"500"] || [data.responseString isEqualToString:@"401"] || [data.responseString isEqualToString:@"404"]){
                GIIPResponseData.result=giipError;
            }else if([data.responseString isEqualToString:@"当前无网络"]){
                GIIPResponseData.result=notConnection;
            }else if([data.responseString isEqualToString:@"当前网络异常，请稍后重试"]){
                GIIPResponseData.result=notProcess;
            }else{
                NSData* jsonData=[data.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                if([[jsonDic valueForKey:RESULT] isEqualToString:FAILED]){
                    GIIPResponseData.result=giipError;
                }else{
                    if([[jsonDic valueForKey:RESULT] isEqualToString:SUCCESS]){
                        GIIPResponseData.result=normalProcess;
                    }else{
                        GIIPResponseData.result=[[jsonDic valueForKey:RESULT] integerValue];
                    }
                    GIIPResponseData.time=[jsonDic valueForKey:CURRENTTIME];
                    GIIPResponseData.failReason=[jsonDic valueForKey:ERRORMEG];
                    GIIPResponseData.stringObject=[jsonDic valueForKey:CONTENT];
                }
            }
        }else{
            if(GIIPResponseData.data.length>0){
                GIIPResponseData.result=normalProcess;
            }
        }
    }
    return [GIIPResponseData autorelease];
}



@end
