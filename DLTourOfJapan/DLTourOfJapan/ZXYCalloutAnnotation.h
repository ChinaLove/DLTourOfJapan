//
//  ZXYCalloutAnnotation.h
//  GasStations
//
//  Created by developer on 14-2-25.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ZXYCalloutAnnotation : NSObject<MKAnnotation>
{
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}
@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;
-(id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
-(void)setLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
@end
