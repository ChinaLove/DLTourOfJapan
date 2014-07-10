//
//  ZXYAnnotationView.h
//  GasStations
//
//  Created by developer on 14-2-25.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ZXYAnnotationView : MKAnnotationView
{
    UIView *_contentView;
}
@property (nonatomic,strong)UIView *contentView;
@end
