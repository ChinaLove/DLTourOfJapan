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
#define vip_loginBtnColor [UIColor colorWithRed:57/255.0 green:102/255.0 blue:174/255.0 alpha:1]/**< 会员登录按钮的颜色*/
#define vip_loginBtnColorD [UIColor colorWithRed:0/255.0 green:76/255.0 blue:174/255.0 alpha:1]/**< 会员登录按钮的颜色*/

// !!!:以下是关于用户的全局常量allPreDefine
/**
 * 以下是关于用户的全局常量
 *
 */
#define LSPhoneNum @"041183704077"
#define CCPhoneNum @"18641144682";
#define USERUPDATETIME_AD @"allPreDefine_stringForUserUpdateTimeAD"//key-->update
#define USERUPDATETIME_DATA @"allPreDefine_stringForUserUpdateTimeDATA"
#define USERDEFAULTTIME @"19700101"//defaultTime
#define USERDEFAULTTIMEDATA @"20130709" //defaultData
#define AdvertiseNotification @"advertiseImage"         //广告图片下载完成的通知
#define PlaceNotification  @"placeImage"  // 地点数据下载图片完成的通知

/**
 * 以下是服务器接口
 *
 */
// !!!:以下是服务器接口URL
#define URL_getAdvertise @"http://115.29.46.22:81/dalian100/index.php/InterFace/get_ad_info" /**< 取得所有广告的信息 */

#define URL_getLastVersion @"http://115.29.46.22:81/dalian100/index.php/InterFace/get_latest_version" /** < 取得最新版本跟新数据 */

#define URL_Host @"http://115.29.46.22:81/dalian100/"/** < host */
#define URL_GetData @"http://115.29.46.22:81/dalian100/index.php/InterFace/get_datas"/** <取得商家数据 */
#define URL_Inner  @"http://115.29.46.22:81/dalian100/index.php/InterFace/dealWithEvent?"/** <注册使用 */
#define URL_Discount @"http://115.29.46.22:81/dalian100/index.php/InterFace/dealWithEvent?service=FavorableList&method=viewFavorableList&idsource=a&idlangid=3&idcity=2&date=2013-08-15#02:28&isRefresh=0&pagesize=10&pageno=1&iduser=59"