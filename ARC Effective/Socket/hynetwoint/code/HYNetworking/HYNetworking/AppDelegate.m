//
//  AppDelegate.m
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "AppDelegate.h"
#import "HYGIIPRequestData.h"
#import "File.h"
#import "HYGIIPResponseData.h"

#define HUIYPATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingString:@"/FILES/"]

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

#define ID @"ID"
#define T_FILES @"T_CTL_FILES"
#define GROUPID @"GROUPID"
#define FILE_NAME @"FILE_NAME"
#define FILE_PATH @"FILE_PATH"
#define FILE_SIZE @"FILE_SIZE"
#define TARGET_FIELD @"TARGET_FIELD"
#define TARGET_TABLE @"TARGET_TABLE"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //测试queryList2
    //    [self testqueryList];
        [self test];
    
    
    //测试testuploadFile
//    [self testuploadFile];
    
    //测试testQueueUpload
    //[self testQueueUpload];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)test
{
    HYNetworkEngine* net=[HYNetworkEngine shareHYNetworkEngine];
    net.delegate=self;

    [HYGIIPRequestData setServerPath:@"http://192.168.1.223:8888/giipms" andDeviceID:@"0FDBF30A-66D6-47F3-94A2-6225F23A1EAE" andUserID:@"11111"];
    
    
    HYGIIPRequestData* data=[[HYGIIPRequestData alloc] init];
    
    NSString* param=[[NSString stringWithFormat:@"gcid=%@",@"001"] URLEncodedString];
    [data setInterfaceName:@"PDS0002" andParameters:param andUserID:@"1111" andRequestBody:nil andClassInstance:Nil];
    
    HYNetworkData* networkData=[data checkAndOrganizeRequestData];
    [net startRequestWithNetworkData:networkData];
}



-(void)testqueryList
{
    HYNetworkEngine* net=[HYNetworkEngine shareHYNetworkEngine];
    net.delegate=self;
    
    //下边参数较固定，可以设置一次后，不用再每次设置
    [HYGIIPRequestData setServerPath:@"http://192.168.1.223:8888/giipms" andDeviceID:@"7ef2a9ec3b6a0d5092f32c45a57ffbb3"];
    
    
    HYGIIPRequestData* giipRequestdata = [[HYGIIPRequestData alloc] init];
    @try {
        [giipRequestdata setInterfaceName:@"R0001" andParameters:@"dxId=2000011384706"
                                andUserID:@"2000003352600" andRequestBody:nil andClassInstance:nil];
        
        //组织HYNetworkData对象
        HYNetworkData* networkData=[giipRequestdata checkAndOrganizeRequestData];
        //开始请求
        [net startRequestWithNetworkData:networkData];
    }
    @catch (NSException *exception) {
        //捕获并打印异常
        NSLog(@"%@",exception.description);
    }@finally {
        [giipRequestdata release];
    }
}

-(void)testuploadFile
{
    HYNetworkEngine* net=[HYNetworkEngine shareHYNetworkEngine];
    net.delegate=self;
//    [net redirectNSLogToDocumentFolder];
    
    [HYGIIPRequestData setServerPath:@"http://192.168.4.56:8989/gip" andDeviceID:@"f71abd6af5df863963bf7e6dd1c89ef7" andUserID:@"2000011384407"];
    
    NSMutableArray* uploadFileArray=[[NSMutableArray alloc] init];
    //    for(int i=0;i<3;i++){
    File* file=[[File alloc] init];
    file.id_=[NSString stringWithFormat:@"392C0EE-3B-9307-8022-F448D99P1X%dEG",4];
    file.groupid=@"9200095269875";
    file.target_table=@"T_STD_HUIYJY";
    file.target_field=@"NEIRONG_FILE";
    file.file_size=@"1111111";
    file.file_name=@"shigongrizhi.ipa";
    file.file_path=[[NSBundle mainBundle] pathForResource:@"shigongrizhi" ofType:@"ipa"];
    [uploadFileArray addObject:file];
    [file release];
    //    }
    
    HYGIIPRequestData* zip=[[HYGIIPRequestData alloc] init];
    [zip setInterfaceName:@"SDC0001" andParameters:Nil andUserID:@"2000011384407" andRequestBody:nil andClassInstance:nil];
    HYNetworkData* zipnetworkData=[zip checkAndOrganizeRequestData];
    [net startRequestWithNetworkData:zipnetworkData];
    [zip release];
    
//    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
//    HYGIIPRequestData* zip=[[HYGIIPRequestData alloc] init];
//    dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"2000011384407" ,@"directId",@"[]",@"jsonstr", nil];
//    [zip setInterfaceName:@"SDC0009" andParameters:nil andUserID:@"2000011384407" andRequestBody:dic andClassInstance:nil];
//    HYNetworkData* zipnetworkData=[zip checkAndOrganizeRequestData];
//    [net startRequestWithNetworkData:zipnetworkData];
//    [zip release];
    
    
//    for(File* file in uploadFileArray){
//        NSMutableDictionary* filesDic=[[NSMutableDictionary alloc] init];
//        [filesDic setValue:file.id_ forKey:ID];
//        [filesDic setValue:file.groupid forKey:GROUPID];
//        [filesDic setValue:file.file_name forKey:FILE_NAME];
//        [filesDic setValue:file.file_size forKey:FILE_SIZE];
//        [filesDic setValue:file.target_field forKey:TARGET_FIELD];
//        [filesDic setValue:file.target_table forKey:TARGET_TABLE];
//        
//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:filesDic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString* json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSMutableDictionary* bodyDic=[[NSMutableDictionary alloc] init];
//        [bodyDic setValue:json forKey:@"Content_json"];
//        [bodyDic setValue:file.file_path forKey:@"Content_data"];
//        
//        HYGIIPRequestData* data=[[HYGIIPRequestData alloc] init];
//        [data setInterfaceName:@"uploadFile" andParameters:nil andUserID:@"2000003352600"
//                andRequestBody:bodyDic andClassInstance:nil];
//        
//        HYNetworkData* networkData=[data checkAndOrganizeRequestData];
//        [net startRequestWithNetworkData:networkData];
//        
//        [json release];
//        [filesDic release];
//        [data release];
//        [bodyDic release];
//    }
//    [uploadFileArray release];
}

