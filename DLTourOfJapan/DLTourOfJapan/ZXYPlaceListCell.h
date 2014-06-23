//
//  ZXYPlaceListCell.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXYEvaluateView.h"
#import "LocDetailInfo.h"
@interface ZXYPlaceListCell : UITableViewCell

@property (nonatomic,strong)LocDetailInfo *locDetail;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *avgPrice;
@property (weak, nonatomic) IBOutlet UIImageView *isWifi;
@property (weak, nonatomic) IBOutlet UIImageView *isParking;
@property (weak, nonatomic) IBOutlet UIImageView *isSmoking;
@property (weak, nonatomic) IBOutlet UIImageView *isVisa;
@property (weak, nonatomic) IBOutlet UIImageView *isMaster;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImage;

@end
