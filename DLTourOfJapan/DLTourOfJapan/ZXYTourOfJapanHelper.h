//
//  ZXYTourOfJapanHelper.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYTourOfJapanHelper : NSObject
+ (NSString *)toMyXML:(NSString *)fromString;
+ (BOOL)isUserLogin;
+ (void)loginOut;
@end
