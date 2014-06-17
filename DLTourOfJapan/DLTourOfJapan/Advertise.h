//
//  Advertise.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Advertise : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * cid;
@property (nonatomic, retain) NSString * pic_url;

@end
