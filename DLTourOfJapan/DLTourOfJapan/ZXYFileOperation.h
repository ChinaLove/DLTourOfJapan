//
//  ZXYFileOperation.h
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYFileOperation : NSFileManager
/**
    实例化方法
 */
+(ZXYFileOperation *)sharedSelf;
/**
    获得沙河常用到德三个文件夹的目录
 */
-(NSString *)documentsPath;
-(NSString *)tempPath;
-(NSString *)cathePath;

/**
    创建文件以及文件夹
 */
-(BOOL)createFileAtPath:(NSString *)filePath isDirectory:(BOOL)isDirectory withData:(NSData *)fileData;
-(BOOL)createDirectoryAtPath:(NSString *)direcPath withBool:(BOOL)withB;

/**
 *  返回图片存储的路径
 *
 */
- (NSString *)advertiseImagePath:(NSString *)urlString;
- (NSString *)cidImagePath:(NSString *)urlString;
@end
