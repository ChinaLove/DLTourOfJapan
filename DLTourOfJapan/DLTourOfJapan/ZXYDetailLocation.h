//
//  ZXYDetailLocation.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-10.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class LocDetailInfo;
@interface ZXYDetailLocation : UIViewController
{
    MKMapView *_mapView;
}

- (id)initWithLocDetial:(LocDetailInfo *)locDetail;
@end
