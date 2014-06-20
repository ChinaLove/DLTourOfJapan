//
//  ZXYDownCIDOperation.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDownCIDOperation.h"
@interface ZXYDownCIDOperation()
{
    NSMutableArray *firstArrToDown;
    NSMutableArray *needToDown;
    NSURL *currentURL;
    BOOL isDownLoad;
    ZXYFileOperation *fileOperate;
}
@end

@implementation ZXYDownCIDOperation
- (id)initWithFirstArr:(NSMutableArray *)firstArr
{
    if(self = [super init])
    {
        firstArrToDown = [[NSMutableArray alloc] initWithArray:firstArr];
        needToDown     = [[NSMutableArray alloc] init];
        isDownLoad = NO;
        fileOperate = [ZXYFileOperation sharedSelf];
    }
    return self;
}

- (void)addURLTONeedToDown:(NSURL *)needToDownURL
{
    [needToDown addObject:needToDownURL];
}

- (void)main
{
    while ((firstArrToDown.count + needToDown.count)>0)
    {
        if(needToDown.count > 0)
        {
            [firstArrToDown addObjectsFromArray:needToDown];
            [needToDown removeAllObjects];
        }
        if(!isDownLoad)
        {
            isDownLoad = YES;
            if(firstArrToDown.count >0)
            {
                currentURL = [firstArrToDown objectAtIndex:0];
                NSString *filePath = [fileOperate cidImagePath:[currentURL absoluteString]];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    isDownLoad = NO;
                    [firstArrToDown removeObject:currentURL];
                    currentURL = nil;
                    continue;
                }
                else
                {
                    NSURLRequest *request = [NSURLRequest requestWithURL:currentURL];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    operation.responseSerializer = [AFImageResponseSerializer serializer];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                    {
                        NSData *imageData = [operation responseData];
                        [imageData writeToFile:filePath atomically:YES];
                        isDownLoad = NO;
                        [firstArrToDown removeObject:currentURL];
                        currentURL = nil;
                        NSNotification *addNoti = [[NSNotification alloc] initWithName:PlaceNotification object:self userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:addNoti];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        isDownLoad = NO;
                        [firstArrToDown removeObject:currentURL];
                        currentURL = nil;

                        NSLog(@"ZXYDownCIDOperation error is %@",error);
                    }];
                    [operation start];
                }
            }
        }
    }
}
@end
