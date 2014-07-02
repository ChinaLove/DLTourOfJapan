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
@end
