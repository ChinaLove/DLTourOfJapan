//
//  UIImage+LCYResize.h
//  GasStations
//
//  Created by eagle on 14-2-18.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LCYResize)
/**
 *  将图片按照指定的大小进行裁剪
 *
 *  @param targetSize 裁剪后图片大小
 *
 *  @return 裁剪后的新图片
 */
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
