//
//  ZXYFavorViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocDetailInfo;
@protocol SelectRowDelegate<NSObject>
- (void)selectRow:(LocDetailInfo *)locDetail;
@end
@interface ZXYFavorViewController : UIViewController
@property(nonatomic,strong)id<SelectRowDelegate>delegate;
@end
