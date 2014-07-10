//
//  ZXYAnnotationView.m
//  GasStations
//
//  Created by developer on 14-2-25.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "ZXYAnnotationView.h"
#define ARROWHEIGHT  5
@implementation ZXYAnnotationView
@synthesize contentView = _contentView;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, 200, 78);
        self.centerOffset = CGPointMake(0, -50);
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height-ARROWHEIGHT-10);
        
        [self addSubview:_contentView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
        [self drawLayerContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
}

- (void)drawArrow:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect);
    //CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect)-ARROWHEIGHT;
    CGContextMoveToPoint(context, midX+ARROWHEIGHT, maxY);
    CGContextAddLineToPoint(context,midX, maxY+ARROWHEIGHT);
    CGContextAddLineToPoint(context,midX-ARROWHEIGHT, maxY);
    
    CGContextAddArcToPoint(context, minX, maxY, minX, minY, 5);
    CGContextAddArcToPoint(context, minX, minY, maxX, minY, 5);
    CGContextAddArcToPoint(context, maxX, minY, maxX, maxY, 5);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, 5);
    CGContextClosePath(context);
}

- (void)drawLayerContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self drawArrow:context];
    CGContextFillPath(context);
}

@end
