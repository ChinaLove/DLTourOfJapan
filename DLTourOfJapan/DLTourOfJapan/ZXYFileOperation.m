//
//  ZXYFileOperation.m
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYFileOperation.h"
@implementation ZXYFileOperation
static ZXYFileOperation *fileOperation;
+(ZXYFileOperation *)sharedSelf
{
    @synchronized(self)
    {
        if(fileOperation == nil)
        {
            return [[self alloc] init];
        }
    }
    return fileOperation;
}

+(id)alloc
{
    @synchronized(self)
    {
        fileOperation = [super alloc];
        return fileOperation;
    }
    return nil;
}

-(NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)cathePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)tempPath
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

-(BOOL)createFileAtPath:(NSString *)filePath isDirectory:(BOOL)isDirectory withData:(NSData *)fileData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        NSLog(@"文件夹已经存在");
        return YES;
    }
    else
    {
        if([fileManager createFileAtPath:filePath contents:fileData attributes:nil])
        {
            return YES;
        }
        else
        {
            NSLog(@"error in createFileAtPath");
            return NO;
        }
        
    }
}

-(BOOL)createDirectoryAtPath:(NSString *)direcPath withBool:(BOOL)withB
{
    if([self fileExistsAtPath:direcPath isDirectory:&withB])
    {
        return YES;
    }
    else
    {
        if([self createDirectoryAtPath:direcPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (NSString *)advertiseImagePath:(NSString *)urlString
{
    NSString *tempPath = [self tempPath];
    NSString *cidImageDir = @"cidImageDir";
    NSString *file = [tempPath stringByAppendingPathComponent:cidImageDir];
    [self createDirectoryAtPath:file withBool:YES];
    NSString *fileName = [[urlString componentsSeparatedByString:@"/"] lastObject];
    NSString *returnString = [file stringByAppendingPathComponent:fileName];
    return returnString;
}

- (NSString *)cidImagePath:(NSString *)urlString
{
    NSString *tempPath = [self tempPath];
    NSString *cidImageDir = @"cidImageDirPlace";
    NSString *file = [tempPath stringByAppendingPathComponent:cidImageDir];
    [self createDirectoryAtPath:file withBool:YES];
    NSString *fileName = [[urlString componentsSeparatedByString:@"/"] lastObject];
    NSString *returnString = [file stringByAppendingPathComponent:fileName];
    return returnString;

}
@end
