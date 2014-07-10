//
//  ZXYCalloutAnnotation.m
//  GasStations
//
//  Created by developer on 14-2-25.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "ZXYCalloutAnnotation.h"

@implementation ZXYCalloutAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
-(id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    self = [super init];
    if(self)
    {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}
-(void)setLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    _longitude = longitude;
    _latitude  = latitude;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}
@end
