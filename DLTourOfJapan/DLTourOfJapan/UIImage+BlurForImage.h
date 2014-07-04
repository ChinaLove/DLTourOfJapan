//
//  UIImage+BlurForImage.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurForImage)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
