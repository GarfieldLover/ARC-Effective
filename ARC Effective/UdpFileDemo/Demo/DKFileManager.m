//
//  DKFileManager.m
//  wptt_iphoneManager
//
//  Created by 达 坤 on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKFileManager.h"

//一秒没接收，则响应代理函数
#define TIMEOUT     1.0

#define ROOT(path) [NSString stringWithFormat: @"%@/临时文件/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], (path)]

#define FILEINFOARRAY       @"file.info.array"

#define SAVEKEY_FILE_NAME       @"file.name"
#define SAVEKEY_FILE_TOTLE      @"file.totle"
#define SAVEKEY_FILE_RECV       @"file.recv"    //接收的大小

#define SAVEKEY_FILE_ARRAY          @"file.array"
#define SAVEKEY_FILE_ARRAY_START    @"file.start"
#define SAVEKEY_FILE_ARRAY_SIZE     @"file.size"
#define SAVEKEY_FILE_ARRAY_TEMP     @"file.temp.name"


#pragma mark -
#pragma mark DKFileManager的私有函数和变量的声明定义
@interface DKFileManager ()

@property (assign) dispatch_queue_t queue;
@property (assign) dispatch_group_t group;
@property (assign) int bInit;
//保存文件数据信息的数组
@property (atomic, retain) NSMutableArray *rootArray;
//计时器数组
@property (atomic, retain) NSMutableArray *timerArray;

- (NSTimer *) findNSTimer:(id) object;
- (void) stopNSTimer:(id) object;
- (void) runNSTimer:(id) object;

//初始化所有的变量
- (void) initAllVarable;
//私有函数
- (NSMutableDictionary *) findFileInfoInRootArray:(NSString*) name;
- (void) saveFileDataToTempPath:(NSString *) path data:(NSData *) data;

//保存备份信息
- (void) saveRootArrayToSqlite;
@end

#pragma mark -
#pragma mark DKFileManager的函数功能的实现
@implementation DKFileManager
@synthesize speed = _speed;
@synthesize bInit = _bInit;
@synthesize rootArray = _rootArray;
@synthesize delegate = _delegate;
@synthesize timerArray = _timerArray;
@synthesize queue = _queue;
@synthesize group = _group;

#pragma mark -
#pragma mark 端口监听函数

static DKFileManager *manager = nil;

