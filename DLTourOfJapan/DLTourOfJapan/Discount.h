//
//  Discount.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Discount : NSManagedObject

@property (nonatomic, retain) NSString * locName;
@property (nonatomic, retain) NSString * chinesename;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * disType;
@property (nonatomic, retain) NSString * disID;
@property (nonatomic, retain) NSString * disPhone;
@property (nonatomic, retain) NSString * disH;
@property (nonatomic, retain) NSString * locpy;

@end
