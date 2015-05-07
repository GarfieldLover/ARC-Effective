//
//  HYFile.h
//  HYNetworking
//
//  Created by zhangke on 13-4-10.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, retain) NSString * content_type;

@property (nonatomic, retain) NSString * create_user;
@property (nonatomic, retain) NSString * file_name;
@property (nonatomic, retain) NSString * file_path;
@property (nonatomic, retain) NSString * file_size;
@property (nonatomic, retain) NSString * groupid;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString* downloadstate;
@property (nonatomic, retain) NSString * target_field;
@property (nonatomic, retain) NSString * target_table;

@property (nonatomic, retain) NSString * update_user;
@property (nonatomic, retain) NSString * uploadstate;


@end