+ (DKFileManager*)sharedManager
{
    @synchronized(self) {
        if (manager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
	{
        if (manager == nil) 
		{
            manager = [super allocWithZone:zone];

            //初始化
            [manager initAllVarable];
            
            return manager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void) dealloc
{
    [self saveRootArrayToSqlite];
    dispatch_release(_group);
    dispatch_release(_queue);
    
    if (_timerArray) 
    {
        for (NSTimer *timer in _timerArray) 
        {
            [timer invalidate];
        }
        [_timerArray removeAllObjects];
        [_timerArray release];
        _timerArray = nil;
    }
    if (_rootArray) {
        [_rootArray removeAllObjects];
        [_rootArray release];
        _rootArray = nil;
    }
    
    [super dealloc];
}

//初始化一些数据信息
- (void) initAllVarable
{
    if (_bInit) return;
    
    _bInit = YES;
    _speed = CELL_SIZE;
    _rootArray = [[NSMutableArray alloc] init];
    _timerArray = [[NSMutableArray alloc] init];
    
    _queue = dispatch_queue_create("dkFileManage.queue", 0);
    _group = dispatch_group_create();
    
    //读历史交互数据信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: FILEINFOARRAY];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey: FILEINFOARRAY];
    if (array) [_rootArray addObjectsFromArray: array];
    
    //生成一个临时文件路径
    if (![[NSFileManager defaultManager] fileExistsAtPath: ROOT(@"")])
    {
        //创建目录
        [[NSFileManager defaultManager] createDirectoryAtPath: ROOT(@"") 
                                  withIntermediateDirectories: NO 
                                                   attributes: nil
                                                        error: nil];
    }
}

#pragma mark -
#pragma mark 保存文件信息到数据库
- (void) saveRootArrayToSqlite
{
    [[NSUserDefaults standardUserDefaults] setObject: _rootArray 
                                              forKey: FILEINFOARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark 定时器管理
- (NSTimer *) findNSTimer:(id) object
{
    for (NSTimer *timer in _timerArray) 
    {
        if ([(NSString *)timer.userInfo isEqualToString:(NSString *) object])
        {
            return timer;
        }
    }
    
    return nil;
}

- (void) stopNSTimer:(id) object
{
    NSCondition *cond = [[NSCondition alloc] init];
    [cond lock];
    
    NSTimer *timer = [self findNSTimer: object];
    if (!timer) return ;
    
    [timer invalidate];
    [_timerArray removeObject: timer];
    [timer release];
    
    [cond unlock];
    [cond release];
}

- (void) runNSTimer:(id) object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSTimer* timer = [[NSTimer timerWithTimeInterval: TIMEOUT
                                                    target: self
                                                  selector: @selector(NSTimerOut:) 
                                                  userInfo: object 
                                                   repeats: NO] retain];
        [[NSRunLoop currentRunLoop] addTimer: timer 
                                     forMode: NSRunLoopCommonModes];
        [_timerArray addObject: timer];
    });
}

- (void) NSTimerOut:(NSTimer *) timer
{    
    //其他处理
    if ([_delegate respondsToSelector: @selector(dkFileManagerDidNoRecvData: 
                                                name:)]) 
    {
        [_delegate dkFileManagerDidNoRecvData: self 
                                         name: timer.userInfo];
    }
    
    //超时处理,
    [self stopNSTimer: timer.userInfo];
}

#pragma mark 删除某一个数据和临时文件
- (void) deleteTempData:(NSString *)name
{
    //用于设置文件块属性
    NSMutableDictionary *info = [self findFileInfoInRootArray: name];
    if (info) return;
    
    for (NSDictionary *dic in [info objectForKey: SAVEKEY_FILE_ARRAY])
    {
        NSString *temp = [NSString stringWithFormat: @"%@/%@", ROOT(name), [dic objectForKey: SAVEKEY_FILE_ARRAY_TEMP]];
        [[NSFileManager defaultManager] removeItemAtPath: temp error: nil];
    }
    
    [_rootArray removeObject: info];
}

//删除所有备份文件和信息
- (void) cleanCache
{
    for (NSDictionary *dic in _rootArray) 
    {
        [self deleteTempData: [dic objectForKey: SAVEKEY_FILE_NAME]];
    }
    
    //删除所有的信息
    [_rootArray removeAllObjects];
}

#pragma mark -
#pragma mark 返回文件数据信息
//获取文件数据接收状况信息
- (NSArray *) getFileManagerInfoArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in _rootArray) 
    {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        [temp setObject: [dic objectForKey: SAVEKEY_FILE_NAME] 
                 forKey: DKFILE_NAME];
        [temp setObject: [dic objectForKey: SAVEKEY_FILE_RECV] 
                 forKey: DKFILE_RECV];
        [temp setObject: [dic objectForKey: SAVEKEY_FILE_TOTLE] 
                 forKey: DKFILE_TOTLE];
        [array addObject: temp];
    }
    
    return array;
}

#pragma mark -
#pragma mark 发送或保存数据
//文件大小
- (unsigned long long) fileLength:(NSString*) path
{
    if (!path) return 0;
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];  
    unsigned long long size = [handle seekToEndOfFile];  
    [handle seekToFileOffset: 0];
    [handle closeFile]; 
    
    return size;
}

//找到文件的信息表，从保存的数据信息组中
//name：文件的名称
- (NSMutableDictionary *) findFileInfoInRootArray:(NSString*) name
{
    for (NSMutableDictionary *dic in _rootArray) 
    {
        if ([[dic objectForKey: SAVEKEY_FILE_NAME] isEqualToString: name]) 
        {
            return dic;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //设置一个文件块数组
    [dic setObject: [NSMutableArray array] forKey: SAVEKEY_FILE_ARRAY];
    //保存文件信息
    [_rootArray addObject: dic];
    
    return dic;
}

//保存文件到临时路径下
//path：临时文件的路径
//data: 文件块数据
- (void) saveFileDataToTempPath:(NSString *) path data:(NSData *) data
{
    if (!path || !data) return;
    
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath: path];  
    
    if (!file)  
    {
        //文件不存在时，将文件移到备份路径
        [data writeToFile: path atomically: YES];
        return;
    }
    
    //有则添加到文件后面
    [file seekToEndOfFile];  
    [file writeData: data];  
    [file seekToFileOffset: 0];
    [file closeFile];  
}

//
//合并数据，处理文件
//根据文件的起始位置和大小，名称，生成一个文件块信息表
//name: 保存的文件名称
//data: 文件块数据
//start: 文件块起始位置
//totle: 保存的文件的大小
- (NSMutableDictionary *) dictionaryFormInfo:(NSString *)name 
                                        start:(DKInt) start
                                         size:(DKInt) size 
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject: [NSNumber numberWithLong: start] 
            forKey: SAVEKEY_FILE_ARRAY_START];
    [dic setObject: [NSNumber numberWithLong: size]
            forKey: SAVEKEY_FILE_ARRAY_SIZE];
    
    NSString *newName = [NSString stringWithFormat: @"%@_%@", name, [NSNumber numberWithLong: start]];
    [dic setObject: newName forKey: SAVEKEY_FILE_ARRAY_TEMP];
    
    return dic;
}

