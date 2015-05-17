//
//  ViewController.m
//  JsonParser
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "User.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString* string=@"{\"User\":[{\"UserID\":11, \"Name\":{\"FirstName\":\"Truly\",\"LastName\":\"Zhu\"}, \"Email\":\"zhuleipro◎hotmail.com\"},{\"UserID\":12, \"Name\":{\"FirstName\":\"Jeffrey\",\"LastName\":\"Richter\"}, \"Email\":\"xxx◎xxx.com\"},{\"UserID\":13, \"Name\":{\"FirstName\":\"Scott\",\"LastName\":\"Gu\"}, \"Email\":\"xxx2◎xxx2.com\"}]}";

    id object=[string objectFromJSONString];
    
    
    id neee= [self loadWithobject:object];
    
}


-(id)loadWithobject:(id)objectxxx
{
    id object=nil;
    
    
    if([objectxxx isKindOfClass:[NSArray class]]){
        
    }else if([objectxxx isKindOfClass:[NSDictionary class]]){
        NSDictionary* dic = (NSDictionary*)objectxxx;
        
        //typedef struct objc_class *Class;
        
        for(NSString* key in dic.allKeys){
            Class theComplexClass = objc_getClass([key cStringUsingEncoding:NSUTF8StringEncoding]);
            id values=[dic objectForKey:key];
            
            if([values isKindOfClass:[NSArray class]]){
                for(NSDictionary*  dicvalues in values){
                    
                    object=[[theComplexClass alloc] init];
                    
                    unsigned int outCount, i;
                    //获取当前实体类中所有属性名
                    objc_property_t *properties = class_copyPropertyList(theComplexClass, &outCount);
                    
                    for (i = 0; i < outCount; i++) {
                        
                        objc_property_t property = properties[i];
                        
                        NSString *propertyNameString =[[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding] ;
                        
                        id vvvvv= [dicvalues objectForKey:propertyNameString];
                        if([vvvvv isKindOfClass:[NSDictionary class]]){
                            [object setValue:[self loadWithobject:vvvvv] forKey:propertyNameString];

                        }else{
                            [object setValue:vvvvv forKey:propertyNameString];

                        }
                        
                        
                    }

                }
            }
            
        }
        
    }
    
    return object;

}




#if 0
- (NSString *)serializeObjectWithChildObjectsAndComplexArray:(id)complexObject :(NSArray*)childSimpleClasses :(NSArray*) childSimpleClassInArray
{
    NSString *complexClassName = NSStringFromClass([complexObject class]);
    
    const char *cComplexClassName = [complexClassName UTF8String];
    id theComplexClass = objc_getClass(cComplexClassName);
    
    unsigned int outCount, i;
    //获取当前实体类中所有属性名
    objc_property_t *properties = class_copyPropertyList(theComplexClass, &outCount);
    
    //存放所有普通类型的属性变量名
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    //存放所有数组类型的属性变量名
    NSMutableArray *childArrayPropertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    //存放所有数组类型变量对应的JSON字符串的
    NSMutableArray *childArrayJSONString  = [[NSMutableArray alloc] initWithCapacity:1];
    
    //存放所有数组类型的属性变量名
    NSMutableArray *childClassesPropertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    //存放所有数组类型变量对应的JSON字符串的
    NSMutableArray *childClassesJSONString  = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties;
        
        NSString *propertyNameString =[[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding] ;
        
        SEL tempSelector = NSSelectorFromString(propertyNameString);
        id tempValue = [complexObject performSelector:tempSelector];
        
        
        //如果目标实体类包含了嵌套实体类或者子实体类数组
        if (childSimpleClassInArray!=nil || childSimpleClasses!=nil) {
            
            //如果当前属性类型是数组
            if ([tempValue isKindOfClass:[NSArray class]]) {
                NSArray *tempChildArray = (NSArray*)tempValue;
                if ([tempChildArray count]>0) {
                    //判断当前数组是否是目标类型数组
                    int flag = 0;
                    for (int j=0; j<[childSimpleClassInArray count]; j++) {
                        //如果是目标类型数组,则改变flag的值
                        if ([[tempChildArray objectAtIndex:0] isKindOfClass:[childSimpleClassInArray objectAtIndex:j]]) {
                            flag = 1;
                            //则将属性变量名添加到childArrayPropertyNames
                            [childArrayPropertyNames addObject:propertyNameString];
                            
                            NSMutableString *tempChildString = [[NSMutableString alloc] init];
                            for (int m=0; m< [tempChildArray count]; m++) {
                                
                                if (m == 0) {
                                    [tempChildString appendFormat:@"["];
                                }
                                
                                //先序列化数组内单独， 在此可以针对不同情况修改第二,三个参数来递归调用
                                NSString *singleJSONStringInArray = [[SerializationComplexEntities sharedSerializer] serializeObjectWithChildObjectsAndComplexArray:[tempChildArray objectAtIndex:m] :childSimpleClasses :childSimpleClassInArray];
                                
                                if (singleJSONStringInArray!=nil) {
                                    [tempChildString appendFormat:singleJSONStringInArray];
                                }
                                
                                if (m!= [tempChildArray count]-1) {
                                    [tempChildString appendFormat:@","];
                                }
                                else {
                                    [tempChildString appendFormat:@"]"];
                                }
                                
                            }
                            //添加到存放子数组JSON字符串的数组里
                            [childArrayJSONString addObject:tempChildString];
                        }
                    }
                    //如果是普通类型的数组
                    if (flag == 0) {
                        //则将属性变量名添加到propertyNames
                        [propertyNames addObject:propertyNameString];
                    }
                }
                
            }
            //如果当前属性类型是除数组外的类型
            else {
                int isChildClass = 0;
                for (int p = 0; p < [childSimpleClasses count]; p++) {
                    //判断是否是目标嵌套实体类
                    if ([tempValue isKindOfClass:[childSimpleClasses objectAtIndex:p ]]) {
                        isChildClass = 1;
                        [childClassesPropertyNames addObject:propertyNameString];
                        
                        
                        //先序列化嵌套实体类， 在此可以针对不同情况修改第二个参数来递归调用
                        NSString *singleJSONStringInChildClasses = [[SerializationComplexEntities sharedSerializer] serializeObjectWithChildObject:tempValue:nil];
                        
                        //添加到存放嵌套实体类的JSON字符串的数组里
                        [childClassesJSONString addObject:singleJSONStringInChildClasses];
                        
                    }
                }
                //如果当前属性类型除数组和目标嵌套子实体类外的普通类型
                if (isChildClass==0) {
                    [propertyNames addObject:propertyNameString];
                }
                
            }
            
        }
        //如果目标实体类不包含子实体类数组，则直接添加变量名
        else {
            [propertyNames addObject:propertyNameString];
        }
    }
    
    //开始构造Dictionary
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //对所有子实体类数组
    for(NSString *key in childArrayPropertyNames)
    {
        //对数组变量的键值先暂时用一个字符串代替
        [finalDict setObject:[[NSString alloc] initWithFormat:@"NULL%@NULL",key] forKey:key];
    }
    
    //对所有子实体类数组
    for(NSString *key in childClassesPropertyNames)
    {
        //对数组变量的键值先暂时用一个字符串代替
        [finalDict setObject:[[NSString alloc] initWithFormat:@"NULL%@NULL",key] forKey:key];
    }
    
    for(NSString *key in propertyNames)
    {
        SEL selector = NSSelectorFromString(key);
        id value = [complexObject performSelector:selector];
        
        if (value == nil)
        {
            value = [NSNull null];
        }
        
        [finalDict setObject:value forKey:key];
    }
    //没替换字符串的初始JSON字符串
    NSMutableString *jsonString =[[NSMutableString alloc] initWithString: [[CJSONSerializer serializer] serializeDictionary:finalDict]];
    
    //将数组变量的键值字符串替换成之前序列化的字符串
    for(int m=0; m<childArrayJSONString.count; m++)
    {
        if ([childArrayJSONString objectAtIndex:m] !=nil) {
            
            NSString *tempStringToBeReplaced = [[NSString alloc] initWithFormat:@""NULL%@NULL"",[childArrayPropertyNames objectAtIndex:m]];
            jsonString = [[NSMutableString alloc] initWithString:[jsonString stringByReplacingOccurrencesOfString:tempStringToBeReplaced withString:[childArrayJSONString objectAtIndex:m]]];
            
        }      
        
    }
    
    //将数组变量的键值字符串替换成之前序列化的字符串
    for(int m=0; m<childClassesJSONString.count; m++)
    {
        if ([childClassesJSONString objectAtIndex:m] !=nil) {
            
            NSString *tempStringToBeReplaced = [[NSString alloc] initWithFormat:@""NULL%@NULL"",[childClassesPropertyNames objectAtIndex:m]];            
            jsonString = [[NSMutableString alloc] initWithString:[jsonString stringByReplacingOccurrencesOfString:tempStringToBeReplaced withString:[childClassesJSONString objectAtIndex:m]]];
            
        }      
        
    }
    
    return jsonString;
    
}
#endif


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
