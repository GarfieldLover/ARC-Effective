//
//  ViewController.m
//  ARC Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#include <objc/objc-runtime.h>
@interface ViewController ()

@end

@implementation ViewController


+(BOOL)resolveInstanceMethod:(SEL)sel
{

}

-(id)forwardingTargetForSelector:(SEL)aSelector
{

}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{

}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    id obj=[[NSObject alloc] init];
    id temp=obj;
    id tempxx=temp;

    //__strong修饰符，引用技术加1
    NSLog(@"1 %p",obj);
    NSLog(@"2 %p",obj);
    NSLog(@"3 %p",temp);
    NSLog(@"4 %p",temp);
    
    id __strong obj1=[[NSObject alloc] init];
    
    @autoreleasepool {
        //arc  __autoreleasing 计数＋1
        //weak 不＋1
        id __autoreleasing o=obj1;
//        id __weak o=obj1;

    }
    
    //strong,计数为1，arc，weak直接释放
    self.obj11=[[NSObject alloc] init];

    NSLog(@"%@",self.obj11);
    
    
    
    
    //类，class，objc_class结构体
    
    //class指针，发消息就回去找class里的方法
    //typedef struct objc_object *id;
    
//    类与对象操作函数
//    动态创建类和对象
//    2.属性操作函数，主要包含以下函数，对象和集合类的映射
//    
//    成员变量、属性
//    关联对象(Associated Object)
//    
//    KVC
    
    //消息转发
    
    
//    objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
//    
//    // TODO: 针对特殊数据类型做处理
//    NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//    
//    ...
//    
//    [self setValue:obj forKey:propertyKey];
    
    
}





@end
