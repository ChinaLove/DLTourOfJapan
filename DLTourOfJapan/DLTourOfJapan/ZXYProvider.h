//
//  ZXYProvider.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZXYProvider : NSObject
{
    NSManagedObjectContext *childThreadManagedObjectContext;
}
/**
 @return 返回实例
 */
+(ZXYProvider *)sharedInstance;

/***
 @return 删除
 */
-(BOOL)deleteCoreDataFromDB:(NSString *)stringName;
-(BOOL)deleteCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content byKey:(NSString *)key;

/*******
 @return 读取
 */
-(NSArray *)readCoreDataFromDB:(NSString *)stringName;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContentNumber:(NSNumber *)content andKey:(NSString *)key;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key orderBy:(NSString *)keyOrder isDes:(BOOL)isDes;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName orderByKey:(NSString *)stringKey isDes:(BOOL)isDes;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName isDes:(BOOL)isDes orderByKey:(id) stringKey,... ;
-(NSArray *)readCoreDataFromDB:(NSString *)dbName formatString:(NSString *)format isDes:(BOOL)isDes orderByKey:(id) stringKey,...;
- (NSArray *)readCoreDataFromDB:(NSString *)stringName withLike:(NSString *)likeString;
// !!!:增加数据
/**
 *  增加一条数据，要保持字段与数据库一致
 */
-(BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName isDelete:(BOOL)isDelete;

/**
 *  增加一条数据，要保持字段与数据库一致 删除条件
 */
-(BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName isDelete:(BOOL)isDelete content:(NSString *)content withKey:(NSString *)key;

/**
 *  增加一组数据，要保持字段与数据库一致
 */
- (BOOL)saveDataToCoreDataArr:(NSArray *)arr withDBNam:(NSString *)dbName isDelete:(BOOL)isDelete;

/**
 *  增加一组数据，要保持字段与数据库一致 删除条件
 */
- (BOOL)saveDataToCoreDataArr:(NSArray *)arr withDBNam:(NSString *)dbName isDelete:(BOOL)isDelete groupByKey:(NSString *)key;

// !!!:修改数据
/**
 *  修改一组数据
 */
- (BOOL)updateDataFormCoreData:(NSString *)dbName withContent:(id)content andKey:(NSString *)key;
/**
 *  根据条件修改一条数据
 */
- (BOOL)updateDataFromCoreData:(NSString *)dbName withContent:(id)content andKey:(NSString *)key whereIS:(NSString *)predictString;
@end
