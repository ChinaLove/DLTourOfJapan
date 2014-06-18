//
//  ZXYDBHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDBHelper.h"

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
    
}
@end
