//
//  ZXYTourOfJapanHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYTourOfJapanHelper.h"
#import "UIImage+BlurForImage.h"
@implementation ZXYTourOfJapanHelper
+ (NSString *)toMyXML:(NSString *)fromString
{
    NSRange range = {1,fromString.length-2};
    NSString *xmlString = [fromString substringWithRange:range];
    return xmlString;
}

+ (BOOL)isUserLogin
{
    ZXYProvider *provider = [[ZXYProvider alloc] init];
    NSArray *userArr = [provider readCoreDataFromDB:@"UserInfo"];
    if(userArr.count > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)loginOut
{
    ZXYProvider *provider = [[ZXYProvider alloc] init];
    [provider deleteCoreDataFromDB:@"UserInfo"];
    [provider deleteCoreDataFromDB:@"Favorite"];
    [provider updateDataFormCoreData:@"LocDetailInfo" withContent:@"0" andKey:@"isfavored"];
}

+ (UIImage *)getScreenImage:(UIView *)currentView {
    // frame without status bar
    CGRect frame;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } else {
        frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    // begin image context
    UIGraphicsBeginImageContext(frame.size);
    // get current context
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // draw current view
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // clip context to frame
    CGContextClipToRect(currentContext, frame);
    // get resulting cropped screenshot
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    // end image context
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)getBlurredImage:(UIImage *)imageToBlur {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [imageToBlur applyBlurWithRadius:10.0f tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    }
    return imageToBlur;
}

@end
