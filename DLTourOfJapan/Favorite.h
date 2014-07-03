//
//  Favorite.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * favoriteID;
@property (nonatomic, retain) NSString * favoriteType;
@property (nonatomic, retain) NSString * favoriteName;

@end
