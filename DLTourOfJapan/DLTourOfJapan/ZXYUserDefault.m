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

-(BOOL)writeUserUpdateTimeDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:USERUPDATETIME];
    return YES;
}

- (BOOL)writeUserUpdateTimeString:(NSString *)stringDate
{
    [[NSUserDefaults standardUserDefaults] setObject:stringDate forKey:USERUPDATETIME];
    return YES;
}

- (NSString *)getUserDefaultUpdateTimeString
{
    NSString *timeString = [[NSUserDefaults standardUserDefaults] valueForKey:USERUPDATETIME];
    if(timeString == nil)
    {
        timeString = @"19700101";
    }
    return timeString;
}

- (NSDate *)getUserDefaultUpdateTime
{
    NSString *timeString = [self getUserDefaultUpdateTimeString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *currentDate = [formatter dateFromString:timeString];
    return currentDate;
}
@end
