//
//  ZXYPlaceLocalListViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPlaceLocalListViewController.h"
#import "ZXYPlaceListCell.h"
#import "LocDetailInfo.h"
@interface ZXYPlaceLocalListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *currentLocType;
    NSMutableArray *arrForShow;
    ZXYProvider *dataProvider;
}
@end

@implementation ZXYPlaceLocalListViewController

- (id)initWIthLocType:(NSString *)locType
{
    if(self = [super initWithNibName:@"ZXYPlaceLocalListViewController" bundle:nil])
    {
        currentLocType = locType;
        dataProvider = [ZXYProvider sharedInstance];
        arrForShow     = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:currentLocType andKey:@"loctype"] ];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellOfPlaceIdentifier";
    ZXYPlaceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        //[tableView registerClass:[ZXYPlaceListCell class] forCellReuseIdentifier:cellIdentifier];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPlaceListCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ZXYPlaceListCell class]])
            {
                cell = (ZXYPlaceListCell *)oneObject;
                
            }
        }
    }
    LocDetailInfo *locDetail = [arrForShow objectAtIndex:indexPath.row];
    cell.titleLbl.text = locDetail.locname;
    cell.avgPrice.text = locDetail.price;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrForShow.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

@end
