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
#import "ZXYHomePageViewController.h"
#import "ZXYPlaceViewController.h"
#import "ZXYFavorViewController.h"
#import "MBProgressHUD.h"
#import "NetHelperDelegate.h"
#import "ZXYNETHelper.h"
#import "ZXYUserDefault.h"
#import "ZXYProvider.h"
@interface ZXYMainViewController ()<NetHelperDelegate,MBProgressHUDDelegate>
{
    NSArray *allBtnS;   /** < 用来保存三个标签按钮 */
    NSArray *allLabelS; /** < 用来保存三个标签 */
    __weak IBOutlet UIView *contentView; /** < 用来保存三个主页面 */
    MBProgressHUD *HUD; /** < loading */
    ZXYNETHelper *netHelp; //网络帮助文件
    ZXYUserDefault *userDefault; //用户设置文件
    ZXYProvider *dataProvider;   //数据库操作文件
}
@property (strong, nonatomic) ZXYHomePageViewController *homePage; //第一个页面
@property (strong, nonatomic) ZXYPlaceViewController    *placePage;//第二个页面
@property (strong, nonatomic) ZXYFavorViewController    *favorPage;//第三个页面
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
        netHelp = [ZXYNETHelper sharedSelf];
        netHelp.netHelperDelegate = self;
        userDefault = [ZXYUserDefault sharedSelf];
        dataProvider = [ZXYProvider sharedInstance];
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
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [HUD setLabelText:NSLocalizedString(@"HUD_CheckUpdate", nil)];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    //设置大小
    contentView.frame = CGRectMake(0, contentView.frame.origin.y, Screen_width*3, Screen_height-contentView.frame.origin.y);
    NSLog(@"contentView width is %f",contentView.frame.size.width);
    [self initPlaceFavPage];
    // !!!:在此处取广告数据，首先判断是否需要更新，再取数据
    if([ZXYNETHelper isNETConnect])
    {
        [HUD show:YES];
        [self startRequest];
    }
}

/**
 * 初始化页面
 *
 */
- (void)initPlaceFavPage
{
    self.placePage = [[ZXYPlaceViewController alloc] initWithNibName:@"ZXYPlaceViewController" bundle:nil];
    self.placePage.view.frame = CGRectMake(Screen_width, 0, self.placePage.view.frame.size.width, contentView.frame.size.height);
    if(!iPhone5)
    {
        self.placePage.scrollViewOfBtn.contentSize = CGSizeMake(320, 465);
    }
    [contentView addSubview:self.placePage.view];
    self.favorPage = [[ZXYFavorViewController alloc] init];
    self.favorPage.view.frame = CGRectMake(Screen_width*2, 0, self.favorPage.view.frame.size.width, contentView.frame.size.height);
    [contentView addSubview:self.favorPage.view];
}

/**
 *  请求开始
 */
- (void)startRequest
{
    NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:@"ad",@"type", nil];
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation POST:URL_getLastVersion parameters:prama success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *dateStringService = [operation responseString];
        NSString *dateStringUser    = [userDefault getUserDefaultUpdateTimeString];
        if(dateStringService.integerValue>dateStringUser.integerValue)
        {
            NSLog(@"取数据了啊");
            // !!!:现在开始获取广告数据
            [netHelp requestStart:URL_getAdvertise withParams:nil bySerialize:[AFXMLParserResponseSerializer serializer]];
        }
        else
        {
            self.homePage = [[ZXYHomePageViewController alloc] initWithNibName:NSStringFromClass([ZXYHomePageViewController class]) bundle:nil];
            [contentView addSubview:self.homePage.view];
            self.homePage.view.frame = CGRectMake(0, 0, Screen_width, contentView.frame.size.height);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
        [HUD hide:YES];
        
    }];
    
}

// !!!:数据获取成功
- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object
{
    [HUD hide:YES];
   
    NSData *responseData = [opertation responseData];
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    [dataProvider saveDataToCoreDataArr:responseArray withDBNam:@"Advertise" isDelete:YES];
    
    self.homePage = [[ZXYHomePageViewController alloc] initWithNibName:NSStringFromClass([ZXYHomePageViewController class]) bundle:nil];
    [contentView addSubview:self.homePage.view];
    self.homePage.view.frame = CGRectMake(0, 0, Screen_width, contentView.frame.size.height);
    NSLog(@"%@",opertation.responseString);
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

// !!!:切换三个主页面的方法
- (void)choosePageByPageIndex:(mainView_TypeOfViewController)type withBtn:(UIButton *)btn
{
    //页面切换、改变图片
    if(type == ZXYPlacePage)
    {
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_down"];
        contentView.frame = CGRectMake(-Screen_width, contentView.frame.origin.y, Screen_width*3, contentView.frame.size.height);
    }
    else
    {
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_up"];
        if(type == ZXYFavorPage)
        {

            contentView.frame = CGRectMake(-Screen_width*2, contentView.frame.origin.y, Screen_width*3, contentView.frame.size.height);
        }
        else
        {

            contentView.frame = CGRectMake(0, contentView.frame.origin.y, Screen_width*3, contentView.frame.size.height);
        }
        
    }
    //改变按钮的选中状态与图标的动画移动
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
    //改变标签的颜色
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

@end
