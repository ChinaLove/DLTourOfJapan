//
//  AllPreDefine.c
//  DLTourOfJapan
//
//  Created by developer on 14-6-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#include <stdio.h>
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define CURRENTVERSION [[[UIDevice currentDevice] systemVersion] floatValue]