//
//  ZXYUserInfoViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYUserInfoViewController.h"
#import "UserInfo.h"
#import "ZXYUserChangePass.h"
@interface ZXYUserInfoViewController ()
{
    ZXYProvider *dataProvider;
}
- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLbl;
@property (weak, nonatomic) IBOutlet UIButton *changePassBtn;
- (IBAction)changePassAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
- (IBAction)logOutAction:(id)sender;

@end

@implementation ZXYUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataProvider = [ZXYProvider sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLbl.text = NSLocalizedString(@"vip_info", nil);
    UserInfo *userInfo = [[dataProvider readCoreDataFromDB:@"UserInfo"] objectAtIndex:0];
    self.userEmailLbl.text = userInfo.userEmail;
    self.userEmailLbl.textColor = vip_loginBtnColor;
    
    [self.changePassBtn setBackgroundColor:vip_loginBtnColor];
    [self.changePassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changePassBtn setTitle:NSLocalizedString(@"vip_changePass", nil) forState:UIControlStateNormal];
    
    [self.logOutBtn setTitle:NSLocalizedString(@"vip_logOut", nil) forState:UIControlStateNormal];
    [self.logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logOutBtn setBackgroundColor:vip_loginBtnColor];
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

- (IBAction)backView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changePassAction:(id)sender
{
    NSString *nibName;
    if(iPhone5)
    {
        nibName = @"ZXYUserChangePass";
    }
    else
    {
        nibName = @"ZXYUserChangePass_iphone4";
    }
    ZXYUserChangePass *changeVC = [[ZXYUserChangePass alloc] initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:changeVC animated:YES];
}
- (IBAction)logOutAction:(id)sender
{
    [ZXYTourOfJapanHelper loginOut];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
