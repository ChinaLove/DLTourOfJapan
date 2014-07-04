//
//  ZXYDownCIDOperation.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDownCIDOperation.h"
#import "LocDetailInfo.h"
@interface ZXYDownCIDOperation()
{
    NSMutableArray *firstArrToDown;
    NSMutableArray *needToDown;
    NSString *currentURL;
    BOOL isDownLoad;
    ZXYFileOperation *fileOperate;
    ZXYProvider *provider;
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
        provider = [ZXYProvider sharedInstance];
    }
    return self;
}

- (void)addURLTONeedToDown:(NSString *)needToDownURL
{
    //[needToDown insertObject:needToDownURL atIndex:0];
    [needToDown addObject:needToDownURL];
}

- (void)main
{
    while ((firstArrToDown.count + needToDown.count)>0)
    {
//        if(needToDown.count > 0)
//        {
//            //[firstArrToDown addObjectsFromArray:needToDown];
//            for(int i =0;i<needToDown.count;i++)
//            {
//                if([needToDown objectAtIndex:i])
//                {
//                    [firstArrToDown insertObject:[needToDown objectAtIndex:i] atIndex:0];
//                }
//            }
//            [needToDown removeAllObjects];
//        }
        if(!isDownLoad)
        {
            if(needToDown.count > 0)
            {
                //[firstArrToDown addObjectsFromArray:needToDown];
                for(int i =0;i<needToDown.count;i++)
                {
                    if([needToDown objectAtIndex:i])
                    {
                        [firstArrToDown insertObject:[needToDown objectAtIndex:i] atIndex:0];
                    }
                }
                [needToDown removeAllObjects];
            }

            isDownLoad = YES;
            if(firstArrToDown.count >0)
            {
                currentURL = [firstArrToDown objectAtIndex:0];
                NSString *filePath = [fileOperate cidImagePath:currentURL];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    
                    [firstArrToDown removeObject:currentURL];
                    currentURL = nil;
                    isDownLoad = NO;
                    continue;
                }
                else
                {
                    LocDetailInfo *loc = [[provider readCoreDataFromDB:@"LocDetailInfo" withContent:currentURL andKey:@"cid"] objectAtIndex:0];
                    NSURL *urlS = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Host,loc.locpy]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:urlS];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    operation.responseSerializer = [AFImageResponseSerializer serializer];
                    
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                    {
                        NSData *imageData = [operation responseData];
                        [imageData writeToFile:filePath atomically:YES];
                        
                        [firstArrToDown removeObject:currentURL];
                        currentURL = nil;
                        
                        NSNotification *addNoti = [[NSNotification alloc] initWithName:PlaceNotification object:self userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:addNoti];
                        isDownLoad = NO;
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        
                        [firstArrToDown removeObject:currentURL];
                        isDownLoad = NO;
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
