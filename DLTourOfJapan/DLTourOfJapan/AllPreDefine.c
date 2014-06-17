//
//  AllPreDefine.c
//  DLTourOfJapan
//
//  Created by developer on 14-6-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#include <stdio.h>

/**
 * 以下是手机版本宽高等
 *
 */
// !!!:以下是手机版本宽高等
#define Screen_height   [[UIScreen mainScreen] bounds].size.height /**< 获取屏幕高度 */
#define Screen_width    [[UIScreen mainScreen] bounds].size.width  /**< 获取屏幕宽度 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) /**< 判断是iphone5 */
#define CURRENTVERSION [[[UIDevice currentDevice] systemVersion] floatValue] /**< 获取当前iOS版本 */

/**
 * 以下是一些配置颜色
 *
 */
// !!!:以下是一些配置颜色
#define MainViewLblColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]/**< 首页、地点、优惠标签按下的颜色 */


/**
 * 以下是关于用户的全局常量
 *
 */
// !!!:以下是关于用户的全局常量allPreDefine
#define USERUPDATETIME @"allPreDefine_stringForUserUpdateTime"//key-->update
#define USERDEFAULTTIME @"19700101"                     //defaultTime
#define AdvertiseNotification @"advertiseImage"         //广告图片下载完成的通知
/**
 * 以下是服务器接口
 *
 */
// !!!:以下是服务器接口URL
#define URL_getAdvertise @"http://115.29.46.22:81/dalian100/index.php/InterFace/get_ad_info" /**< 取得所有广告的信息 */

#define URL_getLastVersion @"http://115.29.46.22:81/dalian100/index.php/InterFace/get_latest_version" /** < 取得最新版本跟新数据 */

#define URL_Host @"http://115.29.46.22:81/dalian100/"/** < host */