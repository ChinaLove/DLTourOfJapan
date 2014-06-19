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
{
    ZXYUserDefault *userDefault;
    ZXYProvider    *dataProvider;
    
}
- (IBAction)clickPlacePageBtn:(id)sender;

@end

@implementation ZXYPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userDefault = [ZXYUserDefault sharedSelf];
        dataProvider = [ZXYProvider sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
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

- (IBAction)clickPlacePageBtn:(id)sender
{
    if([self.delegate respondsToSelector:@selector(clickBtnAt:)])
    {
        [self.delegate clickBtnAt:sender];
    }
}
@end
