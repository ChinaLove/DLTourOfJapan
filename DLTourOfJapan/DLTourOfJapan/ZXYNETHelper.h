//
//  ZXYNETHelper.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetHelperDelegate.h"
#import "ZXYDownAddOperation.h"
@interface ZXYNETHelper : NSObject
@property (nonatomic,strong)id<NetHelperDelegate>netHelperDelegate;
/**
 *判断网络有没有连接
 *
 *
 */
+(BOOL)isNETConnect;

/**
 *返回自身实例化对象
 *
 *
 */
+ (ZXYNETHelper *)sharedSelf;

/**
 *POST是否需要更新 ad,data
 *@param 需要传入类型
 *
 */
- (void)requestStart:(NSString *)urlString withParams:(NSDictionary *)params bySerialize:(AFHTTPResponseSerializer *)serializer;


/**
 *下载广告图片啊
 *
 *
 */
- (void)advertiseURLADD:(NSURL *)url;
- (void)startDownAdvertiseImage;

/**
 * 增加场所图片的url
 *
 *
 */
- (void)placeURLADD:(NSString *)url;

- (void)startDownPlaceImage;

- (void)cancelPlaceImageDown;
@end
