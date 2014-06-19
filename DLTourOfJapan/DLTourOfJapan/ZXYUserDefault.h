//
//  ZXYUserDefault.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYUserDefault : NSObject
/**
 *  获取实例化对象
 *  @return 返回实例化对象
 */
+ (ZXYUserDefault *)sharedSelf;

/**
 *  返回本地更新时间
 *  @return 返回本地更新时间(NSDate)
 */
- (NSDate *)getUserDefaultUpdateTime:(NSString *)type;

/**
 *  返回本地更新时间
 *  @return 返回本地更新时间(NSString)
 */
- (NSString *)getUserDefaultUpdateTimeString:(NSString *)type;

/**
 *  保存本地更新时间
 *  @param 保存本地更新时间(NSString)
 */
- (BOOL)writeUserUpdateTimeString:(NSString *)stringDate andType:(NSString *)type;

/**
 *  保存本地更新时间
 *  @param 保存本地更新时间(NSDate)
 */
- (BOOL)writeUserUpdateTimeDate:(NSDate *)date andType:(NSString *)type;
@end
