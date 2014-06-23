//
//  ShowBigImageViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-23.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBigImageViewController : UIViewController<UIScrollViewDelegate,UITabBarDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *bigImageScroll;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
- (id)initWithImageData:(NSData *)imageData;
@end
