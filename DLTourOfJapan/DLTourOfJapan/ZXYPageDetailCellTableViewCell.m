//
//  ZXYPageDetailCellTableViewCell.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-21.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPageDetailCellTableViewCell.h"
@interface ZXYPageDetailCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *upperLine;
@property (weak, nonatomic) IBOutlet UIImageView *lowwerLine;
    
@end
@implementation ZXYPageDetailCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    if(iPhone5)
    {
        
    }
    else
    {
        //self.upperLine.frame = CGRectMake(self.upperLine.frame.origin.x, self.upperLine.frame.origin.y, self.upperLine.frame.size.width, self.upperLine.frame.size.height+1);
        self.lowwerLine.frame = CGRectMake(self.lowwerLine.frame.origin.x, self.lowwerLine.frame.origin.y-1, self.lowwerLine.frame.size.width, self.lowwerLine.frame.size.height+1);
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
