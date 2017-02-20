//
//  DBManager.m
//  MyFMDB
//
//  Created by focusmedia on 14-8-27.
//  Copyright (c) 2014年 focusmedia. All rights reserved.
//

#import "DBManager.h"

#define DBNAME    @"timeinfor.sqlite"
#define ID        @"id"
#define INTIME    @"intime"
#define OUTTIME   @"outtime"
#define IBEACON   @"ibeacon"
#define TABLENAME @"TIME"



@implementation DBManager

{
    FMDatabase *db;
}

+(id)shardSingleton
{
    static dispatch_once_t pred;
    static DBManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (NSString *)GetDBpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucument = [paths objectAtIndex:0];
    NSString *DBpath = [doucument stringByAppendingPathComponent:DBNAME];
    return DBpath;
}

- (void)creatTable
{
    db = [FMDatabase databaseWithPath:[self GetDBpath]];
    NSAssert(db, @"Unable to create FMDatabase object");
        if ([db open]) {
        NSString *creatsql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",TABLENAME,ID,INTIME,OUTTIME,IBEACON];
        BOOL re = [db executeUpdate:creatsql];
        
        if (re) {
            NSLog(@"success when create");
        }else {
            NSLog(@"erroe when create");
        }
        [db close];
    }
}

- (BOOL)insertIfon:(Time *)time
{
    BOOL execResultSuccess = NO;
//    db = [FMDatabase databaseWithPath:[self GetDBpath]];
    if ([db open]) {
        NSString *insertsql = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@')VALUES('%@','%@','%@')",TABLENAME,INTIME,OUTTIME,IBEACON,time.inTime,time.outTime,time.iBeacon];
        NSLog(@"tqwwweeeeeeeeeeeeeeeeest %@",time.iBeacon);
        
//        NSString *insertsql = [NSString stringWithFormat:@"insert into '%@'('%@','%@','%@')values('%@','%@','%@')",TABLENAME,INTIME,OUTTIME,IBEACON,time.inTime,time.outTime,time.iBeacon];
        
//        NSString *insertsql = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@')VALUES('%@','%@')",TABLENAME,INTIME,OUTTIME,time.inTime,time.outTime];
        BOOL re = [db executeUpdate:insertsql];
        if (re) {
            NSLog(@"success when insert");
            execResultSuccess = YES;
        } else {
            NSLog(@"error when insert");
        }
        
        [db close];
    }
    return execResultSuccess;
}
- (NSArray*)searchInfo
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
    db = [FMDatabase databaseWithPath:[self GetDBpath]];
    if ([db open]) {
        NSString *searchsql = [NSString stringWithFormat:@"SELECT * FROM '%@'",TABLENAME];
        FMResultSet *rl = [db executeQuery:searchsql];
        while ([rl next]) {
            Time *time = [[Time alloc] init];
            time.inTime = [rl stringForColumn:INTIME];
            time.outTime = [rl stringForColumn:OUTTIME];
            time.iBeacon = [rl stringForColumn:IBEACON];
            [arr addObject:time];
        }
        [db close];
    }
    NSArray *array = [NSArray arrayWithArray:arr];
    
    return array;
}
- (BOOL)delInfo
{
    BOOL execResultSuccess = NO;
    db = [FMDatabase databaseWithPath:[self GetDBpath]];
    if ([db open]) {
        NSString *delsql = [NSString stringWithFormat:@"delete * from '%@'",TABLENAME];
        BOOL re = [db executeUpdate:delsql];
        if (re) {
            NSLog(@"success when delete");
            execResultSuccess = YES;
        }
        else
        {
            NSLog(@"error when delete");
        }
        
        [db close];
    }
    
    return execResultSuccess;
}
@end
@implementation Time

@synthesize Id = _Id;
@synthesize inTime = _inTime;
@synthesize outTime = _outTime;
@synthesize iBeacon = _iBeacon;

- (Time *)init
{
    self = [super init];
    return self;
}

@end
