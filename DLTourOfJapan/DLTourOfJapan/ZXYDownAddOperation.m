//
//  ZXYDownAddOperation.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYDownAddOperation.h"
#import "Advertise.h"
#import "ZXYProvider.h"
@interface ZXYDownAddOperation()
{
    NSMutableArray *currentURLS;
    NSMutableArray *needToAddURLS;
    NSURL *currentDownURL;
    BOOL isThreadFree;
    ZXYFileOperation *fileOperation;
    ZXYProvider  *proVider;
}


@end
@implementation ZXYDownAddOperation
 - (id)initWithPicURLS:(NSArray *)array
{
    if(self = [super init])
    {
        currentURLS = [[NSMutableArray alloc] initWithArray:array];
        needToAddURLS = [[NSMutableArray alloc] init];
        isThreadFree = YES;
        fileOperation = [ZXYFileOperation sharedSelf];
        proVider = [[ZXYProvider alloc] init];
    }
    return self;
}

- (void)addURL:(NSURL *)picURL
{
    [needToAddURLS addObject:picURL];
}

- (void)main
{
    while((currentURLS.count+needToAddURLS.count)>0 )
    {
        if(isThreadFree)
        {
            isThreadFree = NO;
            currentDownURL = [currentURLS objectAtIndex:0];
            NSURLRequest *request = [NSURLRequest requestWithURL:currentDownURL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                [currentURLS removeObject:currentDownURL];
                NSData *imageData = [operation responseData];
                NSString *filePath = [fileOperation advertiseImagePath:[currentDownURL absoluteString]];
                [imageData writeToFile:filePath atomically:YES];
                currentDownURL = nil;
                [currentURLS addObjectsFromArray:needToAddURLS];
                
                isThreadFree = YES;
                NSNotification *addNoti = [[NSNotification alloc] initWithName:AdvertiseNotification object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:addNoti];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                [currentURLS removeObject:currentDownURL];
                 currentDownURL = nil;
                [currentURLS addObjectsFromArray:needToAddURLS];
                NSLog(@"error advertiseImageDown is %@",error);
                isThreadFree = YES;
            }];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            [operation start];
           
        }
    }
   
}
@end
