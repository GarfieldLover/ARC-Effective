//
//  DKFileManager.h
//  wptt_iphoneManager
//
//  Created by 达 坤 on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger DKInt;

#define CELL_SIZE 4*1024

#define DOC(path) [NSString stringWithFormat: @"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], (path)]

#define DKFILE_NAME     @"name"     //文件的名称
#define DKFILE_TOTLE    @"totle"    //文件的总共大小
#define DKFILE_RECV     @"recv"     //已接收的数据的大小
#define DKFILE_START    @"start"    //开始位置
#define DKFILE_SIZE     @"size"     //大小

@class DKFileManager;
@protocol DKFileManagerDelegate <NSObject>

//拆分的数据块代理
- (void) dkFileManagerDidSendFileData:(DKFileManager*) manager 
                                 data:(NSData *) data
                                start:(DKInt) start
                                index:(DKInt) index;
//dkFileManager不能接收到数据，超时
- (void) dkFileManagerDidNoRecvData:(DKFileManager*) manager 
                               name:(NSString *) name;
//dkFileManager接收数据完成
- (void) dkFileManagerDidFinishRecvData:(DKFileManager*) manager 
                                   name:(NSString *) name;
//dkFileManager保存文件数据完成
- (void) dkFileManagerDidFinishSaveData:(DKFileManager*) manager 
                                   name:(NSString *) name;
//dkFileManager缺失的部分
- (void) dkFileManagerDidLostData:(DKFileManager*) manager 
                             name:(NSString *) name
                              array:(NSArray *) lost;

@end

@interface DKFileManager : NSObject

//块的大小
@property (assign) int speed;
//代理
@property (assign) id<DKFileManagerDelegate> delegate;

+ (DKFileManager*)sharedManager;

- (void) cleanCache;
- (void) deleteTempData:(NSString *)name;

//文件长度
- (unsigned long long) fileLength:(NSString*) path;

- (NSArray *) getFileManagerInfoArray;

- (void) mergeFileData:(NSString *)name 
                 data:(NSData *) data 
                start:(DKInt) start
                totle:(DKInt) totle;
- (void) splitFileData:(NSString *) path;
- (void) catchFileSubData:(NSString *) path start:(DKInt) start size:(DKInt) size;

- (void) saveTempDataIntoPath:(NSString *) name toPath:(NSString *) path;

@end