- (void) dictionaryIntoRootArray:(NSMutableDictionary *) dic 
                            info:(NSMutableDictionary *) info 
                            data:(NSData *)data
{
    NSMutableArray *array = [info objectForKey: SAVEKEY_FILE_ARRAY];
    DKInt cellStart = [[dic objectForKey: SAVEKEY_FILE_ARRAY_START] longValue];

    for (int i = 0; i < [array count]; i++) 
    {
        NSMutableDictionary *temp = [array objectAtIndex: i];
        DKInt start = [[temp objectForKey: SAVEKEY_FILE_ARRAY_START] longValue];
        
        if (start > cellStart) 
        {
            //插入数据
            if (cellStart + [data length] == start) 
            {
                //合并两个数据块
                DKInt length = [[temp objectForKey: SAVEKEY_FILE_ARRAY_SIZE] longValue] + [data length];
                [temp setObject: [NSNumber numberWithLong: cellStart] 
                         forKey: SAVEKEY_FILE_ARRAY_START];
                [temp setObject: [NSNumber numberWithLong: length] 
                         forKey: SAVEKEY_FILE_ARRAY_SIZE];
                
                //保存数据
                //临时文件的名称
                NSString *oldName = [temp objectForKey: SAVEKEY_FILE_ARRAY_TEMP];
                NSString *newName = [dic objectForKey: SAVEKEY_FILE_ARRAY_TEMP];
                NSString *oldPath = [NSString stringWithFormat: @"%@/%@", ROOT([info objectForKey: SAVEKEY_FILE_NAME]), oldName];
                NSString *newPath = [NSString stringWithFormat: @"%@/%@", ROOT([info objectForKey: SAVEKEY_FILE_NAME]), newName];
                
                //保持数据
                [self saveFileDataToTempPath: newPath data:(NSData *) data];
                [self saveFileDataToTempPath: newPath data:(NSData *) [NSData dataWithContentsOfFile: oldPath]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSFileManager defaultManager] removeItemAtPath: ROOT(oldPath) error: nil];
                });
                
                [temp setObject: newName forKey: SAVEKEY_FILE_ARRAY_TEMP];
                
                //修改接收的数据
                DKInt size = [[info objectForKey: SAVEKEY_FILE_RECV] longValue]+[data length];
                [info setObject: [NSNumber numberWithLong: size] forKey: SAVEKEY_FILE_RECV];
            }
            else if (cellStart + [data length] > start) 
            {
                //错误的数据块
                NSLog(@"错误的数据块，丢弃");
            }
            else if (cellStart + [data length] < start) 
            {
                //保持数据
                [array insertObject: dic atIndex: i];
                
                NSString *newName = [dic objectForKey: SAVEKEY_FILE_ARRAY_TEMP];
                NSString *newPath = [NSString stringWithFormat: @"%@/%@", ROOT([info objectForKey: SAVEKEY_FILE_NAME]), newName];
                [self saveFileDataToTempPath: newPath data:(NSData *) data];
                
                //修改接收的数据
                DKInt size = [[info objectForKey: SAVEKEY_FILE_RECV] longValue]+[data length];
                [info setObject: [NSNumber numberWithLong: size] forKey: SAVEKEY_FILE_RECV];
            }
            
            return;
        }
        else if (start == cellStart) 
        {
            //重复的数据，丢弃
            NSLog(@"重复的数据，丢弃");
            return ;
        }
    }

    //添加到后面的位置
    NSMutableDictionary *temp = nil;
    if ([array count]) temp = [array objectAtIndex: [array count]-1];
    
    DKInt start = [[temp objectForKey: SAVEKEY_FILE_ARRAY_START] longValue];
    
    if (!temp || 
        start + [[temp objectForKey: SAVEKEY_FILE_ARRAY_SIZE] longValue] < cellStart)
    {
        //添到后面
        [array addObject: dic];
        
        NSString *newName = [dic objectForKey: SAVEKEY_FILE_ARRAY_TEMP];
        NSString *newPath = [NSString stringWithFormat: @"%@/%@", ROOT([info objectForKey: SAVEKEY_FILE_NAME]), newName];
        [self saveFileDataToTempPath: newPath data:(NSData *) data];
        
        //修改接收的数据
        DKInt size = [[info objectForKey: SAVEKEY_FILE_RECV] longValue]+[data length];
        [info setObject: [NSNumber numberWithLong: size] forKey: SAVEKEY_FILE_RECV];
    }
    else if (start + [[temp objectForKey: SAVEKEY_FILE_ARRAY_SIZE] longValue] == cellStart)
    {
        //合并两个数据块
        DKInt length = [[temp objectForKey: SAVEKEY_FILE_ARRAY_SIZE] longValue] + [data length];
        [temp setObject: [NSNumber numberWithLong: length] 
                 forKey: SAVEKEY_FILE_ARRAY_SIZE];
        
        //保存数据
        //临时文件的名称
        NSString *oldName = [temp objectForKey: SAVEKEY_FILE_ARRAY_TEMP];
        NSString *oldPath = [NSString stringWithFormat: @"%@/%@", ROOT([info objectForKey: SAVEKEY_FILE_NAME]), oldName];
        //保持数据
        [self saveFileDataToTempPath: oldPath data:(NSData *) data];

        //修改接收的数据
        DKInt size = [[info objectForKey: SAVEKEY_FILE_RECV] longValue]+[data length];
        [info setObject: [NSNumber numberWithLong: size] forKey: SAVEKEY_FILE_RECV];
    }
    else
    {
        NSLog(@"错误的数据块，丢弃");
    }
}

