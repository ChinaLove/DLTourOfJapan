//
//  ZXYTableViewCell.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYTableViewCell.h"

@implementation ZXYTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.nameLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
