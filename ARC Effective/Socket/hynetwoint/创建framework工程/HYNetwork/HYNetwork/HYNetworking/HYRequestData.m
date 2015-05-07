//
//  HYRequestData.m
//  HYNetworking
//
//  Created by zhangke on 13-4-2.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import "HYRequestData.h"

@implementation HYRequestData
@synthesize requestBody;

-(void)dealloc
{
    [_serverPath release];
    [_deviceID release];
    [_userID release];
    [requestBody release];
    [super dealloc];
}


-(NSString*)getServerPath
{
    return _serverPath=[[NSUserDefaults standardUserDefaults] valueForKey:@"serverPath"];
}

-(void)setServerPath:(NSString *)serverPath
{
    if(_serverPath){
        [_serverPath release];
        _serverPath=nil;
    }
    _serverPath =[serverPath retain];
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:_serverPath forKey:@"serverPath"];
    LOG(@"  存储serverPath为：%@",_serverPath);
}

-(NSString*)getDeviceID
{
    return _deviceID=[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"];
}

-(void)setDeviceID:(NSString *)deviceID
{
    if(_deviceID){
        [_deviceID release];
        _deviceID=nil;
    }
    _deviceID =[deviceID retain];
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:deviceID forKey:@"deviceID"];
    LOG(@"  存储deviceID为：%@",_deviceID);
}

-(NSString*)getUserID
{
    return _userID=[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
}

-(void)setUserID:(NSString *)userID
{
    if(_userID){
        [_userID release];
        _userID=nil;
    }
    _userID =[userID retain];
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:_userID forKey:@"userID"];
    LOG(@"  存储userID为：%@",_userID);
}

+(void)setServerPath:(NSString *)serverPath andDeviceID:(NSString *)deviceID andUserID:(NSString*)userID
{
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:serverPath forKey:@"serverPath"];
    LOG(@"  存储serverPath为：%@",serverPath);
    
    [userDefault setValue:deviceID forKey:@"deviceID"];
    LOG(@"  存储deviceID为：%@",deviceID);
    
    [userDefault setValue:userID forKey:@"userID"];
    LOG(@"  存储userID为：%@",userID);
}


-(id)init
{
    self=[super init];
    if(self){
        requestBody=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(HYNetworkData*)checkAndOrganizeRequestData
{
    return nil;
}



@end
