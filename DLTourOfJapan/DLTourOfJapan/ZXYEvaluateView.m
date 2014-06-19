//
//  ZXYEvaluateView.m
//  GasStations
//
//  Created by developer on 14-2-17.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "ZXYEvaluateView.h"

@implementation ZXYEvaluateView
@synthesize eVDatasource = _eVDatasource;
@synthesize eVDelegate   = _eVDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setEVDatasource:(id<ZXYEvaluateDatasource>)eVDatasource
{
    _eVDatasource = eVDatasource;
    self.numImg = [eVDatasource numberOfImagesInEvaluateView:self];
    NSDictionary *dataDic = [eVDatasource maxSAndLowSOfEvaluateView:self];
    maxValue = [(NSNumber *)[dataDic objectForKey:@"maxS"] floatValue];
    minValue = [(NSNumber *)[dataDic objectForKey:@"minS"] floatValue];
    currentValue = [(NSNumber *)[dataDic objectForKey:@"currS"] floatValue];
    NSString *imageEName = [eVDatasource evaluateViewTheNameOfEmptyImgAtIndex:self];
    lowwerView = [self addBackView:imageEName andNum:self.numImg];
    widthOfupperView = lowwerView.frame.size.width;
    NSString *imageFName = [eVDatasource evaluateViewTheNameOfFullImgAtIndex:self];
    upperView = [self addBackView:imageFName andNum:self.numImg];
    [self addSubview:lowwerView];
    upperView.frame = [self subFrameOfViewWith:maxValue andMinS:minValue byCurrS:currentValue withRadio:upperView.frame];
    [upperView setClipsToBounds:YES];
    NSLog(@"upperView y is %f self view is %f" ,upperView.frame.origin.y,self.frame.origin.y);
    [self addSubview:upperView];
    
}

- (void)setEVDelegate:(id<ZXYEvaluateDelegate>)eVDelegate
{
    _eVDelegate = eVDelegate;
    if([eVDelegate respondsToSelector:@selector(shouleUserChange:)])
    {
        if([eVDelegate shouleUserChange:self])
        {
            isChange = YES;
        }
        else
        {
            isChange = NO;
        }
    }
    
    if([eVDelegate respondsToSelector:@selector(shouldEvaluateTheScore:)])
    {
        if([eVDelegate shouldEvaluateTheScore:self])
        {
            shouldReturnScore = YES;
        }
        else
        {
            shouldReturnScore = NO;
        }
    }
}

- (CGRect)subFrameOfViewWith:(float)maxS andMinS:(float)minS byCurrS:(float)currS withRadio:(CGRect)frameWith
{
    float width = (currS/(maxS - minS))*frameWith.size.width;
    CGRect rect = CGRectMake(frameWith.origin.x, frameWith.origin.y, width, frameWith.size.height);
    return rect;
}

- (UIView *)addBackView:(NSString *)strName andNum:(NSInteger)num
{
    UIImage *image = [UIImage imageNamed:strName];
    UIView  *returnView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height)];
    returnView.backgroundColor = [UIColor clearColor];
    float sizeBlock = (returnView.frame.size.width)/num;
    for(int i = 0;i<num;i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectMake(i*(sizeBlock+1), 0, sizeBlock, sizeBlock);
        [returnView addSubview:imgView];
    }
    returnView.autoresizingMask = UIViewAutoresizingNone;
    return returnView;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!isChange)
    {
        return;
    }
    UITouch *selfTouch = [touches anyObject];
    CGPoint touchPoint = [selfTouch locationInView:upperView];
    NSLog(@"touch is %.2f     %.2f",touchPoint.x,touchPoint.y);
    CGRect rect = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
    if(CGRectContainsPoint(rect, touchPoint))
    {
        NSLog(@"HEllo");
        [self changeStart:touchPoint];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!isChange)
    {
        return;
    }
    UITouch *selfTouch = [touches anyObject];
    CGPoint touchPoint = [selfTouch locationInView:upperView];
    NSLog(@"touch is %.2f     %.2f",touchPoint.x,touchPoint.y);
    CGRect rect = CGRectMake(0,0, self.superview.frame.size.width, self.superview.frame.size.height);
    if(CGRectContainsPoint(rect, touchPoint))
    {
        NSLog(@"HEllo");
        [UIView transitionWithView:upperView
                          duration:0.2
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^
         {
             [self changeStart:touchPoint];
         }
                        completion:^(BOOL finished)
         {
             
         }];
    }
    
    
    
}

-(void)changeStart:(CGPoint)point
{
    NSLog(@" point.x is --->  %.2f",point.x);
    if (point.x<0) {
        point.x = 0;
    }
    if (point.x > widthOfupperView) {
        point.x = widthOfupperView;
    }
    upperView.frame = CGRectMake(upperView.frame.origin.x, 0, point.x, upperView.frame.size.height);
    if(shouldReturnScore)
    {
        float score = (point.x/widthOfupperView)*(maxValue - minValue);
        NSLog(@" upper.x is --->  %.2f",point.x);
        [_eVDelegate theScoreChange:score];
    }
}

-(void)reloadEvaluate
{
    if(upperView && lowwerView)
    {
        [upperView removeFromSuperview];
        [lowwerView removeFromSuperview];
        self.eVDatasource = _eVDatasource;
        self.eVDelegate   = _eVDelegate;
    }
}
@end
