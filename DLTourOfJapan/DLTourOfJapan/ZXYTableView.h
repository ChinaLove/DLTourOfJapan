//
//  ZXYTableView.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol closeDisDelegate<NSObject>
- (void)closeDisView;
@end
@interface ZXYTableView : UITableView
@property(nonatomic,strong)IBOutlet id<closeDisDelegate>closeDelegate;
@end
