//
//  ZXYUserDefault.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYUserDefault.h"

@implementation ZXYUserDefault
static ZXYUserDefault *userDefault;
+ (ZXYUserDefault *)sharedSelf
{
    @synchronized(self)
    {
        if(userDefault == nil)
        {
            return [[self alloc] init];
        }
    }
    return userDefault;
}

+ (id)alloc
{
    @synchronized(self)
    {
        userDefault = [super alloc];
        return userDefault;
    }
    return nil;
}

-(BOOL)writeUserUpdateTimeDate:(NSDate *)date andType:(NSString *)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:type];
    return YES;
}

- (BOOL)writeUserUpdateTimeString:(NSString *)stringDate andType:(NSString *)type
{
    [[NSUserDefaults standardUserDefaults] setObject:stringDate forKey:type];
    return YES;
}

- (NSString *)getUserDefaultUpdateTimeString:(NSString *)type
{
    NSString *timeString = [[NSUserDefaults standardUserDefaults] valueForKey:type];
    if(timeString == nil)
    {
        if([type isEqualToString:USERUPDATETIME_AD])
        {
            timeString = @"19700101";
        }
        else
        {
            timeString = @"20130709";
        }
    }
    return timeString;
}

- (NSDate *)getUserDefaultUpdateTime:(NSString *)type
{
    NSString *timeString = [self getUserDefaultUpdateTimeString:type];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *currentDate = [formatter dateFromString:timeString];
    return currentDate;
}
@end
