//
//  AppDelegate.h
//  Demo
//
//  Created by 达 坤 on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKFileManager.h"
#import "GCDAsyncUdpSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, DKFileManagerDelegate>
{
    GCDAsyncUdpSocket *sock;
    GCDAsyncUdpSocket *recv;
    
    dispatch_queue_t sockQueue;
    dispatch_queue_t recvQueue;

    GCDAsyncUdpSocket *testSocket;
    dispatch_queue_t testQueue;
    
    NSInteger length;
}

@property (strong, nonatomic) UIWindow *window;

@end
