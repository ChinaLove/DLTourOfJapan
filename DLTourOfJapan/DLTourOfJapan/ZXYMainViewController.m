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
#import "ZXYPlaceLocalListViewController.h"
#import "ZXYAppDelegate.h"
#import "LocDetailInfo.h"
#import "Advertise.h"
#import "ZXYPlaceDetailViewController.h"
#import "ZXYUserInfoTableViewCell.h"
@interface ZXYMainViewController ()<NetHelperDelegate,MBProgressHUDDelegate,PlacePageBtnClickDelegate,SelectHomePageItemDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *allBtnS;   /** < 用来保存三个标签按钮 */
    NSArray *allLabelS; /** < 用来保存三个标签 */
    __weak IBOutlet UIView *contentView; /** < 用来保存三个主页面 */
    MBProgressHUD *HUD; /** < loading */
    ZXYNETHelper *netHelp; //网络帮助文件
    ZXYUserDefault *userDefault; //用户设置文件
    ZXYProvider *dataProvider;   //数据库操作文件
    __weak IBOutlet UIButton *settingBtn;
    BOOL isUserTableShow;
    UIView *backView;
}
@property (strong, nonatomic) IBOutlet UIView *userInfoTable;
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
- (IBAction)userInfo:(id)sender;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 * 初始化页面
 *
 */
- (void)initPlaceFavPage
{
    self.placePage = [[ZXYPlaceViewController alloc] initWithNibName:@"ZXYPlaceViewController" bundle:nil];
    self.placePage.delegate = self;
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
        NSString *dateStringUser    = [userDefault getUserDefaultUpdateTimeString:USERUPDATETIME_AD];
        if(dateStringService.integerValue>dateStringUser.integerValue)
        {
            NSLog(@"取数据了啊");
            // !!!:现在开始获取广告数据
            [userDefault writeUserUpdateTimeString:dateStringService andType:USERUPDATETIME_AD];
            [netHelp requestStart:URL_getAdvertise withParams:nil bySerialize:[AFXMLParserResponseSerializer serializer]];
        }
        else
        {
            [self checkISDataUpdata];
            self.homePage = [[ZXYHomePageViewController alloc] initWithNibName:NSStringFromClass([ZXYHomePageViewController class]) bundle:nil];
            self.homePage.delegate = self;
            [contentView addSubview:self.homePage.view];
            self.homePage.view.frame = CGRectMake(0, 0, Screen_width, contentView.frame.size.height);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
        [HUD setLabelText:@"网络连接错误"];
        
    }];
    
}

// !!!:数据获取成功 继续获取data更新
- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object
{
    
   
    NSData *responseData = [opertation responseData];
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    [dataProvider saveDataToCoreDataArr:responseArray withDBNam:@"Advertise" isDelete:YES];
    
    self.homePage = [[ZXYHomePageViewController alloc] initWithNibName:NSStringFromClass([ZXYHomePageViewController class]) bundle:nil];
    self.homePage.delegate = self;
    [contentView addSubview:self.homePage.view];
    self.homePage.view.frame = CGRectMake(0, 0, Screen_width, contentView.frame.size.height);
    NSLog(@"%@",opertation.responseString);
    [self checkISDataUpdata];
    
}

// !!!:获取data更新、数据
- (void)checkISDataUpdata
{
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"data",@"type", nil];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation POST:URL_getLastVersion parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        NSString *serviceDate = [operation responseString];
        NSString *localDate   = [userDefault getUserDefaultUpdateTimeString:USERUPDATETIME_DATA];
        if(serviceDate.integerValue>localDate.integerValue)
        {
            AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
            [mulDic setObject:serviceDate forKey:@"enddata"];
            [mulDic setObject:localDate forKey:@"begaindata"];
            [mulDic setObject:[NSNumber numberWithInt:1] forKey:@"pageno"];
            [mulDic setObject:@"data" forKey:@"type"];
            [operation POST:URL_GetData parameters:mulDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *responseArr = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
                NSMutableArray *allNewArr = [[NSMutableArray alloc] init];
                for(int i = 0;i<responseArr.count;i++)
                {
                    NSDictionary *currentDic = [responseArr objectAtIndex:i];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:currentDic];
                    [dic removeObjectForKey:@"opdate"];
                    [dic removeObjectForKey:@"optype"];
                    [dic removeObjectForKey:@"index"];
                    [allNewArr addObject:dic];
                }
                [dataProvider saveDataToCoreDataArr:allNewArr withDBNam:@"LocDetailInfo" isDelete:YES groupByKey:@"cid"];
                [userDefault writeUserUpdateTimeString:serviceDate andType:USERUPDATETIME_DATA];
                [HUD hide:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error is %@",error);
                [HUD hide:YES];
            }];
        }
        else
        {
            [HUD hide:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [HUD hide:YES];
    }];

}