- (void) mergeFileData:(NSString *)name data:(NSData *) data 
                 start:(DKInt) start totle:(DKInt) totle
{
    //生成一个临时文件,已文件名称的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath: ROOT(name)])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath: ROOT(name) 
                                  withIntermediateDirectories: NO 
                                                   attributes: nil
                                                        error: nil];
    }
    
    dispatch_group_async(_group, _queue, ^{
        //用于设置文件块属性
        NSMutableDictionary *info = [self findFileInfoInRootArray: name];
        //文件的名称
        [info setObject: name forKey: SAVEKEY_FILE_NAME];
        //保存文件的总大小
        [info setObject: [NSNumber numberWithLong: totle]
                 forKey: SAVEKEY_FILE_TOTLE];
        
        //块信息
        NSMutableDictionary *dic = [self dictionaryFormInfo:name 
                                                      start: start 
                                                       size: [data length]];
        //整理数据
        [self dictionaryIntoRootArray: dic info: info data: data];
        
        //后续处理
        [self stopNSTimer: name];
        if ([[info objectForKey: SAVEKEY_FILE_TOTLE] longValue] == 
            [[info objectForKey: SAVEKEY_FILE_RECV] longValue]) 
        {
            //数据全部接收
            if ([_delegate respondsToSelector: @selector(dkFileManagerDidFinishRecvData:
                                                         name:)]) 
            {
                [_delegate dkFileManagerDidFinishRecvData: manager name: name];
            }
            return ;
        }
        
        [self runNSTimer: name];
    });
}
 
