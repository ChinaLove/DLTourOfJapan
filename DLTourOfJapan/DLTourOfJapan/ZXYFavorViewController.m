//
//  ZXYFavorViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYFavorViewController.h"
#import "SRRefreshView.h"
#import "ZXYPlaceListCell.h"
#import "LocDetailInfo.h"
#import "ZXYPlaceDetailViewController.h"
#import "MBProgressHUD.h"
@interface ZXYFavorViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    SRRefreshView *freshView;
    __weak IBOutlet UITableView *freshTableView;
    NSMutableArray *allShowData;
    ZXYProvider *dataProvider;
    ZXYFileOperation *fileOperation;
    ZXYNETHelper *netHelper;
    __weak IBOutlet UILabel *noContentLbl;
    MBProgressHUD *progress;
}
@end

@implementation ZXYFavorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allShowData= [[NSMutableArray alloc] init];
        dataProvider = [[ZXYProvider alloc] init];
        fileOperation = [ZXYFileOperation sharedSelf];
        netHelper = [[ZXYNETHelper alloc] init];
        NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
        [datatnc addObserver:self selector:@selector(reloadDataMethod) name:PlaceNotification object:nil];
    }
    return self;
}

- (void)reloadDataMethod
{
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:YES];
}

- (void)reloadList
{
    [freshTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [noContentLbl setTextColor:[UIColor whiteColor]];
    [noContentLbl setText:NSLocalizedString(@"PlacePage_NonContent", nil)];
    [self startLoadData];
    freshView = [[SRRefreshView alloc] init];
    freshView.delegate = self;
    freshView.upInset = 0;
    freshView.slimeMissWhenGoingBack = YES;
    freshView.slime.bodyColor = [UIColor blackColor];
    freshView.slime.skinColor = [UIColor whiteColor];
    freshView.slime.lineWith = 1;
    freshView.slime.shadowBlur = 4;
    freshView.slime.shadowColor = [UIColor blackColor];
    [freshTableView addSubview:freshView];
    [netHelper startDownPlaceImage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allShowData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listCellIdentifier = @"cellOfPlaceIdentifier";
    LocDetailInfo *locDetail = [[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:[allShowData objectAtIndex:indexPath.row] andKey:@"cid"] objectAtIndex:0];
    ZXYPlaceListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPlaceListCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ZXYPlaceListCell class]])
            {
                cell = (ZXYPlaceListCell *)oneObject;
            }
        }
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocDetailInfo *locDetail = [[dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:[allShowData objectAtIndex:indexPath.row] andKey:@"cid"] objectAtIndex:0];
    if([self.delegate respondsToSelector:@selector(selectRow:)])
    {
        [self.delegate selectRow:locDetail];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [freshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [freshView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self startLoadData];
}

- (void)startLoadData
{
    [allShowData removeAllObjects];
    NSURL *url = [NSURL URLWithString:URL_Discount];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        NSString *xmlString = [ZXYTourOfJapanHelper toMyXML:operation.responseString];
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *rootElement = [document rootElement];
        for(CXMLElement *element in rootElement.children)
        {
            if([element.name isEqualToString:@"favorablelist"]&&[element isKindOfClass:[CXMLElement class]])
            {
                for(CXMLElement *childElement in element.children)
                {
                    if([childElement.name isEqualToString:@"idobject"] && [childElement isKindOfClass:[CXMLElement class]])
                    {
                        [allShowData addObject:childElement.stringValue];
                    }
                }
            }
        }
        if(allShowData.count == 0)
        {
            progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progress.labelText = NSLocalizedString(@"PlacePage_NonContent", nil);
            progress.mode = MBProgressHUDModeText;
            progress.margin = 10.f;
            [progress hide:YES afterDelay:2];
        }
        else
        {
           
        }
        [freshView endRefresh];
        [freshTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
    [operation start];
}
@end
