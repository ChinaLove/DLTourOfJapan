//
//  ZXYDBHelper.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface ZXYDBHelper : NSObject
+(FMDatabase *)DBOpen;
+(void)closeDB;
+(void)putDataToCoreData;
@end
