//
//  ZXYUserLoginViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYUserLoginViewController.h"
#import "ZXYUserRegisterViewController.h"

@interface ZXYUserLoginViewController ()<UITextFieldDelegate>
{
    UIToolbar *topBar;
    __weak IBOutlet UIImageView *backImage;
}

- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *secureText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *lineText;

@end

@implementation ZXYUserLoginViewController

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
    self.titleLabel.text = NSLocalizedString(@"vip_login", nil);
    [self initColor];
    [self initTopBar];
}

- (void)initTopBar
{
    topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:NSLocalizedString(@"public_finish", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtn,rightBtnItem, nil];
    [topBar setItems:array];
    [self.emailText setInputAccessoryView:topBar];
    [self.secureText setInputAccessoryView:topBar];
}

- (void)initColor
{
    self.loginBtn.backgroundColor = vip_loginBtnColor;
    self.registerBtn.backgroundColor = vip_loginBtnColor;
    [self.loginBtn setTitle:NSLocalizedString(@"vip_loginBtn", nil) forState:UIControlStateNormal];
    [self.registerBtn setTitle:NSLocalizedString(@"vip_registerBtn", nil) forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.emailLbl.textColor = vip_loginBtnColor;
    self.emailText.delegate = self;
    self.passwordLabel.textColor = vip_loginBtnColor;
    self.emailLbl.text = NSLocalizedString(@"vip_email", nil);
    self.passwordLabel.text = NSLocalizedString(@"vip_password", nil);
    self.emailText.textColor = vip_loginBtnColor;
    self.secureText.textColor = vip_loginBtnColor;
    for(UIImageView *image in self.lineText)
    {
        image.backgroundColor = vip_loginBtnColor;
    }

}

- (void)hideKeyBoard
{
    [self.emailText resignFirstResponder];
    [self.secureText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginAction:(id)sender {
    if(![ZXYNETHelper isNETConnect])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AppDelegate_NetConnect", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([self validateText])
    {
        NSLog(@"ok!");
        NSString *urlAsString = [NSString stringWithFormat:@"%@service=UserManager&method=storeAndviewUser&useremail=%@&userpass=%@"
                                 ,URL_Inner,self.emailText.text,self.secureText.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAsString]];
        AFHTTPRequestOperation *opertation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        opertation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [opertation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"%@",[operation responseString]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error is %@",error);
        }];
        [opertation start];
    }
    else
    {
        return;
    }
}

- (BOOL)validateText
{

    if([[self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONEmail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if(self.secureText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONPassword", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (IBAction)registerAction:(id)sender
{
    NSString *nibName ;
    if(iPhone5)
    {
        nibName = @"ZXYUserRegisterViewController";
    }
    else
    {
        nibName = @"ZXYUserRegisterViewController_iPhone4";
    }
    ZXYUserRegisterViewController *regist = [[ZXYUserRegisterViewController alloc] initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    NSLog(@"string is %@",string);
    NSString *emailText = @"[A-Z0-9a-z._%+-@]";
    NSPredicate *emailRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailText];
    
    return [emailRegex evaluateWithObject:string];
}
@end
