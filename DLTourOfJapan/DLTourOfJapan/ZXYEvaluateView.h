//
//  ZXYEvaluateView.h
//  GasStations
//
//  Created by developer on 14-2-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXYEvaluateDatasource;
@protocol ZXYEvaluateDelegate;
@interface ZXYEvaluateView : UIView
{
    @private
    id <ZXYEvaluateDelegate> eVDelegateS;
    id <ZXYEvaluateDatasource> eVDatasourceS;
    float maxValue;
    float minValue;
    float currentValue;
    float widthOfupperView;
    UIView *upperView;
    UIView *lowwerView;
    BOOL isChange;
    BOOL shouldReturnScore;
}

@property(nonatomic,assign,setter = setEVDelegate:)id <ZXYEvaluateDelegate> eVDelegate;
@property(nonatomic,assign,setter = setEVDatasource:)id <ZXYEvaluateDatasource> eVDatasource;
@property(assign)NSInteger numImg;
-(void)reloadEvaluate;
@end

@protocol ZXYEvaluateDelegate<NSObject>
@required
-(BOOL)shouldEvaluateTheScore:(ZXYEvaluateView *)eV;
-(BOOL)shouleUserChange:(ZXYEvaluateView *)eV;
-(void)theScoreChange:(float)score;
@end

@protocol ZXYEvaluateDatasource <NSObject>
@required
- (NSString *)evaluateViewTheNameOfFullImgAtIndex:(ZXYEvaluateView *)eV ;
- (NSString *)evaluateViewTheNameOfEmptyImgAtIndex:(ZXYEvaluateView *)eV ;
- (NSInteger)numberOfImagesInEvaluateView:(ZXYEvaluateView *)eV;
//key maxS for max score and minS for min score currS for current value;
- (NSDictionary *)maxSAndLowSOfEvaluateView:(ZXYEvaluateView *)eV ;
@end