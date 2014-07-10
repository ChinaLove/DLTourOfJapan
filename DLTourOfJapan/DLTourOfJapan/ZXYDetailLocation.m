//
//  ZXYDetailLocation.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-10.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDetailLocation.h"
#import "LocDetailInfo.h"
#import "MKBasicAnnotation.h"
#import "ZXYMKViewCell.h"
#import "ZXYAnnotationView.h"
#import "ZXYCalloutAnnotation.h"

@interface ZXYDetailLocation ()<MKMapViewDelegate>
{
    LocDetailInfo *suchLoc;
    MKMapView    *myMapView;
    ZXYCalloutAnnotation *calloutAnnotation;
    MKBasicAnnotation    *basicAnnotation;
    ZXYMKViewCell        *contentView;
    __weak IBOutlet UILabel *titleOfLabel;
}
- (IBAction)backView:(id)sender;
@end

@implementation ZXYDetailLocation

- (id)initWithLocDetial:(LocDetailInfo *)locDetail
{
    if(self = [super initWithNibName:@"ZXYDetailLocation" bundle:nil])
    {
        suchLoc = locDetail;
        _mapView = [[MKMapView alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    basicAnnotation = [[MKBasicAnnotation alloc] initWithLatitude:suchLoc.lat.floatValue andLongitude:suchLoc.lon.floatValue];
    NSLog(@"%@-->%@",suchLoc.lat,suchLoc.lon);
    _mapView = [[MKMapView alloc] init];
    [_mapView addAnnotation:basicAnnotation];
    MKCoordinateSpan span = {0.5,0.5};
    CLLocation *location = [[CLLocation alloc] initWithLatitude:suchLoc.lat.floatValue longitude:suchLoc.lon.floatValue];
    MKCoordinateRegion region = {location.coordinate,span};
    [_mapView setRegion:region];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:_mapView];
    titleOfLabel.text = suchLoc.locname;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _mapView.frame = CGRectMake(0, 87, self.view.frame.size.width, self.view.frame.size.height);;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(view.annotation == basicAnnotation)
    {
        if(calloutAnnotation == nil)
        {
            calloutAnnotation = [[ZXYCalloutAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        }
        else
        {
            calloutAnnotation.latitude = view.annotation.coordinate.latitude;
            calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
    }
    [mapView addAnnotation:calloutAnnotation];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (calloutAnnotation && ![view isKindOfClass:[ZXYCalloutAnnotation class]]) {
        if(calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude &&
           calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude){
            [mapView removeAnnotation:calloutAnnotation];
        }
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(annotation == calloutAnnotation)
    {
        ZXYAnnotationView *annotationView = (ZXYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
        if(!annotationView)
        {
            annotationView = [[ZXYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
            ZXYMKViewCell *cellView = (ZXYMKViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ZXYMKViewCell" owner:self options:nil]objectAtIndex:0];
            cellView.telLbl.text = suchLoc.phone;
            cellView.titleLbl.text = suchLoc.info_ad;
            cellView.addressLbl.text = suchLoc.locaddr_cn;
            [annotationView.contentView addSubview:cellView];
        }
        return annotationView;
    }
    else if(annotation == basicAnnotation )
    {
        MKAnnotationView *akAnnotation = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mkAnnotation"];
        if(akAnnotation == nil)
        {
            akAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mkAnnotation"];
            akAnnotation.image = [UIImage imageNamed:@"home.png"];
            akAnnotation.canShowCallout = NO;
        }
        return akAnnotation;
    }
    else
    {
        return nil;
    }
}


- (IBAction)backView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
