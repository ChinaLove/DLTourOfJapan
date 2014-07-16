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
#import "ZXYPlaceDetailViewController.h"
#import "ZXYAppDelegate.h"
#import <CoreText/CoreText.h>
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "UserInfo.h"
#import "CXMLDocument.h"
#import "ZXYTourOfJapanHelper.h"
#import "MBProgressHUD.h"

typedef enum
{
    pickerTypeNone = 0,
    pickerTypeDis  =1,
    pickerTypeTime =2,
}pickerType;
@interface ZXYPlaceLocalListViewController ()<CLLocationManagerDelegate,UISearchBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *currentLocType;
    NSMutableArray *arrForShow;
    ZXYProvider *dataProvider;
    __weak IBOutlet UITableView *listTable;
    __weak IBOutlet UIView *searchView;
    UINavigationController *navi;
    ZXYFileOperation *fileOperation;
    ZXYNETHelper     *netHelper;
    __weak IBOutlet UILabel *distanceLbl;
    __weak IBOutlet UIButton *searchButton;
    
    __weak IBOutlet UILabel *businessLbl;
    IBOutlet UIView *pickerControllerView;
    __weak IBOutlet UIPickerView *pickerController;
    __weak IBOutlet UIBarButtonItem *leftItem;
    __weak IBOutlet UIBarButtonItem *rightItem;
    CLLocation *currentLocation;
    CLLocationManager *localManager;
    pickerType currentPickType;
    MBProgressHUD *progress;
    IBOutlet UIView *searchViews;
    BOOL isSearchShow;
}
- (IBAction)searchAction:(id)sender;

- (IBAction)hidePicker:(id)sender;
- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchOpenTime;
- (IBAction)searchDistance:(id)sender;
- (IBAction)searchList:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ZXYPlaceLocalListViewController

- (id)initWIthLocType:(NSString *)locType
{
    if(self = [super initWithNibName:@"ZXYPlaceLocalListViewController" bundle:nil])
    {
        currentPickType = pickerTypeNone;
        currentLocType = locType;
        dataProvider = [ZXYProvider sharedInstance];
        arrForShow     = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:currentLocType andKey:@"loctype"] ];
        fileOperation = [ZXYFileOperation sharedSelf];
        //ZXYAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        netHelper = [[ZXYNETHelper alloc] init];
        NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
        [datatnc addObserver:self selector:@selector(reloadDataMethod) name:PlaceNotification object:nil];
    }
    return self;
}

- (id)initWithFav
{
    if(self = [super initWithNibName:@"ZXYPlaceLocalListViewController" bundle:nil])
    {
        currentPickType = pickerTypeNone;
        currentLocType = @"10001";
        dataProvider = [ZXYProvider sharedInstance];
        arrForShow     = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:@"1" andKey:@"isfavored"] ];
        fileOperation = [ZXYFileOperation sharedSelf];
        //ZXYAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        netHelper = [[ZXYNETHelper alloc] init];
        NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
        [datatnc addObserver:self selector:@selector(reloadDataMethod) name:PlaceNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSearchShow = NO;
    currentLocation = [[CLLocation alloc] init];
    localManager = [[CLLocationManager alloc] init];
    localManager.distanceFilter = 5.0;
    localManager.delegate = self;
    [localManager startUpdatingLocation];
    localManager.desiredAccuracy = kCLLocationAccuracyBest;
    distanceLbl.text = NSLocalizedString(@"PlacePage_Distance", nil);
    businessLbl.text = NSLocalizedString(@"PlacePage_OpeningHour", nil);
    self.titleLbl.text = self.title;
    leftItem.title = NSLocalizedString(@"Cancel", nil);
    pickerControllerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, pickerControllerView.frame.size.height);
    [self.view addSubview:pickerControllerView];
    if(![currentLocType isEqualToString:@"10001"])
    {
        [listTable setTableHeaderView:searchView];
        
        
    }
    else
    {
        self.titleLbl.text = NSLocalizedString(@"PlacePage_favor", nil);
        [self.searchBar setHidden:NO];
    }
    NSLog(@"all subViews %d",self.searchBar.subviews.count);
    UIView *views = [self.searchBar.subviews objectAtIndex:0];
    for(UIView *oneObject in views.subviews)
    {
        NSLog(@"class is %@",NSStringFromClass(oneObject.class));
        if([oneObject isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)oneObject;
            [textField setTextColor:[UIColor whiteColor]];
            textField.returnKeyType = UIReturnKeyDone;
        }
        else
        {
            [oneObject removeFromSuperview];
        }
        
    }
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    self.searchBar.delegate = self;
    NSDictionary *textAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSFontAttributeName, nil];
    [self.searchBar setScopeBarButtonTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    listTable.scrollsToTop = NO;
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.dimBackground = YES;
    progress.color = [UIColor colorWithRed:0.1 green:0.50 blue:0.82 alpha:0.90];
    searchViews.backgroundColor = vip_loginBtnColor;
    searchViews.frame = CGRectMake(0, listTable.frame.origin.y, searchViews.frame.size.width, 0);
    [self.view addSubview:searchViews];
    [self.view addSubview:progress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([currentLocType isEqualToString:@"10001"])
    {
        arrForShow     = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:@"1" andKey:@"isfavored"] ];
        [listTable reloadData];
    }
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

