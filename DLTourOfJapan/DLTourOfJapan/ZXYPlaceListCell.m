//
//  ZXYPlaceListCell.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPlaceListCell.h"

@implementation ZXYPlaceListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.zxyEvaluates = [[ZXYEvaluateView alloc] initWithFrame:CGRectMake(0, 0, self.zxyEvaluate.frame.size.width, self.zxyEvaluate.frame.size.height)];
    self.zxyEvaluates.eVDelegate = self;
    self.zxyEvaluates.eVDatasource = self;
    [self.zxyEvaluate addSubview:self.zxyEvaluates];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)evaluateViewTheNameOfFullImgAtIndex:(ZXYEvaluateView *)eV
{
    return @"placePage_start.png";
}

- (NSString *)evaluateViewTheNameOfEmptyImgAtIndex:(ZXYEvaluateView *)eV
{
    return @"placePage_startHole.png";
}

- (NSInteger)numberOfImagesInEvaluateView:(ZXYEvaluateView *)eV
{
    return  5;
}
//key maxS for max score and minS for min score currS for current value;
- (NSDictionary *)maxSAndLowSOfEvaluateView:(ZXYEvaluateView *)eV
{
    NSNumber *maxS = [NSNumber numberWithInt:5];
    NSNumber *current = [NSNumber numberWithInt:self.locDetail.level.intValue];
    NSNumber *minS = [NSNumber numberWithInt:0];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:maxS,@"maxS",minS,@"minS",current,@"current", nil];
    return dic;
}

- (BOOL)shouleUserChange:(ZXYEvaluateView *)eV
{
    return NO;
}
@end
