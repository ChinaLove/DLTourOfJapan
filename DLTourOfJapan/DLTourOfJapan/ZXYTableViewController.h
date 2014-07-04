//
//  ZXYTableViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocDetailInfo;
@protocol SelectTableRow<NSObject>
- (void)selectRowOfTableView:(LocDetailInfo *)locDetail;
@end
@interface ZXYTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
- (void)setSearchString:(NSString *)searchString;
@property(nonatomic,strong)id<SelectTableRow>delegate;
@end
