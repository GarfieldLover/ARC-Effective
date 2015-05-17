//
//  ViewController.m
//  fmdbtest
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


@interface ViewController ()

@property (nonatomic,strong) FMDatabaseQueue* dbQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.db"];
    NSLog(@"path = %@",path);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
#if 0
 
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result =  [db executeUpdate:@"create table if not exists testTable (id integer PRIMARY KEY AUTOINCREMENT, name text)"];
        NSLog(@"creare %@",result?@"success":@"fail");
    }];

    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (int i = 0; i < 500; i++) {
            [db executeUpdate:@"insert into testTable (name) values(?)",[NSString stringWithFormat:@"name-%d",i]];
            
        }
    }];
    
    
    
    //--->同步队列执行，同步串行队列执行，阻塞
    NSDate* one = [NSDate date];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (int i = 0; i < 1; i++) {
            [db executeUpdate:@"insert into testTable (name) values(?)",[NSString stringWithFormat:@"name-%d",i]];
            
        }
    }];
    NSDate* two = [NSDate date];
    
    NSTimeInterval first = [two timeIntervalSinceDate:one];
    NSLog(@"first = %lf",first);
    //first = 31.509634
    
    
    //可以看出来：使用事务处理就是将所有任务执行完成以后将结果一次性提交到数据库，如果此过程出现异常则会执行回滚操作，这样节省了大量的重复提交环节所浪费的时间。

    NSDate* three = [NSDate date];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = YES;
        for (int i = 0; i < 50000; i++) {
            result =  [db executeUpdate:@"insert into testTable (name) values(?)",[NSString stringWithFormat:@"name-%d",i]];
            if (!result) {
                NSLog(@"break");
                *rollback = YES;
                break;
            }
        }
        
    }];
    
    NSDate* four = [NSDate date];
    NSTimeInterval second = [four timeIntervalSinceDate:three];
    NSLog(@"second = %lf",second);
    //second = 0.352166
    
    
    NSDate* five = [NSDate date];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from testTable where id < 50000"];
    }];
    
    NSDate* six = [NSDate date];
    
    NSTimeInterval third = [six timeIntervalSinceDate:five];
    
    NSLog(@"third = %lf",third);
    //third = 0.028879
    
    
    NSDate* seven = [NSDate date];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"delete from testTable where  id >= 50000"];
    }];
    
    NSDate* eight = [NSDate date];
    
    NSTimeInterval fourth = [eight timeIntervalSinceDate:seven];
    NSLog(@"fourth = %lf",fourth);
    //fourth = 0.111418
    
    //因为前者浪费了大量的时间、人力物力花费在往返于北京和上海之间。同样这个道理也能用在我们的数据库操作上，下面是我自己对使用事务和不使用事务的两种测试：
    //sqlite本身是支持事务操作的，
    //使用事务处理就是将所有任务执行完成以后将结果一次性提交到数据库，如果此过程出现异常则会执行回滚操作，这样节省了大量的重复提交环节所浪费的时间
    //beginTransaction   commit
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL result = YES;
            for (int i = 500; i < 1000; i++) {
                result =  [db executeUpdate:@"insert into testTable (name) values(?)",[NSString stringWithFormat:@"name-%d",i]];
                if (!result) {
                    NSLog(@"break");
                    *rollback = YES;
                    break;
                }
            }
            
        }];
    });
    
    //以异步线程为准
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@",>>>>%@",[NSThread currentThread]);
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            for (int i = 0; i < 500; i++) {
                [db executeUpdate:@"insert into testTable (name) values(?)",[NSString stringWithFormat:@"name-%d",i]];
                NSLog(@"insertt");
            }
        }];

        
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@",>>>>%@",[NSThread currentThread]);
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            for (int i = 0; i < 500; i++) {
                [db executeQuery:@"select * from testTable"];
                NSLog(@"select");
            }
        }];
        
        
    });
#endif

    //------>同步执行的串行队列，不管到哪个线程也是串行的，所以读和写完全是分开的
    //事务执行会很快，省去了每次都提交，

    
    //如果我们的app需要多线程操作数据库，那么就需要使用FMDatabaseQueue来保证线程安全了。 切记不能在多个线程中共同一个FMDatabase对象并且在多个线程中同时使用，这个类本身不是线程安全的，这样使用会造成数据混乱等问题。
    
    //使用FMDatabaseQueue很简单，首先用一个数据库文件地址来初使化FMDatabaseQueue，然后就可以将一个闭包(block)传入inDatabase方法中。 在闭包中操作数据库，而不直接参与FMDatabase的管理。
    
    //－－－－》FMDatabaseQueue，线程安全，所有的数据库操作会在队列中顺序执行
    
    //在多个线程中同时使用一个FMDatabase实例是不明智的。现在你可以为每个线程创建一个FMDatabase对象。 不要让多个线程分享同一个实例，它无法在多个线程中同时使用。
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