-(void)testQueueUpload
{
    HYNetworkEngine* net=[HYNetworkEngine shareHYNetworkEngine];
    net.delegate=self;
    
    NSMutableArray* dataArray=[[NSMutableArray alloc] init];
    for(int i=0;i<3;i++){
        NSMutableArray* uploadFileArray=[[NSMutableArray alloc] init];
        for(int j=0;j<5;j++){
            File* file=[[File alloc] init];
            file.id_=[NSString stringWithFormat:@"392C0EE-397B-930F-8722-F4P3D99P4X%dE%d",i,j];
            file.groupid=@"9200025269875";
            file.target_table=@"T_STD_HUIYJY";
            file.target_field=@"NEIRONG_FILE";
            file.file_size=@"11111";
            file.file_name=@"加载loading.png";
            file.file_path=[[NSBundle mainBundle] pathForResource:@"加载loading" ofType:@"png"];
            [uploadFileArray addObject:file];
        }
        [dataArray addObject:uploadFileArray];
        [uploadFileArray release];
    }
    
    for(NSArray* array in dataArray){
        NSMutableArray* uploadArray=[[NSMutableArray alloc] init];
        for(File* file in array){
            NSMutableDictionary* filesDic=[[NSMutableDictionary alloc] init];
            [filesDic setValue:file.id_ forKey:ID];
            [filesDic setValue:file.groupid forKey:GROUPID];
            [filesDic setValue:file.file_name forKey:FILE_NAME];
            [filesDic setValue:file.file_size forKey:FILE_SIZE];
            [filesDic setValue:file.target_field forKey:TARGET_FIELD];
            [filesDic setValue:file.target_table forKey:TARGET_TABLE];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:filesDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString* json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSMutableDictionary* bodyDic=[[NSMutableDictionary alloc] init];
            [bodyDic setValue:json forKey:@"Content_json"];
            [bodyDic setValue:file.file_path forKey:@"Content_data"];
            
            HYGIIPRequestData* data=[[HYGIIPRequestData alloc] init];
            [data setInterfaceName:@"uploadFile2" andParameters:nil andUserID:@"2000003352600"
                    andRequestBody:bodyDic andClassInstance:nil];
            
            HYNetworkData* networkData=[data checkAndOrganizeRequestData];
            [uploadArray addObject:networkData];
            
            [json release];
            [filesDic release];
            [data release];
        }
        [net startRequestWithNetworkDataArray:uploadArray];
        [uploadArray release];
    }
}

-(void)networkStarted:(HYNetworkData *)networkData andProcess:(CGFloat)process
{
    NSLog(@"%f",process);

    //请求开始后输出进度
    if([networkData.interfaceName isEqualToString:@"queryList2"]){
        NSLog(@"%f",process);
    }
}

-(void)networkDidFinish:(HYNetworkData *)networkData andData:(HYResponseData *)data
{
    //请求结束后返回HYResponseData对象，强转为子类后使用
    HYGIIPResponseData* giipdata=(HYGIIPResponseData*)data;
    //    NSLog(@"代理：result___________%d",giipdata.result);
    NSLog(@"%@",giipdata.responseString);
    //使用interfaceName判断返回的数据对应的接口，便于处理
    
    if([networkData.interfaceName isEqualToString:@"queryList2"]){
        
    }
}

-(void)queueStarted:(NSArray *)networkDataArray andProgress:(CGFloat)progress
{
    //请求开始后，输出进度,不再在networkStarted中输出进度
}

-(void)queueDidFinish:(NSArray *)networkDataArray andProgress:(CGFloat)progress
{
    //队列请求的结果在-(void)networkDidFinish:(HYNetworkData *)networkData andData:(HYResponseData *)data获取
    //队列请求结束后，如果progress为1，表明全部成功，否则，则有失败
}







@end
