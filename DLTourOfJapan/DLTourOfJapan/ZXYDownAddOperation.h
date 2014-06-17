//
//  ZXYDownAddOperation.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYDownAddOperation : NSOperation
- (id)initWithPicURLS:(NSArray *)array;
- (void)addURL:(NSURL *)picURL;
@end
