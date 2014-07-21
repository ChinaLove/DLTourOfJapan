//
//  ZXYPageDetailInfoCell.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-21.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPageDetailInfoCell.h"
@interface ZXYPageDetailInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *lowerLine;
@end
@implementation ZXYPageDetailInfoCell

- (void)awakeFromNib
{
    // Initialization code
    if(iPhone5)
    {
        NSLog(@"scale is %f",[UIScreen mainScreen].scale);
    }
    else
    {
        self.lowerLine.frame = CGRectMake(self.lowerLine.frame.origin.x, self.lowerLine.frame.origin.y-1, self.lowerLine.frame.size.width, self.lowerLine.frame.size.height+1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
   
}
@end
