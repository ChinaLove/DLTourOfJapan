//
//  ZXYPlaceDetailViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-21.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocDetailInfo.h"
@interface ZXYPlaceDetailViewController : UIViewController
- (id)initWithLocDetail:(LocDetailInfo *)locDetail;
@property(assign)BOOL isAdvertise;
@end
