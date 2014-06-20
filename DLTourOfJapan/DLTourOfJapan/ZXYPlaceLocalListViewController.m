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
@interface ZXYPlaceLocalListViewController ()
{
    NSString *currentLocType;
    NSMutableArray *arrForShow;
    ZXYProvider *dataProvider;
    __weak IBOutlet UITableView *listTable;
    __weak IBOutlet UIView *searchView;
    UINavigationController *navi;
    ZXYFileOperation *fileOperation;
    ZXYNETHelper     *netHelper;
}
- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchOpenTime;
- (IBAction)searchDistance:(id)sender;
- (IBAction)searchList:(id)sender;
@end

@implementation ZXYPlaceLocalListViewController

- (id)initWIthLocType:(NSString *)locType
{
    if(self = [super initWithNibName:@"ZXYPlaceLocalListViewController" bundle:nil])
    {
        currentLocType = locType;
        dataProvider = [ZXYProvider sharedInstance];
        arrForShow     = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:currentLocType andKey:@"loctype"] ];
        fileOperation = [ZXYFileOperation sharedSelf];
        netHelper = [ZXYNETHelper sharedSelf];
        NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
        [datatnc addObserver:self selector:@selector(reloadDataMethod) name:PlaceNotification object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [listTable setTableHeaderView:searchView];
    self.titleLbl.text = self.title;
    listTable.scrollsToTop = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [netHelper startDownPlaceImage];
}

- (void)reloadDataMethod
{
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:YES];
}

- (void)reloadList
{
    [listTable reloadData];
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
    
    // !!!:头像
    NSString *cid = locDetail.cid;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:cid ofType:@"jpg"];
    NSString *headImagePath = [fileOperation cidImagePath:locDetail.locpy];
    if([[NSFileManager defaultManager] fileExistsAtPath:headImagePath])
    {
        cell.headImage.image = [UIImage imageWithContentsOfFile:headImagePath];
    }
    else
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_Host,locDetail.locpy];
        [netHelper placeURLADD:[NSURL URLWithString:urlString]];
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            cell.headImage.image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    cell.titleLbl.text = locDetail.locname;
    if(!locDetail.price.intValue == 0)
    {
        cell.avgPrice.text = [NSString stringWithFormat:@"%d",locDetail.price.intValue ];
    }
    else
    {
        cell.avgPrice.text = @"无";
    }
    
    cell.locDetail = locDetail;
    // !!!:判断wifi
    if([locDetail.wifi isEqualToString:@"1"])
    {
        cell.isWifi.image = [UIImage imageNamed:@"placePage_wifi"];
    }
    else
    {
        cell.isWifi.image = [UIImage imageNamed:@"placePage_wifiN"];
    }
    // !!!:判断停车
    if([locDetail.cparking isEqualToString:@"1"])
    {
        cell.isParking.image = [UIImage imageNamed:@"placePage_parking"];
    }
    else
    {
        cell.isParking.image = [UIImage imageNamed:@"placePage_parkingN"];
    }
    // !!!:判断吸烟
    if([locDetail.smoke isEqualToString:@"1"])
    {
        cell.isSmoking.image = [UIImage imageNamed: @"placePage_smoking"];
    }
    else
    {
        cell.isSmoking.image = [UIImage imageNamed:@"placePage_smokingN"];
    }
    // !!!:判断visa
    if([locDetail.visa isEqualToString:@"1"])
    {
        cell.isVisa.image = [UIImage imageNamed:@"placePage_visa"];
    }
    else
    {
        cell.isVisa.image = [UIImage imageNamed:@"placePage_visaN"];
    }
    // !!!:判断master
    if([locDetail.master isEqualToString:@"1"])
    {
        cell.isMaster.image = [UIImage imageNamed:@"placePage_master"];
    }
    else
    {
        cell.isMaster.image = [UIImage imageNamed:@"placePage_masterN"];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath is %d",indexPath.row);
}

- (IBAction)searchDistance:(id)sender {
}

- (IBAction)searchList:(id)sender {
}
- (IBAction)backView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlaceNotification object:nil];
}
@end
