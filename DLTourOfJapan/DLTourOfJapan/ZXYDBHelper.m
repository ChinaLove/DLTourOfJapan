//
//  ZXYDBHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDBHelper.h"
#import "ZXYProvider.h"
@implementation ZXYDBHelper
static FMDatabase *db;
+(FMDatabase *)DBOpen
{
   if(db)
   {
       return db;
   }
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"jpindl" ofType:@"sqlite"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"jpindl.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = NO;
    if([fileManager fileExistsAtPath:writableDBPath] == NO)
    {
        success = [fileManager copyItemAtPath:bundlePath toPath:writableDBPath error:nil];
        if(success == YES)
        {
            
            db = [[FMDatabase alloc] initWithPath:writableDBPath];
            [db open];
            return db;

        }
    }
    
    db = [[FMDatabase alloc] initWithPath:writableDBPath];
    [db open];
    return db;
    
    
    
}

+(void)closeDB
{
    if(db)
    {
        [db close];
    }
}

+ (void)putDataToCoreData
{
    ZXYProvider *provider = [[ZXYProvider alloc] init];
    if([provider readCoreDataFromDB:@"LocDetailInfo"].count >0)
    {
        return;
    }
    [self putLocDetailInfoToCoreData];
}

+ (void)putLocDetailInfoToCoreData
{
    NSString *bundleString = [[NSBundle mainBundle] pathForResource:@"ZLOCDETAILINFO" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:bundleString];
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSMutableArray *saveNewArr = [[NSMutableArray alloc] init];
    // !!!:此处改写json数据的key与数据库中的key一致
    for(int i = 0;i<jsonArr.count;i++)
    {
        NSDictionary *jsonDic = [jsonArr objectAtIndex:i];
        NSMutableDictionary *saveNewDic = [[NSMutableDictionary alloc] init];
        for(int j=0;j<jsonDic.allKeys.count;j++)
        {
            NSString *keyString = [[jsonDic allKeys] objectAtIndex:j];
            NSString *valueString = [jsonDic valueForKey:keyString];
            NSString *saveNewString = [[keyString substringFromIndex:1] lowercaseString];
            [saveNewDic setObject:valueString forKey:saveNewString];
        }
        [saveNewArr addObject:saveNewDic];
        
    }
    ZXYProvider *provider = [ZXYProvider sharedInstance];
    [provider saveDataToCoreDataArr:saveNewArr withDBNam:@"LocDetailInfo" isDelete:YES groupByKey:@"cid"];
}
@end
