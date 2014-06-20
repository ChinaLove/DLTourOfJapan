//
//  ZXYPlaceListCell.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPlaceListCell.h"
@interface ZXYPlaceListCell()


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *startS;
@end
@implementation ZXYPlaceListCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

}

- (void)drawRect:(CGRect)rect
{
    [self showStart];
    [super drawRect:rect];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)showStart
{
    int currentLevel = self.locDetail.level.intValue;
    for(int i = 0;i<currentLevel;i++)
    {
        UIImageView *tempImageView = [self.startS objectAtIndex:i];
        tempImageView.image = [UIImage imageNamed:@"placePage_start"];
        
    }
}
@end