// !!!:场所按钮事件的代理 ，修改在这里
- (void)clickBtnAt:(id)sender
{
    UIButton *clickBtn = (UIButton *)sender;
    NSInteger tagOfBtn = [clickBtn tag];
    NSInteger locType  = 0;
    NSString *title;
    switch (tagOfBtn)
    {
        case 101:{
        
            locType = 1;
            title = @"酒店";
            //酒店1
                     break;
                 }
        case 102:{
            locType = 4;
            title = @"餐厅";
            //餐厅4
            break;
        }
        case 103:{
            
            locType = 2;
            title = @"酒吧";
            //酒吧2
            break;
        }
        case 104:{
            
            locType = 5;
            title = @"购物";
            //购物5
            break;
        }
        case 105:{
            
            locType = 6;
            title = @"高尔夫";
            //高尔夫6
            break;
        }
        case 106:{
            
            locType = 7;
            title = @"旅行";
            //旅行7
            break;
        }
        case 107:{
            
            locType = 3;
            title = @"洗浴";
            //洗浴3
            break;
        }
        case 108:{
            
            locType = 8;
            title = @"其他";
            //其他
            break;
        }
            
        default:
            break;
    }
    ZXYPlaceLocalListViewController *placeList = [[ZXYPlaceLocalListViewController alloc] initWIthLocType:[NSString stringWithFormat:@"%ld",(long)locType]];
    placeList.title = title;
    [self.navigationController pushViewController:placeList animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 会员信息页面
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCellIdentifier = @"userCellIdentifier";
    ZXYUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZXYUserInfoTableViewCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[ZXYUserInfoTableViewCell class]])
            {
                cell = (ZXYUserInfoTableViewCell *)oneObject;
            }
        }
    }
    if(indexPath.row == 0)
    {
        cell.titleImage.image = [UIImage imageNamed:@"vip_collectU"];
        cell.titleLbl.text    = NSLocalizedString(@"vip_collect", nil);
    }
    else if(indexPath.row == 1)
    {
        cell.titleImage.image = [UIImage imageNamed:@"vip_manU"];
        cell.titleLbl.text    = NSLocalizedString(@"vip_login", nil);
    }
    else
    {
        cell.titleImage.image = [UIImage imageNamed:@"vip_setU"];
        cell.titleLbl.text    = NSLocalizedString(@"vip_setting", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - 三个按钮
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
#pragma mark - 三个按钮结束
// !!!:切换三个主页面的方法
- (void)choosePageByPageIndex:(mainView_TypeOfViewController)type withBtn:(UIButton *)btn
{
    //页面切换、改变图片
    if(type == ZXYPlacePage)
    {
        self.placePage = [[ZXYPlaceViewController alloc] initWithNibName:@"ZXYPlaceViewController" bundle:nil];
        self.placePage.delegate = self;
        self.placePage.view.frame = CGRectMake(Screen_width, 0, self.placePage.view.frame.size.width, contentView.frame.size.height);
        if(!iPhone5)
        {
            self.placePage.scrollViewOfBtn.contentSize = CGSizeMake(320, 465);
        }
        [contentView addSubview:self.placePage.view];
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_down"];
        contentView.frame = CGRectMake(-Screen_width, contentView.frame.origin.y, Screen_width*3, contentView.frame.size.height);
    }
    else
    {
        self.footImageView.image = [UIImage imageNamed:@"mainView_foot_up"];
        if(type == ZXYFavorPage)
        {

            self.favorPage = [[ZXYFavorViewController alloc] init];
            self.favorPage.view.frame = CGRectMake(Screen_width*2, 0, self.favorPage.view.frame.size.width, contentView.frame.size.height);
            [contentView addSubview:self.favorPage.view];
            contentView.frame = CGRectMake(-Screen_width*2, contentView.frame.origin.y, Screen_width*3, contentView.frame.size.height);
        }
        else
        {
            self.homePage = [[ZXYHomePageViewController alloc] initWithNibName:NSStringFromClass([ZXYHomePageViewController class]) bundle:nil];
            self.homePage.delegate = self;
            [contentView addSubview:self.homePage.view];
            self.homePage.view.frame = CGRectMake(0, 0, Screen_width, contentView.frame.size.height);
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

- (void)selectHomePageItem:(Advertise *)ad
{
    NSArray *allLocs = [dataProvider readCoreDataFromDB:@"LocDetailInfo" withContent:ad.cid andKey:@"cid"] ;
    if(allLocs.count > 0)
    {
        LocDetailInfo *locDetail = [allLocs objectAtIndex:0];
        ZXYPlaceDetailViewController *detailView = [[ZXYPlaceDetailViewController alloc] initWithLocDetail:locDetail];
        detailView.isAdvertise = YES;
        [self.navigationController pushViewController:detailView animated:YES];
    }
   
    
}

- (IBAction)userInfo:(id)sender
{
    if(isUserTableShow)
    {
        isUserTableShow = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.userInfoTable.frame = CGRectMake(settingBtn.frame.origin.x, settingBtn.frame.origin.y+settingBtn.frame.size.height, 0, 0);
        } completion:^(BOOL finished) {
            [self.userInfoTable removeFromSuperview];
            [backView removeFromSuperview];
        }];
    }
    else
    {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
        backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:backView];
        isUserTableShow = YES;
        self.userInfoTable.frame = CGRectMake(settingBtn.frame.origin.x, settingBtn.frame.origin.y+settingBtn.frame.size.height, 0, 0);
        [self.view addSubview:self.userInfoTable];
        [UIView animateWithDuration:0.3 animations:^{
            self.userInfoTable.frame = CGRectMake(settingBtn.frame.origin.x, settingBtn.frame.origin.y+settingBtn.frame.size.height, 157, 3*44);
            
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isUserTableShow)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        if(CGRectContainsPoint(backView.frame, point))
        {
            [self userInfo:nil];
        }
    }
    else
    {
        return;
    }
}
@end
