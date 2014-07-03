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
@interface ZXYFavorViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    SRRefreshView *freshView;
    __weak IBOutlet UITableView *freshTableView;
}
@end

@implementation ZXYFavorViewController

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
    [self startLoadData];
    freshView = [[SRRefreshView alloc] init];
    freshView.delegate = self;
    //freshView.upInset = 44;
    freshView.slimeMissWhenGoingBack = YES;
    freshView.slime.bodyColor = [UIColor blackColor];
    freshView.slime.skinColor = [UIColor whiteColor];
    freshView.slime.lineWith = 1;
    freshView.slime.shadowBlur = 4;
    freshView.slime.shadowColor = [UIColor blackColor];
    [freshTableView addSubview:freshView];
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
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listCellIdentifier = @"cellOfPlaceIdentifier";
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
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
    [freshView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:3
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (void)startLoadData
{
    NSURL *url = [NSURL URLWithString:URL_Discount];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
    [operation start];
}
@end
