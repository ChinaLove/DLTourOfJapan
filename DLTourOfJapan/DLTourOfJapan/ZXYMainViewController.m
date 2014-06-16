//
//  ZXYMainViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-6-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

typedef enum
{
    ZXYHomePage  = 0,
    ZXYPlacePage = 1,
    ZXYFavorPage = 2,
}mainView_TypeOfViewController;

#import "ZXYMainViewController.h"
#import "ZXYMainCollectionCell.h"
@interface ZXYMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    NSArray *allBtnS;
    NSArray *allLabelS;
    BOOL isNibRegistered;
}
@property (weak, nonatomic) IBOutlet UILabel *homeLbl;  /**< 首页标签 */
@property (weak, nonatomic) IBOutlet UILabel *placeLbl; /**< 地点标签 */
@property (weak, nonatomic) IBOutlet UILabel *favorLbl; /**< 优惠标签 */
@property (weak, nonatomic) IBOutlet UIButton *homeBtn; /**< 首页按钮 */
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;/**< 地点按钮 */
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;/**< 优惠按钮 */
- (IBAction)homeBtnClick:(id)sender;   /**< 首页按钮事件 */
- (IBAction)placeBtnClick:(id)sender;  /**< 地点按钮事件 */
- (IBAction)favorBtnClick:(id)sender;  /**< 优惠按钮事件 */
- (IBAction)changeLblColor:(id)sender; /**< 按钮刚按下 */
- (IBAction)cancelLblColor:(id)sender; /**< 按钮取消事件 */
@property (weak, nonatomic) IBOutlet UIImageView *footImageView;
@end

@implementation ZXYMainViewController

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
    self.homeLbl.text = NSLocalizedString(@"MainView_Home",nil);
    self.placeLbl.text = NSLocalizedString(@"MainView_Place", nil);
    self.favorLbl.text = NSLocalizedString(@"MainView_Favor", nil);
    self.homeLbl.textColor = MainViewLblColor;
    allBtnS = [NSArray arrayWithObjects:self.homeBtn,self.placeBtn,self.favorBtn, nil];
    allLabelS = [NSArray arrayWithObjects:self.homeLbl,self.placeLbl,self.favorLbl, nil];
    self.homeBtn.selected = YES;
    self.homeBtn.userInteractionEnabled = NO;
    self.footImageView.image = [UIImage imageNamed:@"mainView_foot_up"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeBtnClick:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    [self choosePageByPageIndex:0 withBtn:currentBtn];
}

- (IBAction)placeBtnClick:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    [self choosePageByPageIndex:1 withBtn:currentBtn];
}

- (IBAction)favorBtnClick:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    [self choosePageByPageIndex:2 withBtn:currentBtn];
}

- (IBAction)changeLblColor:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    NSInteger index = [allBtnS indexOfObject:currentBtn];
    UILabel *selectLbl = [allLabelS objectAtIndex:index];
    selectLbl.textColor = MainViewLblColor;
}

- (IBAction)cancelLblColor:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    NSInteger index = [allBtnS indexOfObject:currentBtn];
    UILabel *selectLbl = [allLabelS objectAtIndex:index];
    selectLbl.textColor = [UIColor whiteColor];
}

- (void)choosePageByPageIndex:(mainView_TypeOfViewController)type withBtn:(UIButton *)btn
{
    if(type == ZXYPlacePage)
    {
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_down"];
    }
    else
    {
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_up"];
    }
    for(UIButton *currentBtn in allBtnS)
    {
        if(currentBtn == btn)
        {
            currentBtn.selected = YES;
            currentBtn.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.footImageView.frame = CGRectMake(currentBtn.frame.origin.x, self.footImageView.frame.origin.y, self.footImageView.frame.size.width, self.footImageView.frame.size.height);
            }];
        }
        else
        {
            currentBtn.selected = NO;
            currentBtn.userInteractionEnabled = YES;
        }
    }
    
    for(int i = 0;i<allLabelS.count;i++)
    {
        UILabel *currentLbl = [allLabelS objectAtIndex:i];
        if(i == type)
        {
            currentLbl.textColor = MainViewLblColor;
        }
        else
        {
            currentLbl.textColor = [UIColor whiteColor];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"collectionIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"ZXYMainCollectionCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
        isNibRegistered = YES;
    }
    ZXYMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageViews.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",indexPath.row]];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *imageF = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",indexPath.row]];
    float width = 140;
    float height = (imageF.size.height/imageF.size.width)*140;
    return  CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
