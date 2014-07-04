//
//  ZXYTableViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYTableViewController.h"
#import "ZXYTableViewCell.h"
#import "LocDetailInfo.h"
#import "ZXYPlaceDetailViewController.h"
@interface ZXYTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *allDataShow;
    ZXYProvider *dataProvider;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ZXYTableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        allDataShow = [[NSMutableArray alloc] init];
        dataProvider = [[ZXYProvider alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setSearchString:(NSString *)searchString
{
    [allDataShow removeAllObjects];
    if(searchString.length == 0)
    {
        return;
    }
    NSString *formatString = [NSString stringWithFormat:@"locname LIKE[cd] '*%@*'",searchString];
    allDataShow = [NSMutableArray arrayWithArray:[dataProvider readCoreDataFromDB:@"LocDetailInfo" withLike:formatString] ];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"zxycellIdentifier";
    ZXYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibS = [[NSBundle mainBundle] loadNibNamed:@"ZXYTableViewCell" owner:self options:nil];
        for(id oneObject in nibS)
        {
            if([oneObject isKindOfClass:[ZXYTableViewCell class]])
            {
                cell = (ZXYTableViewCell *)oneObject;
            }
        }
    }
    LocDetailInfo *loc = [allDataShow objectAtIndex:indexPath.row];
    cell.nameLabel.text = loc.locname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocDetailInfo *loc = [allDataShow objectAtIndex:indexPath.row];
   
    if([self.delegate respondsToSelector:@selector(selectRowOfTableView:)])
    {
        [self.delegate selectRowOfTableView:loc];
    }
}


@end
