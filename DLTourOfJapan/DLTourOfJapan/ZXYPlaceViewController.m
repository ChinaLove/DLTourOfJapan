//
//  ZXYPlaceViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPlaceViewController.h"
#import <sqlite3.h>
#import "fmdb/FMDB.h"
@interface ZXYPlaceViewController ()


@end

@implementation ZXYPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FMDatabase *db = [ZXYDBHelper DBOpen];
    
    FMResultSet *rs = [db executeQuery:@"select * from ZLOCDETAILINFO"];
    
    while ([rs next]){
        NSLog(@"%@",[rs stringForColumn:@"ZINFO_NORMAL"]);
    }
    [rs close];
    [db close];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
