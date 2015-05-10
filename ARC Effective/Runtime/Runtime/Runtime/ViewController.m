//
//  ViewController.m
//  Runtime
//
//  Created by zhangke on 15/5/10.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@class MyClass;


@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod1;

@end


@interface MyClass () {
    NSInteger       _instance1;
    
    NSString    *   _instance2;
}

@property (nonatomic, assign) NSUInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end


@implementation MyClass

+ (void)classMethod1 {
    
}

- (void)method1 {
    NSLog(@"call method method1");
}

- (void)method2 {
    
}

- (void)submethod1 {
    NSLog(@"run sub method1");
}


- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end






@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //oc动态语言，把很多编译和链接时做的事放到了运行时，更加灵活，消息转发，加方法等。
    //runtime，运行时系统就像操作系统一样，使所有正常运行，用c语言写的，使c语言有了面向对象能力
    
    //1.封装：对象就是由结构体封装来的，函数就是c函数，
    //2.找到消息接受者，runtime根据接受者能否响应做粗反应
    
    
    //-------类和对象
    //NSObject,    类由class表示，实际上是指向objc—class结构体指针，isa，
    
    //对于实例对象的描述，调用函数，都是通过isa—》get调的，meta－class是对clss的描述，类级别的东西
    //类实例对象自身就是个objc——class结构体对象
    
    
    //typedef struct objc_class *Class;
    

//    @interface NSObject <NSObject> {
//        Class isa  OBJC_ISA_AVAILABILITY;
//    }
    
    
    
//    struct objc_class {
//        Class isa  OBJC_ISA_AVAILABILITY;   自身里的isa指针－》metaclass 元类，就是类方法
//        
//#if !__OBJC2__
//        Class super_class                父类－》指向父类 ，如果是nsobject，为null                        OBJC2_UNAVAILABLE;
//        const char *name                类名                         OBJC2_UNAVAILABLE;
//        long version                                             OBJC2_UNAVAILABLE;
//        long info                                                OBJC2_UNAVAILABLE;
//        long instance_size                类的实例变量大小                       OBJC2_UNAVAILABLE;
//        struct objc_ivar_list *ivars          成员变量＊＊链表                   OBJC2_UNAVAILABLE;
//        struct objc_method_list **methodLists    方法＊＊链表                OBJC2_UNAVAILABLE;
//        struct objc_cache *cache                常用方法缓存 ，函数指针加入                 OBJC2_UNAVAILABLE;
//        struct objc_protocol_list *protocols       协议＊＊链表              OBJC2_UNAVAILABLE;
//#endif
//        
//    } OBJC2_UNAVAILABLE;
//    
    
    
//    /// Represents an instance of a class.
//    struct objc_object {
//        Class isa  OBJC_ISA_AVAILABILITY;      执行类的结构体，里边有super，method，vars
//    };
//    
//    /// A pointer to an instance of a class.
//    typedef struct objc_object *id;          类的实例结构体指针，发消息，isa找类对象，再找selector在method里的方法，，void *指针
    
    
//    objc_cache
//    buckets：指向Method数据结构指针的数组。
    
    //元类(Meta Class)
    //类对象的类，存储类的所有类方法，NSOject下的meta－calss都用NSObject的meta－class作为自己的父类，基类的meta—class指向自己，闭环了
    //root calss 和meta－calss都指向nil
    //实例的isa－》class  （   Class isa  OBJC_ISA_AVAILABILITY;） －》class meta；

    
    [self ex_registerClassPair];
    
    
    
    //－－－－－－类与对象操作函数，，全部是从class结构体中读取出来
    // 获取类的类名
    const char * class_getName ( Class cls );
    // 获取类的父类
    Class class_getSuperclass ( Class cls );
    // 获取实例大小
    size_t class_getInstanceSize ( Class cls );
    
    //变量
    // 获取类中实例成员变量的信息
    Ivar class_getInstanceVariable ( Class cls, const char *name );
    // 添加成员变量
    BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
    
    //属性
    // 获取指定的属性
    objc_property_t class_getProperty ( Class cls, const char *name );
    // 为类添加属性
    BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

    //方法
    // 获取实例方法
    Method class_getInstanceMethod ( Class cls, SEL name );
    // 获取类方法
    Method class_getClassMethod ( Class cls, SEL name );
    // 添加方法
    BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
    // 替代方法的实现
    IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
    
    //协议(objc_protocol_list)
    // 返回类实现的协议列表
    BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
    // 添加协议
    BOOL class_addProtocol ( Class cls, Protocol *protocol );
    
    
    
//    [self testgetMethod];
    
    MyClass* one=[[MyClass alloc] init];
    MyClass* two=[[MyClass alloc] init];
    
    //我说什么来着，实例的地址肯定不一样，包括变量(肯定不一样，因为alloc)，
    //但是。class  。superclass，metacalss，superclass metaclss，肯定一样，因为就是个类和类的类 的描述
    NSLog(@"\n%p,%p \n   %p,%p \n %p,%p \n  %p,%p \n  %p,%p", one,two, one.class,two.class,  one.superclass, two.superclass,objc_getMetaClass(class_getName(one.class)), objc_getMetaClass(class_getName(two.class)) ,  objc_getMetaClass(class_getName(one.superclass)), objc_getMetaClass(class_getName(two.superclass))  );
    
    
    
    //动态创建类和对象
    //能在运行时创建类和对象。
    
    // 创建一个新类和元类
    Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
    // 在应用中注册由objc_allocateClassPair创建的类
    void objc_registerClassPair ( Class cls );

    
