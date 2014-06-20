//
//  ZXYPlaceLocalListViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXYPlaceLocalListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (id)initWIthLocType:(NSString *)locType;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end