- (void)viewWillLayoutSubviews
{
    
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
    NSString *headImagePath = [fileOperation cidImagePath:locDetail.cid];
    if([[NSFileManager defaultManager] fileExistsAtPath:headImagePath])
    {
        cell.headImage.image = [UIImage imageWithContentsOfFile:headImagePath];
    }
    else
    {
        
        [netHelper placeURLADD:cid];
        cell.headImage.image = [UIImage imageNamed:@"placePage_placeHod"];
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
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocDetailInfo *locDetail = [arrForShow objectAtIndex:indexPath.row];
    ZXYPlaceDetailViewController *detailVC = [[ZXYPlaceDetailViewController alloc] initWithLocDetail:locDetail];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)searchDistance:(id)sender
{
    currentPickType = pickerTypeDis;
    [pickerController reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        pickerControllerView.frame = CGRectMake(0, self.view.frame.size.height-pickerControllerView.frame.size.height, self.view.frame.size.width, pickerControllerView.frame.size.height);
    }];
}

- (IBAction)searchList:(id)sender
{
    currentPickType = pickerTypeTime;
    [pickerController reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        pickerControllerView.frame = CGRectMake(0, self.view.frame.size.height-pickerControllerView.frame.size.height, self.view.frame.size.width, pickerControllerView.frame.size.height);
    }];
}

- (IBAction)searchAction:(id)sender
{
    if(isSearchShow)
    {
        [UIView animateWithDuration:0.3 animations:^{
           searchViews.frame = CGRectMake(0, searchViews.frame.origin.y, searchViews.frame.size.width, 0);
           listTable.frame   = CGRectMake(0, searchViews.frame.origin.y, listTable.frame.size.width, listTable.frame.size.height+39);
            [self.searchBar resignFirstResponder];
            isSearchShow = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            searchViews.frame = CGRectMake(0, listTable.frame.origin.y, searchViews.frame.size.width, 39);
            listTable.frame   = CGRectMake(0, searchViews.frame.size.height+searchViews.frame.origin.y, listTable.frame.size.width, listTable.frame.size.height-39);
            isSearchShow = YES;
        }];

    }
}

- (IBAction)hidePicker:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        pickerControllerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, pickerControllerView.frame.size.height);
    }];
}

