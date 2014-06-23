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

//- (void)layoutSubviews
//
//{
//    
//    [super layoutSubviews];
//    
//    self.backgroundColor = [UIColor clearColor];
//    
//    for (UIView *subview in self.subviews) {
//        
//        self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
//        
//        for (UIView *subview2 in subview.subviews) {
//            
//            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
//                
//                [subview bringSubviewToFront:subview2];
//                subview2.backgroundColor = [UIColor grayColor];
//                
//            }
//            
//        }
//        
//    }
//    
//}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    NSLog(@"table view cell willTransitionToState ");
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
            NSLog(@"按钮的子视图的类名:%@", NSStringFromClass([subview class]));
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                        subview.superview.backgroundColor = self.contentView.backgroundColor ;
            }
            if ([NSStringFromClass([subview class]) isEqualToString:@"UIView"]) {
                
            }else{
                
            }
        }
    }
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
