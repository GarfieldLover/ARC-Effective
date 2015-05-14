//
//  FileHelpers.h
//  AAPinChe
//
//  Created by Reese on 13-1-17.
//  Copyright (c) 2013年 ibeifeng.com All rights reserved.
//  这是一个纯C函数，用于获取应用沙盒文件路径
//

#import <Foundation/Foundation.h>
#import "MBAppDelegate.h"

NSString *pathInDocumentDirectory(NSString *fileName);
NSString *pathInCacheDirectory(NSString *fileName);
NSString *pathForURL(NSURL *aURL);
NSString *hashCodeForURL(NSURL *aURL);
BOOL hasCachedImage(NSURL *aURL);
MBAppDelegate* getAppDelegate();

