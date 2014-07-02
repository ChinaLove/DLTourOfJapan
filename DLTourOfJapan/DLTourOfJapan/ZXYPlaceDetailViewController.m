//
//  ZXYPlaceDetailViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-21.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYPlaceDetailViewController.h"
#import "ZXYPageDetailCellTableViewCell.h"
#import "ZXYPlaceListCell.h"
#import "ZXYPageDetailInfoCell.h"
#import "ZXYPageDetailInfoBtnCell.h"
#import "ShowBigImageViewController.h"

@interface ZXYPlaceDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *listTable;
    LocDetailInfo *currentLocDetail;
    BOOL isRegister;
    ZXYFileOperation *fileOperation;
    __weak IBOutlet UIImageView *collectImage;
    UIImageView *headOfThis;
    BOOL isLongText;
}
@property (strong, nonatomic) IBOutlet UIView *showImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *showImageScroll;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)backView:(id)sender;
- (IBAction)searchAction:(id)sender;

@end

@implementation ZXYPlaceDetailViewController

- (id)initWithLocDetail:(LocDetailInfo *)locDetail
{
    if(self = [super initWithNibName:@"ZXYPlaceDetailViewController" bundle:nil])
    {
        currentLocDetail = locDetail;
        fileOperation = [[ZXYFileOperation alloc] init];
        isLongText = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLbl.text = currentLocDetail.locname;
    self.showImageView.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:self.showImageView];
    self.showImageScroll.zoomScale = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textCellIdentifier = @"textCellIdentifier";
    static NSString *placeCellIdentifier = @"cellOfPlaceIdentifier";
    static NSString *detailInfoCellIdentifier = @"ZXYPageDetailInfoCell";
    static NSString *detailInfoCellBtnIdentifier = @"ZXYPageDetailInfoBtnCell";
    UITableViewCell *cell ;
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    if(section == 0)
    {
        if(row == 0)
        {
            ZXYPlaceListCell *placeCell = [tableView dequeueReusableCellWithIdentifier:placeCellIdentifier];
            if(placeCell == nil)
            {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPlaceListCell" owner:self options:nil];
                for(id oneObject in nibs)
                {
                    if([oneObject isKindOfClass:[ZXYPlaceListCell class]])
                    {
                        placeCell = (ZXYPlaceListCell *)oneObject;
                    }
                }
            }
            placeCell.indicatorImage.hidden = YES;
            placeCell.titleLbl.text = currentLocDetail.locname;
            placeCell.locDetail = currentLocDetail;
            placeCell.headImage.userInteractionEnabled = YES;
            placeCell.avgPrice.text = [NSString stringWithFormat:@"%d",currentLocDetail.price.intValue];
            headOfThis = placeCell.headImage;
            self.showImage = headOfThis;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
            [headOfThis addGestureRecognizer:tap];
            NSString *filePath;
            NSString *locFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",currentLocDetail.cid] ofType:@"jpg"];
            filePath = [fileOperation cidImagePath:currentLocDetail.cid];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                placeCell.headImage.image = [UIImage imageWithContentsOfFile:filePath];
            }
            else if([[NSFileManager defaultManager] fileExistsAtPath:locFile])
            {
                placeCell.headImage.image = [UIImage imageWithContentsOfFile:locFile];
            }
            else
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Host,currentLocDetail.locpy]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFHTTPRequestOperation *operations = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                operations.responseSerializer = [AFImageResponseSerializer serializer];
                [operations setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                   placeCell.headImage.image = [UIImage imageWithData:[operation responseData]] ;
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    ;
                }];
                [operations start];
            }
            
            if([currentLocDetail.wifi isEqualToString:@"1"])
            {
                placeCell.isWifi.image = [UIImage imageNamed:@"placePage_wifi"];
            }
            else
            {
                placeCell.isWifi.image = [UIImage imageNamed:@"placePage_wifiN"];
            }
            // !!!:判断停车
            if([currentLocDetail.cparking isEqualToString:@"1"])
            {
                placeCell.isParking.image = [UIImage imageNamed:@"placePage_parking"];
            }
            else
            {
                placeCell.isParking.image = [UIImage imageNamed:@"placePage_parkingN"];
            }
            // !!!:判断吸烟
            if([currentLocDetail.smoke isEqualToString:@"1"])
            {
                placeCell.isSmoking.image = [UIImage imageNamed: @"placePage_smoking"];
            }
            else
            {
                placeCell.isSmoking.image = [UIImage imageNamed:@"placePage_smokingN"];
            }
            // !!!:判断visa
            if([currentLocDetail.visa isEqualToString:@"1"])
            {
                placeCell.isVisa.image = [UIImage imageNamed:@"placePage_visa"];
            }
            else
            {
                placeCell.isVisa.image = [UIImage imageNamed:@"placePage_visaN"];
            }
            // !!!:判断master
            if([currentLocDetail.master isEqualToString:@"1"])
            {
                placeCell.isMaster.image = [UIImage imageNamed:@"placePage_master"];
            }
            else
            {
                placeCell.isMaster.image = [UIImage imageNamed:@"placePage_masterN"];
            }

            
            cell = placeCell;
        }
        else if(row == 1)
        {
            ZXYPageDetailCellTableViewCell *pageCell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
            if(pageCell == nil)
            {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPageDetailCellTableViewCell" owner:self options:nil];
                for(id oneObject in nibs)
                {
                    if([oneObject isKindOfClass:[ZXYPageDetailCellTableViewCell class]])
                    {
                        pageCell = (ZXYPageDetailCellTableViewCell *)oneObject;
                    }
                }
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreText)];
            pageCell.loadMoreTextImage.userInteractionEnabled = YES;
            [pageCell.loadMoreTextImage addGestureRecognizer:tap];
            pageCell.detailContext.text = [currentLocDetail info_normal];
            [pageCell.detailContext sizeThatFits:CGSizeMake(308, 999)];
            if(isLongText)
            {
                pageCell.loadMoreTextImage.image = [UIImage imageNamed:@"placePage_arrowU"];
            }
            else
            {
               pageCell.loadMoreTextImage.image = [UIImage imageNamed:@"placePage_arrowD"]; 
            }
            cell = pageCell ;
        }
        else if (row == 5 || row == 7)
        {
            ZXYPageDetailInfoBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellBtnIdentifier ];
            if(btnCell == nil)
            {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPageDetailInfoBtnCell" owner:self options:nil];
                for(id oneObject in nibs)
                {
                    if([oneObject isKindOfClass:[ZXYPageDetailInfoBtnCell class]])
                    {
                        btnCell = (ZXYPageDetailInfoBtnCell *)oneObject;
                    }
                }
            }

            if(row == 5)
            {
                [btnCell.imageBtn setImage:[UIImage imageNamed:@"placePage_phoneU"] forState:UIControlStateNormal];
                [btnCell.imageBtn setImage:[UIImage imageNamed:@"placePage_phone"] forState:UIControlStateHighlighted];
                btnCell.titleLbl.text = NSLocalizedString(@"PlaceD_ConnectPhone", nil);
                btnCell.valueLbl.text = currentLocDetail.phone;
            }
            else
            {
                [btnCell.imageBtn setImage:[UIImage imageNamed:@"placePage_comentU"] forState:UIControlStateNormal];
                [btnCell.imageBtn setImage:[UIImage imageNamed:@"placePage_coment"] forState:UIControlStateHighlighted];
                btnCell.titleLbl.text =NSLocalizedString(@"PlaceD_Comment", nil);
                btnCell.valueLbl.text = @"";
                
            }
            cell = btnCell;
        }
        
        else
        {
            ZXYPageDetailInfoCell *detailCell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellIdentifier ];
            if(detailCell == nil)
            {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXYPageDetailInfoCell" owner:self options:nil];
                for(id oneObject in nibs)
                {
                    if([oneObject isKindOfClass:[ZXYPageDetailInfoCell class]])
                    {
                        detailCell = (ZXYPageDetailInfoCell *)oneObject;
                    }
                }
            }

            if(row == 2)
            {
                detailCell.titleLbl.text = NSLocalizedString(@"PlaceD_AvgPredict", nil);
                detailCell.valueTable.text = currentLocDetail.price;
            }
            else if (row == 3)
            {
                detailCell.titleLbl.text = NSLocalizedString(@"PlaceD_BusinessHour", nil);
                detailCell.valueTable.text = currentLocDetail.time;
            }
            else if (row == 4)
            {
                detailCell.titleLbl.text = NSLocalizedString(@"PlaceD_Address", nil);
                detailCell.valueTable.text = currentLocDetail.locaddr;
                detailCell.mapImage.hidden = NO;
            }
            else if(row == 6)
            {
                detailCell.titleLbl.text = NSLocalizedString(@"PlaceD_DiscountInfo", nil);
                detailCell.valueTable.text = @"";
                
            }
            cell = detailCell;
        }
    }//section0结束
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 8;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSString *locD = [currentLocDetail info_normal];
    if(section == 0)
    {
        NSInteger row = indexPath.row;
        if(row == 0 || row == 1)
        {
            
//            if(isLongText&&row == 1)
//            {
//                return [self heightOfTextView:locD WithConstrain:0];
//            }
//            else if()
//            {
//            
//            }
            if(row == 1)
            {
                if(isLongText)
                {
                    return [self heightOfTextView:locD WithConstrain:0];
                }
            }
            return 78;
        }
        else
        {
            return 28;
        }
    }
    else
    {
        return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<=3 || indexPath.row == 6)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (IBAction)backView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (float)heightOfTextView:(NSString *)string WithConstrain:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 306, 0)];
    detailTextView.font = [UIFont systemFontOfSize:14];
    detailTextView.text = string;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(306,CGFLOAT_MAX)];
    return deSize.height;
}

- (void)didClickHeadImage
{
    if(headOfThis.image == nil)
    {
        return;
    }
    ShowBigImageViewController *bigImage = [[ShowBigImageViewController alloc] initWithImageData:UIImageJPEGRepresentation(headOfThis.image, 1)];
    bigImage.title = self.title;
    bigImage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navigation =[ [UINavigationController alloc]initWithRootViewController:bigImage];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];

}

- (void)loadMoreText
{
    if(isLongText)
    {
        isLongText = NO;
    }
    else
    {
        isLongText = YES;
    }
    [listTable reloadData];
}

- (IBAction)searchAction:(id)sender
{
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
