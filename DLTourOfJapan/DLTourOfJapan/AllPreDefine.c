//
//  AllPreDefine.c
//  DLTourOfJapan
//
//  Created by developer on 14-6-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#include <stdio.h>
#define Screen_height   [[UIScreen mainScreen] bounds].size.height /**< 获取屏幕高度 */
#define Screen_width    [[UIScreen mainScreen] bounds].size.width  /**< 获取屏幕宽度 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) /**< 判断是iphone5 */
#define CURRENTVERSION [[[UIDevice currentDevice] systemVersion] floatValue] /**< 获取当前iOS版本 */
#define MainViewLblColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]/**< 首页、地点、优惠标签按下的颜色 */