- (IBAction)backView:(id)sender
{
    [netHelper cancelPlaceImageDown];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlaceNotification object:nil];
    [localManager stopUpdatingLocation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text change is %@",searchText);
    NSString *likeString = [NSString stringWithFormat:@"locname LIKE[cd] '*%@*' and loctype=%@",searchText,currentLocType];
    if([currentLocType isEqualToString:@"10001"])
    {
        likeString = [NSString stringWithFormat:@"locname LIKE[cd] '*%@*' and isfavored='1'",searchText];
        arrForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withLike:likeString]];
    }
    else
    {
        arrForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withLike:likeString]];
    }
    [listTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


// !!!:pick delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(currentPickType == 1)
    {
        return 7;
    }
    else
    {
        return 7;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *pickSub = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *labes  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, pickSub.frame.size.height)];
    [labes setFont:[UIFont boldSystemFontOfSize:24]];
    [pickSub addSubview:labes];
    labes.textAlignment = NSTextAlignmentCenter;
    [labes setTextColor:[UIColor colorWithRed:0.2941 green:0.4549 blue:0.8314 alpha:1]];
    if(currentPickType == pickerTypeDis)
    {
        if(row == 0)
        {
            labes.text = NSLocalizedString(@"PlacePage_AllPlace", nil);
        }
        else
        {
            labes.text = [NSString stringWithFormat:@"%d",row*500];
        }
    }
    else
    {
        if(row == 0)
        {
            labes.text = NSLocalizedString(@"PlacePage_AllPlace", nil);
        }
        else if(row == 1)
        {
            labes.text = [NSString stringWithFormat:@"24%@",NSLocalizedString(@"PlacePage_Hour", nil)];
        }
        else if(row == 2)
        {
            labes.text = [NSString stringWithFormat:@"16%@",NSLocalizedString(@"PlacePage_HourPlace", nil)];
        }
        else if (row == 3)
        {
            labes.text = [NSString stringWithFormat:@"18%@",NSLocalizedString(@"PlacePage_HourPlace", nil)];
        }
        else if (row == 4)
        {
            labes.text = [NSString stringWithFormat:@"20%@",NSLocalizedString(@"PlacePage_HourPlace", nil)];
        }
        else if (row == 5)
        {
            labes.text = [NSString stringWithFormat:@"22%@",NSLocalizedString(@"PlacePage_HourPlace", nil)];
        }
        else
        {
            labes.text = [NSString stringWithFormat:@"0%@",NSLocalizedString(@"PlacePage_HourPlace", nil)];
        }
 
    }
    return pickSub;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        arrForShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:currentLocType andKey:@"loctype"] ];
        [listTable reloadData];
        return;
    }
    float currentValue = row*500;
    NSArray *allPlace = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:currentLocType andKey:@"loctype"] ];
    
    if(currentPickType == 1)
    {
        [arrForShow removeAllObjects];
        for(int i = 0;i<allPlace.count;i++)
        {
            LocDetailInfo *loc = [allPlace objectAtIndex:i];
            float xLong = loc.lon.floatValue;
            float yLat  = loc.lat.floatValue;
            CLLocation *dataLocation = [[CLLocation alloc] initWithLatitude:yLat longitude:xLong];
            float distance = [dataLocation distanceFromLocation:currentLocation];
            NSLog(@"%f",distance);
            if(distance<currentValue)
            {
                [arrForShow addObject:loc];
            }
        }
        [listTable reloadData];
    }
    else
    {
        [arrForShow removeAllObjects];
        NSString *hourString;
        if(row == 1)
        {
            hourString = @"24";
        }
        else if(row == 2)
        {
            hourString = @"16";
        }
        else if (row == 3)
        {
            hourString = @"18";
        }
        else if (row == 4)
        {
            hourString = @"20";
        }
        else if (row == 5)
        {
            hourString = @"22";
        }
        else
        {
            hourString = @"0";
        }
        if(![ZXYNETHelper isNETConnect])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AppDelegate_NetConnect", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString *stringURL = [NSString stringWithFormat:@"http://115.29.46.22:81/dalian100/index.php/InterFace/dealWithEvent?service=StoreList&method=viewStoreList&idsource=a&idlangid=3&idcity=2&stcondition=0&pagesize=10&pageno=1&lat=38.858315&lng=121.530475&distance=&businesstime=%@&idobjtype=%@&iduser=",hourString,currentLocType];
        [progress show:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [progress hide:YES];
            NSLog(@"%@",operation.responseString);
            NSString *xmlString = [ZXYTourOfJapanHelper toMyXML:operation.responseString];
            CXMLDocument *document = [[CXMLDocument alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            CXMLElement *rootElement = [document rootElement];
            if([rootElement.name isEqualToString:@"storelistlist"]&&[rootElement isKindOfClass:[CXMLElement class]])
            {
                for(CXMLElement *element in rootElement.children)
                {
                    if([element.name isEqualToString:@"storelist"]&&[element isKindOfClass:[CXMLElement class]])
                    {
                        for(CXMLElement *childElement in element.children)
                        {
                            if([childElement.name isEqualToString:@"idobject"])
                            {
                                NSArray *locS = [dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:childElement.stringValue andKey:@"cid"] ;
                                if(locS.count > 0)
                                {
                                    LocDetailInfo *loc = [locS objectAtIndex:0];
                                    [arrForShow addObject:loc];
                                }
                            }
                        }
                    }
                }
            }
            [listTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [progress hide:YES];
        }];
        [operation start];
        [listTable reloadData];

    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    NSLog(@" --- >%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}


@end
