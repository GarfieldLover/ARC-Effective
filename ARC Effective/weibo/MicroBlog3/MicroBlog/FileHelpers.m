//
//  FileHelpers.m
//  AAPinChe
//
//  Created by Reese on 13-1-17.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//

#import "FileHelpers.h"


//传入文件名，该函数会根据Documents目录的全路径，拼出文件的全路径
NSString *pathInDocumentDirectory(NSString *fileName){
    
    //获取沙盒中的文档目录
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    //从返回数组中得到第一个，也就是IOS应用沙盒中唯一的一个文档目录
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    //将传入的文件名加在目录路径后面并返回
    return [documentDirectory stringByAppendingPathComponent:fileName];
}
NSString *pathInCacheDirectory(NSString *fileName){
    //获取沙盒中的文档目录
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    
    //将传入的文件名加在目录路径后面并返回
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}
NSString *pathForURL(NSURL *aURL){
    return pathInCacheDirectory([NSString stringWithFormat:@"com.beifeng.ios/cachedimage-%u", [[aURL description] hash]]);
}

BOOL hasCachedImage(NSURL *aURL){
    
NSFileManager *fileManager=[NSFileManager defaultManager];
    
if ([fileManager fileExistsAtPath:pathForURL(aURL)]) {
    return YES;
}
else return NO;
    
}


NSString *hashCodeForURL(NSURL *aURL)
{
    return [NSString stringWithFormat:@"%u",[[aURL description]hash]];
}

MBAppDelegate* getAppDelegate()
{
    return [[UIApplication sharedApplication]delegate];
}
