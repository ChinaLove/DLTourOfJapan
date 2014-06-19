//
//  ZXYProvider.m
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYProvider.h"
#import "ZXYAppDelegate.h"
@implementation ZXYProvider
static ZXYProvider *instance = nil;
+ (ZXYProvider *)sharedInstance
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

+ (id)alloc
{
    @synchronized(self)
    {
        instance = [super alloc];
        return instance;
    }
    return nil;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    ZXYAppDelegate *ad = (ZXYAppDelegate *)[UIApplication sharedApplication].delegate;
    return [ad persistentStoreCoordinator];
}

- (NSManagedObjectContext *)childThreadContext
{
    if (childThreadManagedObjectContext != nil)
    {
        return childThreadManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        childThreadManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [childThreadManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    else
    {
        NSLog(@"create child thread managed object context failed!");
    }
    
    [childThreadManagedObjectContext setStalenessInterval:0.0];
    [childThreadManagedObjectContext setMergePolicy:NSOverwriteMergePolicy];
    
    return childThreadManagedObjectContext;
}


#pragma mark - delete
-(BOOL)deleteCoreDataFromDB:(NSString *)stringName
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSArray *deleteObjects = [self readCoreDataFromDB:stringName];
    NSError *error;
    for(int i = 0;i<deleteObjects.count;i++)
    {
        NSManagedObject *deleteObject = [deleteObjects objectAtIndex:i];
        [manageContext deleteObject:deleteObject];
    }
    if([manageContext save:&error])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)deleteCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content byKey:(NSString *)key
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSArray *deleteObjects = [self readCoreDataFromDB:stringName withContent:content andKey:key];
    NSError *error;
    for(int i = 0;i<deleteObjects.count;i++)
    {
        NSManagedObject *deleteObject = [deleteObjects objectAtIndex:i];
        [manageContext deleteObject:deleteObject];
    }
    if([manageContext save:&error])
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
#pragma mark - read
- (NSArray *)readCoreDataFromDB:(NSString *)stringName
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }
}

-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(key != nil || content!=nil)
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@==\'%@\'",key,content];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
        [request setPredicate:predicate];
    }
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }

}

-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContentNumber:(NSNumber *)content andKey:(NSString *)key
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(key != nil || content!=nil)
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@==\'%@\'",key,content];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
        [request setPredicate:predicate];
    }
    [request setEntity:entity];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortIndex" ascending:YES];
    NSArray *arr = [NSArray arrayWithObjects:descriptor, nil];
    [request setSortDescriptors:arr];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }
    
}


-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key orderBy:(NSString *)keyOrder isDes:(BOOL)isDes
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(key != nil || content!=nil)
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@==\'%@\'",key,content];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
        [request setPredicate:predicate];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:keyOrder ascending:isDes];
    NSArray *arr = [NSArray arrayWithObjects:descriptor, nil];
    [request setSortDescriptors:arr];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }
    
}


-(NSArray *)readCoreDataFromDBNum:(NSString *)stringName withContent:(NSNumber *)content andKey:(NSString *)key
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(key != nil || content!=nil)
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@==%d",key,content.intValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
        [request setPredicate:predicate];
    }
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }
    
}


- (NSArray *)readCoreDataFromDB:(NSString *)stringName orderByKey:(NSString *)stringKey isDes:(BOOL)isDes
{
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sorDiscriper = [NSSortDescriptor sortDescriptorWithKey:stringKey ascending:isDes];
    NSArray *sortArr = [NSArray arrayWithObjects:sorDiscriper, nil];
    [request setSortDescriptors:sortArr];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }

}

-(NSArray *)readCoreDataFromDB:(NSString *)stringName isDes:(BOOL)isDes orderByKey:(id)stringKey, ...
{
    NSMutableArray *paramsArr = [[NSMutableArray alloc] init];
    va_list params;
    va_start(params, stringKey);
    id arg ;
    if(stringKey)
    {
        id startString = stringKey;
        [paramsArr addObject:startString];
        while ((arg = va_arg(params, id))) {
            if(arg)
            {
                [paramsArr addObject:arg];
            }
        }
        va_end(params);
    }
    ZXYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSMutableArray *sortArr = [[NSMutableArray alloc] init];
    for(int i = 0;i<paramsArr.count;i++)
    {
        NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:[paramsArr objectAtIndex:i] ascending:isDes];
        [sortArr addObject:des];
    }
    [request setSortDescriptors:sortArr];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }

}
#pragma mark - save
- (BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName isDelete:(BOOL)isDelete
{
    if(isDelete)
    {
        [self deleteCoreDataFromDB:dbName];
    }
    ZXYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:dbName inManagedObjectContext:manageContext];
    for(int i = 0;i<dic.allKeys.count;i++)
    {
        
        NSString *onekey = [dic.allKeys objectAtIndex:i];
        NSString *value  = [NSString stringWithFormat:@"%@",[dic valueForKey:onekey] ];
        [object setValue:value forKey:onekey];
    }
    NSError *error = nil;
    [manageContext save:&error];
    if(error == nil)
    {
        return  YES;
    }
    else
    {
        NSLog(@"saveDataToCoreData errpr");
        return  NO;
    }
}

-(BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName isDelete:(BOOL)isDelete content:(NSString *)content withKey:(NSString *)key
{
    if(isDelete)
    {
        [self deleteCoreDataFromDB:dbName withContent:content byKey:key];
    }
    ZXYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:dbName inManagedObjectContext:manageContext];
    for(int i = 0;i<dic.allKeys.count;i++)
    {
        
        NSString *onekey = [dic.allKeys objectAtIndex:i];
        NSString *value  = [NSString stringWithFormat:@"%@",[dic valueForKey:onekey] ];
        [object setValue:value forKey:onekey];
    }
    NSError *error = nil;
    [manageContext save:&error];
    if(error == nil)
    {
        return  YES;
    }
    else
    {
        NSLog(@"saveDataToCoreData errpr");
        return  NO;
    }

}

- (BOOL)saveDataToCoreDataArr:(NSArray *)arr withDBNam:(NSString *)dbName isDelete:(BOOL)isDelete
{
    if(isDelete)
    {
        [self deleteCoreDataFromDB:dbName];
    }
    for(NSDictionary *dic in arr)
    {
        [self saveDataToCoreData:dic withDBName:dbName isDelete:NO];
    }
    return YES;
}

- (BOOL)saveDataToCoreDataArr:(NSArray *)arr withDBNam:(NSString *)dbName isDelete:(BOOL)isDelete groupByKey:(NSString *)key
{
    if(isDelete)
    {
        [self deleteCoreDataFromDB:dbName];
    }
    for(NSDictionary *dic in arr)
    {
        [self saveDataToCoreData:dic withDBName:dbName isDelete:isDelete content:[dic objectForKey:key] withKey:key];
    }
    return YES;
}
@end
