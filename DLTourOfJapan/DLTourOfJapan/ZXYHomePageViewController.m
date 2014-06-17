//
//  ZXYHomePageViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYHomePageViewController.h"
#import "WaterfallLayout.h"
#import "ZXYMainCollectionCell.h"
#import "Advertise.h"
@interface ZXYHomePageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WaterfallLayoutDelegate>
{
    NSMutableArray *allAdvertise;
    ZXYProvider *provider;
    BOOL isCellRegist;
    ZXYFileOperation *fileOperation;
    ZXYNETHelper *netHelper;
}

@end

@implementation ZXYHomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        provider = [ZXYProvider sharedInstance];
        allAdvertise = [NSMutableArray arrayWithArray:[provider readCoreDataFromDB:@"Advertise"] ];
        fileOperation = [ZXYFileOperation sharedSelf];
        netHelper = [ZXYNETHelper sharedSelf];
        NSNotificationCenter *datatnc = [NSNotificationCenter defaultCenter];
        [datatnc addObserver:self selector:@selector(reloadDataMethod) name:AdvertiseNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadDataMethod
{
    [self performSelectorOnMainThread:@selector(runONMainThread) withObject:nil waitUntilDone:YES];
}

- (void)runONMainThread
{
    [self.pictureCollection reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [netHelper startDownAdvertiseImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allAdvertise.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"collectionIdentifier";
    if(!isCellRegist)
    {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXYMainCollectionCell class]) bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
        isCellRegist = YES;
    }
    ZXYMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Advertise *advertise = [allAdvertise objectAtIndex:indexPath.row];
    NSString *filePath = [fileOperation advertiseImagePath:advertise.pic_url];
    if([[ZXYFileOperation defaultManager] fileExistsAtPath:filePath])
    {
        cell.imageViews.image = [UIImage imageWithContentsOfFile:filePath];
    }
    else
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_Host,advertise.pic_url];
        NSURL *url = [NSURL URLWithString:urlString];
        [netHelper advertiseURLADD:url];
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(150, 150);
}

- (UIEdgeInsets) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
@end