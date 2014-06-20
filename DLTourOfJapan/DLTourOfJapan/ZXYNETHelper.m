//
//  ZXYNETHelper.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYNETHelper.h"
#import "Reachability.h"
#import "ZXYDownCIDOperation.h"
@interface ZXYNETHelper()
{
    NSMutableArray *allURL;
    NSMutableArray *placeURLARR;
    BOOL isPlaceImageDown;
    ZXYDownAddOperation *advertiseOperation;
    ZXYDownCIDOperation *cidOperation;
}
@end
@implementation ZXYNETHelper
static ZXYNETHelper *instance;
static NSOperationQueue *queue;
+ (ZXYNETHelper *)sharedSelf
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            return [[self alloc] init];
        }
    }
    return instance;
}

+ (NSOperationQueue *)getQueue
{
    if(queue == nil)
    {
        queue = [[NSOperationQueue alloc] init];
    }
    return queue;
}

+ (id)alloc
{
    @synchronized(self)
    {
        instance = [super alloc];
        return instance;
    }
    return nil;
}

// !!!:isNETConnect
+(BOOL)isNETConnect
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL flag;
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
        {
            // 没有网络连接
            flag = NO;
            break;
        }
        default:
        {
            flag = YES;
            break;
        }
    }
    return  flag;
}

- (void)requestStart:(NSString *)urlString withParams:(NSDictionary *)params bySerialize:(AFHTTPResponseSerializer *)serializer
{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = serializer;
    if(params==nil)
    {
        [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }
            
        }];
    }
    else
    {
        [operationManager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }
            
        }];
    }
}

- (void)advertiseURLADD:(NSURL *)url
{
    if(allURL.count == 0)
    {
        allURL = [[NSMutableArray alloc] init];
    }
    [allURL addObject:url];
}

- (void)startDownAdvertiseImage
{
    if(allURL.count == 0)
    {
        return;
    }
    if(advertiseOperation == nil)
    {
        advertiseOperation = [[ZXYDownAddOperation alloc] initWithPicURLS:allURL];
        [[ZXYNETHelper getQueue] addOperation:advertiseOperation];
    }
    [allURL removeAllObjects];
    
}

- (void)placeURLADD:(NSURL *)url
{
    if(!isPlaceImageDown)
    {
        if(placeURLARR.count == 0)
        {
            placeURLARR = [[NSMutableArray alloc] init];
        }
        [placeURLARR addObject:url];
    }
    else
    {
        if(cidOperation)
        {
            [cidOperation addURLTONeedToDown:url];
        }
    }
}

- (void)startDownPlaceImage
{
    if(cidOperation)
    {
        [queue cancelAllOperations];
        cidOperation = nil;
    }
    isPlaceImageDown = YES;
    if(cidOperation == nil)
    {
        cidOperation = [[ZXYDownCIDOperation alloc] initWithFirstArr:placeURLARR];
        [cidOperation setCompletionBlock:^{
            isPlaceImageDown = NO;
            
        }];
    }
    [[ZXYNETHelper getQueue] addOperation:cidOperation];
    
}
@end