//    [self createClass];
    
    // 创建类实例
    id class_createInstance ( Class cls, size_t extraBytes );
    
//    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
//    id str1 = [theObject init];
//    
//    NSLog(@"%@", [str1 class]);
//    
//    id str2 = [[NSString alloc] initWithString:@"test"];
//    NSLog(@"%@", [str2 class]);
    
    
    // 返回指定对象的一份拷贝
    id object_copy ( id obj, size_t size );
//    NSObject *a = [[NSObject alloc] init];
//    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
//    object_setClass(newB, MyClass.class);
//    object_dispose(a);
    
    
    // 返回给定对象的类名
    const char * object_getClassName ( id obj );
    
    // 返回对象的类
    Class object_getClass ( id obj );
    
    
    
    
    // 获取已注册的类定义的列表
    int objc_getClassList ( Class *buffer, int bufferCount );
    // 返回指定类的元类
    Class objc_getMetaClass ( const char *name );
    
    //class 描述对象注册都在一起，
#if 0
    int numClasses;
    Class * classes = NULL;
    
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = (Class*) malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        NSLog(@"number of classes: %d", numClasses);
        
        for (int i = 0; i < numClasses; i++) {
            
            Class cls = classes[i];
            NSLog(@"class name: %s %p", class_getName(cls),cls);
        }
        
        free(classes);
    }
#endif
    
    
//    objc_ivar_list，链表找各个var
//    typedef struct objc_ivar *Ivar;
//    
//    struct objc_ivar {
//        char *ivar_name                 OBJC2_UNAVAILABLE;  // 变量名
//        char *ivar_type                 OBJC2_UNAVAILABLE;  // 变量类型
//        int ivar_offset                 OBJC2_UNAVAILABLE;  // －－－－》基地址偏移字节，根据偏移找吧
//#ifdef __LP64__
//        int space                       OBJC2_UNAVAILABLE;
//#endif
//    }
    
    //objc_property_t是表示Objective-C声明的属性的类型
    typedef struct {
        const char *name;           // 特性名
        const char *value;          // 特性值
    } objc_property_attribute_t;
    
    [self setTapActionWithBlock:^{
    
    }];
    
//    static char myKey;
//    objc_setAssociatedObject(self, &myKey, anObject, OBJC_ASSOCIATION_RETAIN);
//    id anObject = objc_getAssociatedObject(self, &myKey);
    //，将传入的块对象连接到指定的key上
    
    
    
    
    //给分类动态添加属性，将传入的块对象连接到指定的key上
//    objc_setAssociatedObject(<#id object#>, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
//    objc_getAssociatedObject(<#id object#>, <#const void *key#>)
//    objc_removeAssociatedObjects(<#id object#>)
    
    
    // 获取成员变量名
    const char * ivar_getName ( Ivar v );
    
    // 获取成员变量类型编码
    const char * ivar_getTypeEncoding ( Ivar v );
    
    // 获取成员变量的偏移量
    ptrdiff_t ivar_getOffset ( Ivar v );
    
    
    // 获取属性名
    const char * property_getName ( objc_property_t property );
    
    // 获取属性特性描述字符串
    const char * property_getAttributes ( objc_property_t property );
    // 获取属性的特性列表
    objc_property_attribute_t * property_copyAttributeList ( objc_property_t property, unsigned int *outCount );

}

//json 解析里
//- (void)setDataWithDic:(NSDictionary *)dic
//{
//    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
//        
//        NSString *propertyKey = [self propertyForKey:key];
//        
//        if (propertyKey)
//        {
//            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
//            
//            // TODO: 针对特殊数据类型做处理
//            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//            
//            ...
//            
//            [self setValue:obj forKey:propertyKey];
//        }
//    }];
//}



const static NSString* kDTActionHandlerTapGestureKey=@"kDTActionHandlerTapGestureKey";
const static NSString* kDTActionHandlerTapBlockKey=@"kDTActionHandlerTapBlockKey";

- (void)setTapActionWithBlock:(void (^)(void))block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        //能体现出kDTActionHandlerTapBlockKey ，block给关联上了，直接取就行
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}



void TestMetaClass(id self, SEL _cmd) {
    
    NSLog(@"This objcet is %p", self);
    //实例－》class，就是类，superclass就是类的父类
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
        //本身就是个class，再取class就是metaclass，指向了nsobject的metaclass，isa元类指向了自身，super指向了nil。
    }
    //[NSObject class]，取了metaclass是有值的，metaclass的isa 指向了nil，
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

- (void)ex_registerClassPair {
    
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}


-(void)testgetMethod
{
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    
    Class cls = myClass.class;
    
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    
    NSLog(@"==========================================================");
    
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小，自己＋5个变量 －》》》》》  6*8=48字节
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================");
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");
}


-(void)createClass
{
    IMP imp_submethod1 = [MyClass methodForSelector:@selector(submethod1)];
    
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
//    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
//    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];
}




@end