//保存临时数据到指定的路径
//temp: 临时文件的名称
//path: 要保存到的路径
//返回：保存正确返回 nil，否则返回一个缺少的块信息
- (void) saveTempDataIntoPath:(NSString *) name toPath:(NSString *) path
{
    dispatch_queue_t queue = dispatch_queue_create([name UTF8String], 0);
    
    dispatch_async(queue, ^{
        
        NSDictionary *root = [self findFileInfoInRootArray: name];
        NSMutableArray *array = [root objectForKey: SAVEKEY_FILE_ARRAY];
        BOOL bState = NO;
        NSMutableArray *lost = [NSMutableArray array];

        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary *dic = [array objectAtIndex: i];

            NSString *temp = [NSString stringWithFormat: @"%@/%@", ROOT(name), [dic objectForKey: SAVEKEY_FILE_ARRAY_TEMP]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath: path]) 
            {
                //第一个文件块
                if ([[dic objectForKey: SAVEKEY_FILE_ARRAY_START] longValue]) 
                {
                    //
                    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
                    [tmp setObject: [NSNumber numberWithLong: 0] 
                            forKey: DKFILE_START];
                    [tmp setObject: [NSNumber numberWithLong: [[dic objectForKey: SAVEKEY_FILE_ARRAY_START] intValue]] 
                            forKey: DKFILE_SIZE];
                    [lost addObject: tmp];
                    bState = YES;
                }
                else
                {
                    //正确保存数据
                    if (!bState) 
                    {
                        [self saveFileDataToTempPath: path data: [NSData dataWithContentsOfFile: temp]];
                        BOOL save = [[NSFileManager defaultManager] removeItemAtPath: temp error: nil];
                        NSLog(@"1. save = %d: temp = %@", save, temp);
                        //
                        [array removeObject: dic];
                        i--;
                        continue ;
                    }
                }
            }
            else
            {
                //其他块处理
                DKInt length = [self fileLength: path];
                if ([[dic objectForKey: SAVEKEY_FILE_ARRAY_START] longValue] == length)
                {
                    if (!bState) 
                    {
                        //正确保存数据
                        [self saveFileDataToTempPath: path data: [NSData dataWithContentsOfFile: temp]];
                        BOOL save = [[NSFileManager defaultManager] removeItemAtPath: temp error: nil];
                        NSLog(@"2. save = %d: temp = %@", save, temp);
                        //
                        [array removeObject: dic];
                        i--;
                        continue ;
                    }
                }
                else
                {
                    //错误了,则返回缺少的位置
                    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
                    [tmp setObject: [NSNumber numberWithLong: length] 
                            forKey: DKFILE_START];
                    [tmp setObject: [NSNumber numberWithLong: [[dic objectForKey: SAVEKEY_FILE_ARRAY_START] intValue] - length] 
                            forKey: DKFILE_SIZE];
                    bState = YES;
                    [lost addObject: tmp];
                }
            }
        }
        
        if (!bState) 
        {
            //删除保存的数据
            [_rootArray removeObject: root];
            //删除name的临时目录
            BOOL del = [[NSFileManager defaultManager] removeItemAtPath: ROOT(name) error: nil];
            NSLog(@"del = %d: temp = %@", del, ROOT(name));
            
            //保存完成
            if ([_delegate respondsToSelector: @selector(dkFileManagerDidFinishSaveData:name:)]) 
            {
                [_delegate dkFileManagerDidFinishSaveData: manager name: name];
            }
        }
        else
        {
            if ([_delegate respondsToSelector: @selector(dkFileManagerDidLostData:name:
                                                         array:)]) {
                [_delegate dkFileManagerDidLostData: self name: name array: lost];
            }
        }
    });
    
    dispatch_release(queue);
}

//拆分path指向的文件
- (void) splitFileData:(NSString *) path
{
    if (!path)
    {
        NSLog(@"UDPFileManageSendFile Failed!!!");
        return ;
    }

    //开启一个线程拆解数据
    [self catchFileSubData: path start: 0 size: [self fileLength: path]];
}

- (void) catchFileSubData:(NSString *) path start:(DKInt) start size:(DKInt) isize
{
    dispatch_queue_t queue = dispatch_queue_create([path UTF8String], 0);
    
    dispatch_async(queue, ^{
        
        DKInt index = start;
        DKInt length = [self fileLength: path];
        DKInt size = 0;
        int cell = 0;       //第几块
        
        if (start + isize > length) 
        {
            NSLog(@"error");
            return ;
        }
        
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];  
        if (!handle) {
            NSLog(@"not find file");
            return;
        }
        
        while (index < start + isize) 
        {
            if (index + _speed < length) 
            {
                index += _speed;
                size = _speed;
            }
            else
            {
                size = length-index;
                index = length;
            }
            
            [handle seekToFileOffset: (index-size)];
            NSData *data = [handle readDataOfLength:(NSUInteger) size];
            if ([_delegate respondsToSelector: @selector(dkFileManagerDidSendFileData:data:start:index:)])
            {
                //zk
                //4096bytes,读取4096字节发送
                //1字节（Byte）=8比特（bit）=8位

                [_delegate dkFileManagerDidSendFileData: self 
                                                   data: data
                                                  start: (index-size)
                                                  index: cell];
            }
            
            [NSThread sleepForTimeInterval: 0.1];
            cell++;
        }
        
        [handle closeFile];
    });
    dispatch_release(queue);
}


@end
