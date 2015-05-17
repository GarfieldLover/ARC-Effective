//
//  testRetain.m
//  GCD
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "testRetain.h"
#import "xunhuan.h"


@interface testRetain()

@property (nonatomic,strong) testBlock ablo;

@property (nonatomic,strong) xunhuan* block;

@end

@implementation testRetain

-(void)testblock
{
    self.dic=[NSMutableDictionary dictionary];
    
    
    self.block=[[xunhuan alloc] init];
    
    //3方循环，self－xunhuan－block－self
    __weak testRetain* weakself=self;
    
    //特么的全局就可以直接赋值，局部变量就不行
    
    NSString* xxxxstring=nil;
    __block NSMutableArray* array=nil;
    __block NSMutableDictionary* aaadic=weakself.dic;
    
    //特么的，是局部变量必须copy一份进入，全局变量跟着self已经进去了?
    //全局，局部，，，
    
    [self.block loadString:^(NSString* string, float process){
        [weakself.dic setObject:@"xxx" forKey:@"fff"];
        weakself.dic= [NSMutableDictionary new];
        
        _dic=[NSMutableDictionary new];
        [_dic setObject:@"xx" forKey:@"ff"];
        
//        xxxxstring=@"xxx";
        array =[NSMutableArray new];
        aaadic=[NSMutableDictionary new];
        [array addObject:[NSObject new]];
        
    }];
    
    //表面上看是带有局部变量的匿名函数，实际上它是oc对象，内部是结构体，
    //使用的时候一般都拷贝到堆上，但是要注意循环引用和修改局部变量加修饰
    //block_copy
    
    
    //特么的还是没有持有，GCD也不需要weak
    //但是需要__block，局部变量,全局的还是不用
    //－－－》就是局部变量需要加 __block存储域说明符，把变量存储到block结构体中
    __block NSMutableDictionary* bbbdic=nil;
    
    //静态，全局，静态全局，，，block转换后的c语言访问全局变量没有任何改变，直接使用
    static NSMutableDictionary* cccdic=nil;
//    extern NSMutableDictionary* ddddic;
    
    
    //gcd 和 usingblock不用copy
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dic setObject:@"xxx" forKey:@"fff"];
//        _dic=[NSMutableDictionary new];
        bbbdic=[NSMutableDictionary new];
        cccdic=[NSMutableDictionary new];
//        ddddic=[NSMutableDictionary new];
        
        
    });
    
    //只要有block用该__block变量，持有变量则存在，
    //arc下copy到堆上，强引用copy到堆上，异步使用
    
    [array enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL* stop){
        bbbdic=[NSMutableDictionary new];
        [self.dic setObject:@"xxx" forKey:@"fff"];

    }];
    
//
//    //－－》，必须是self去强引用了block，才循环
//    __weak testRetain* weakself=self;
//    self.ablo = ^(NSString* test , float process){
//        [weakself.dic setObject:@"xxx" forKey:@"fff"];
//
//    };
//    
//    self.ablo(@"xxx",0.4);
    
//    //arc 或 mrc ，手动copy或属性retain，启动block——copy  ->>>>>>

}

-(void)dealloc
{


}


@end
