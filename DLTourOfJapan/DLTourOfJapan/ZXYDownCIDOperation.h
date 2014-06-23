//
//  ZXYDownCIDOperation.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYDownCIDOperation : NSOperation
- (id)initWithFirstArr:(NSMutableArray *)firstArr;
- (void)addURLTONeedToDown:(NSString *)needToDownURL;
@end
