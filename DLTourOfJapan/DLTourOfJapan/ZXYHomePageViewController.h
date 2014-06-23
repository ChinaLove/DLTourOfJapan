//
//  ZXYHomePageViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Advertise;
@protocol SelectHomePageItemDelegate <NSObject>
- (void)selectHomePageItem:(Advertise *)ad;
@end
@interface ZXYHomePageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollection;
@property (nonatomic,strong) id<SelectHomePageItemDelegate>delegate;
@end
