//
//  NetHelperDelegate.h
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPRequestOperation.h"
/**
  判断网络操作是否成功
 */
typedef enum
{
    requestCompleteFail = 0,
    requestCompleteSuccess ,
}requestCompleteFlag;

/**
  网络操作的代理方法
 */
@protocol NetHelperDelegate <NSObject>
- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object;
@end
