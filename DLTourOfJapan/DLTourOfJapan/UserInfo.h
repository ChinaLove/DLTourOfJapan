//
//  UserInfo.h
//  DLTourOfJapan
//
//  Created by developer on 14-7-3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userEmail;

@end
