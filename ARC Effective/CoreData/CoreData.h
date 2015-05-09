//
//  CoreData.h
//  ARC Effective
//
//  Created by zhangke on 15/5/9.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//



//Managed Object Model, 描述app的数据模型，包括，entity，attributes，relationship，fetch（请求数据），
//Managed Object Context，moc，操作全过程，上下文，
//Persistent Store Coordinator，持久化存储助理，处理底层的对数据的读取和写入
//Managed Object，被管理的数据对象
//Controller，关联

//vc查询－》MOC－》NSPersistentStoreCoordinator（NSManagedObjectModel）—》XML，SQLite－》查询出来NSManagedObject



//Managed Object Model
//NSManagedObjectModel	数据模型
//Entity	NSEntityDescription	抽象数据类型，相当于数据库中的表
//Property 	NSPropertyDescription	Entity 特性，相当于数据库表中的一列
//> Attribute	NSAttributeDescription	基本数值型属性（如Int16, BOOL, Date等类型的属性）
//> Relationship	NSRelationshipDescription	属性之间的关系
//> Fetched Property	NSFetchedPropertyDescription	查询属性（相当于数据库中的查询语句）



//NSManagedObjectContext 常用方法
//-save:	将数据对象保存到数据文件
//-deleteObject:	将一个数据对象标记为删除，但是要等到 Context 提交更改时才真正删除数据对象
//-executeFetchRequest: error:	执行 Fetch Request 并返回所有匹配的数据对象
//-objectWithID:	查询指定 Managed Object ID 的数据对象
//-undo	回滚最后一步操作，这是都 undo/redo 的支持
//-lock	加锁，常用于多线程以及创建事务。同类接口还有：-unlock and -tryLock
//-rollback	还原数据文件内容
//-reset	清除缓存的 Managed Objects。只应当在添加或删除 Persistent Stores 时使用
//-undoManager	返回当前 Context 所使用的 NSUndoManager


//NSPersistentStoreCoordinator 常用方法  PSC
//数据存储类型
//-addPersistentStoreForURL:configuration:URL:options:error:	装载数据存储，对应的卸载数据存储的接口为 -removePersistentStore:error:
//-migratePersistentStore:toURL:options:withType:error:	迁移数据存储，效果与 "save as"相似，但是操作成功后，
//迁移前的数据存储不可再使用
//-persistentStoreForURL:	返回指定路径的 Persistent Store
//-URLForPersistentStore:	返回指定 Persistent Store 的存储路径


//四，Fetch Requests
//
//NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
//[fetch setEntity: entity];
//[fetch setPredicate: predicate];
//[fetch setSortDescriptors: sortDescriptors];
//
//NSArray * results = [context executeFetchRequest:fetch error:nil];

//-setEntity:	设置你要查询的数据对象的类型（Entity）
//-setPredicate:	设置查询条件
//-setFetchLimit:	设置最大查询对象数目
//-setSortDescriptors:	设置查询结果的排序方法


//完全手动编写代码  也能编写model


//Core Data版本迁移
//第一步是判断是否需要进行数据迁移：
//第二步是创建一个Migration Manager对象：
//第三步是真正发生数据迁移：
//备份数据库，移动会数据库，看training代码
//****zk , 跨版本升级，更早的版本通过相邻版本的Mapping Model依次迁移过来，比较耗时，以此迁移，纪录当前版本号，挨个迁移
//手动进行数据迁移，手动指定某些属性增加 返回

//- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error
//{
//    float sourceVersion = [[[mapping userInfo] valueForKey:@"sourceVersion"] floatValue];
//    if(sourceVersion <= 0.9)
//    {
//        mapping = [TZMigrationHelper addAttributeMappingForDerivedRTFProperties:sInstance mapping:mapping propertyName:@"someProperty"];
//        mapping = [TZMigrationHelper addAttributeMappingForDerivedRTFProperties:sInstance mapping:mapping propertyName:@"anotherProperty"];
//        mapping = [TZMigrationHelper addAttributeMappingForDerivedRTFProperties:sInstance mapping:mapping propertyName:@"oneMoreProperty"];
//    }
//    return [super createDestinationInstancesForSourceInstance:sInstance entityMapping:mapping manager:manager error:error];
//}



//单个的moc，save－》psc－》sqlit，增删改，通知到fetchedResultController，—》controllerDidChangeContent

// 多线程，5.0之前的
//moc注册通知
//backMOC－》save－》changeNotication－》moc－mergeChangesFromContextDidSaveNotification－save－》fetchedResultController

//5.0后，虽然是自己save再调parentsave，内部应该还是和5.0之前一样，子线程save还是会通知到parent线程的 mergeChangesFromContextDidSaveNotification，合并变化
//mainMOC只负责UI通知

//backMOC—》save－》parent mainMOC （fetchVC） save－》parent backMOC－》save－》PSC


//[temporaryContext performBlock:^{
//    // do something that takes some time asynchronously using the temp context
//    
//    // push to parent
//    NSError *error;
//    if (![temporaryContext save:&amp;error])
//    {
//        // handle error
//    }
//    
//    // save parent to disk asynchronously
//    [mainMOC performBlock:^{
//        NSError *error;
//        if (![_temporaryContext save:&amp;error])
//        {
//            // handle error
//        }
//    }];
//}];






