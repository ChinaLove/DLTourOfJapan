//
//  ZXYPlaceViewController.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlacePageBtnClickDelegate<NSObject>
- (void)clickBtnAt:(id)sender;
@end
@interface ZXYPlaceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOfBtn;
@property (nonatomic,strong)id<PlacePageBtnClickDelegate>delegate;
@end
