//
//  DBManager.h
//  MyFMDB
//
//  Created by focusmedia on 14-8-27.
//  Copyright (c) 2014年 focusmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Time : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *inTime;
@property (nonatomic, strong) NSString *outTime;
@property (nonatomic, strong) NSString *iBeacon;
- (Time *)init;

@end
@interface DBManager : NSObject
+(id)shardSingleton;

- (void)creatTable;
- (BOOL)insertIfon:(Time *)time;
- (NSArray*)searchInfo;
- (BOOL)delInfo;


@end
