//
//  ZXYTourOfJapanHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYTourOfJapanHelper.h"

@implementation ZXYTourOfJapanHelper
+ (NSString *)toMyXML:(NSString *)fromString
{
    NSRange range = {1,fromString.length-2};
    NSString *xmlString = [fromString substringWithRange:range];
    return xmlString;
}

+ (BOOL)isUserLogin
{
    ZXYProvider *provider = [[ZXYProvider alloc] init];
    NSArray *userArr = [provider readCoreDataFromDB:@"UserInfo"];
    if(userArr.count > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)loginOut
{
    ZXYProvider *provider = [[ZXYProvider alloc] init];
    [provider deleteCoreDataFromDB:@"UserInfo"];
    [provider deleteCoreDataFromDB:@"Favorite"];
    [provider updateDataFormCoreData:@"LocDetailInfo" withContent:@"0" andKey:@"isfavored"];
}
@end
