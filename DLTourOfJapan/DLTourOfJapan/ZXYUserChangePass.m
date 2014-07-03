//
//  ZXYUserChangePass.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYUserChangePass.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
@interface ZXYUserChangePass ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIToolbar *topBar;
    CGRect currentFrame;
    MBProgressHUD *progress;
    ZXYProvider *dataProvider;
}
- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *oriPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *oriPassText;
@property (weak, nonatomic) IBOutlet UILabel *nPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *nPassText;
@property (weak, nonatomic) IBOutlet UILabel *confirmPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageLine;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitAction:(id)sender;
@end

@implementation ZXYUserChangePass

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
    self.titleLbl.text = NSLocalizedString(@"vip_changePass", nil);
    [super viewDidLoad];
    [self initColor];
    topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtn,rightBtnItem, nil];
    [topBar setItems:array];
    [self.oriPassText setInputAccessoryView:topBar];
    [self.nPassText setInputAccessoryView:topBar];
    [self.confirmPassText setInputAccessoryView:topBar];
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    // Do any additional setup after loading the view from its nib.
}

- (void)initColor
{
    self.oriPassLbl.textColor = vip_loginBtnColor;
    self.oriPassLbl.text = NSLocalizedString(@"vip_oriPass", nil);
    
    self.nPassLbl.textColor = vip_loginBtnColor;
    self.nPassLbl.text   = NSLocalizedString(@"vip_newPass", nil);
    
    self.oriPassText.textColor = vip_loginBtnColor;
    self.nPassText.textColor = vip_loginBtnColor;
    self.nPassText.delegate = self;
    self.confirmPassLbl.textColor = vip_loginBtnColor;
    self.confirmPassLbl.text      = NSLocalizedString(@"vip_passConfirm", nil);
    
    self.confirmPassText.textColor = vip_loginBtnColor;
    self.confirmPassText.delegate  = self;
    self.commitBtn.backgroundColor = vip_loginBtnColor;
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn setTitle:NSLocalizedString(@"Certain", nil) forState:UIControlStateNormal];
    
    for(UIImageView *image in self.imageLine)
    {
        [image setBackgroundColor:vip_loginBtnColor];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if(textField == self.nPassText)
            {
                self.view.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-40, currentFrame.size.width, currentFrame.size.height);
            }
            else
            {
                self.view.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-80, currentFrame.size.width, currentFrame.size.height);
            }
        }];
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    currentFrame = self.view.frame;
}

- (void)hideKeyBoard
{
    if(!iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = currentFrame;
        }];
    }
    [self.oriPassText resignFirstResponder];
    [self.nPassText resignFirstResponder];
    [self.confirmPassText resignFirstResponder];
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
- (IBAction)commitAction:(id)sender
{
    if(![ZXYNETHelper isNETConnect])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AppDelegate_NetConnect", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if([self isValidate])
    {
        //NSString *pathUrl = [NSString stringWithFormat:@"%@service=ChangePassword&method=viewChangePassword&useremail=%@&userpass=%@",URL_Inner,loclop.nametext,self.passwordText.text];
        [progress show:YES];
        UserInfo *userInfo = [[dataProvider readCoreDataFromDB:@"UserInfo"] objectAtIndex:0];
        NSString *urlAsString = [NSString stringWithFormat:@"%@service=UserManager&method=storeAndviewUser&useremail=%@&userpass=%@"
                                 ,URL_Inner,userInfo.userEmail,self.oriPassText.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAsString]];
        AFHTTPRequestOperation *opertation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        opertation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [opertation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if([operation responseString].length == 0)
             {   [progress hide:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"WrongPassword", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
                 [alert show];
                 return ;
             }
             else
             {
                 NSString *pathUrl = [NSString stringWithFormat:@"%@service=ChangePassword&method=viewChangePassword&useremail=%@&userpass=%@",URL_Inner,userInfo.userEmail,self.nPassText.text];
                 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]];
                 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                 operation.responseSerializer = [AFHTTPResponseSerializer serializer];
                 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"@@@@@ %@",operation.responseString);
                     if(operation.responseString.length > 0)
                     {
                         NSString *xmlString = [ZXYTourOfJapanHelper toMyXML:operation.responseString];
                         CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
                         CXMLElement *rootElement = [doc rootElement];
                         for(CXMLElement *element in rootElement.children)
                         {
                             if([element isKindOfClass:[CXMLElement class]])
                             {
                                 if([element.name isEqualToString:@"changeflag"])
                                 {
                                     if([element.stringValue isEqualToString:@"1"])
                                     {
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ChangeSuccess", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
                                         [alert show];

                                     }
                                 }
                             }
                         }
                     }
                     else
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ChangeFail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
                         [alert show];
                         return ;
                     }
                     [progress hide:YES];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error is %@",error);
                     [progress hide:YES];
                 }];
                 [operation start];

                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error is %@",error);
         }];
        [opertation start];

    }
}

- (BOOL)isValidate
{
    if(self.oriPassText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONOriginPass", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;

    }
    if(self.nPassText.text.length == 0 || self.confirmPassText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONNewPass", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(self.nPassText.text.length < 6 || self.confirmPassText.text.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LessThanSix", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(![self.nPassText.text isEqualToString:self.confirmPassText.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONSameOfTwoPass", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
