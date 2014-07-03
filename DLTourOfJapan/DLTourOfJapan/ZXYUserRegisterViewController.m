//
//  ZXYUserRegisterViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYUserRegisterViewController.h"
#import "MBProgressHUD.h"
@interface ZXYUserRegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIToolbar *topBar;
    CGRect currentFrame;
    MBProgressHUD *progress;
    UIAlertView *successAlert;
}
- (IBAction)firstNext:(id)sender;
- (IBAction)secondNext:(id)sender;
- (IBAction)thirdDown:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

- (IBAction)backView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
- (IBAction)registAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *passLbl;
@property (weak, nonatomic) IBOutlet UILabel *confirmLbl;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageLine;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;

@end

@implementation ZXYUserRegisterViewController

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
    [self initTopBar];
    [self initColor];
    currentFrame = self.view.frame;
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    // Do any additional setup after loading the view from its nib.
}

- (void)initTopBar
{
    self.titleLbl.text = NSLocalizedString(@"vip_regist", nil);
    topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtn,rightBtnItem, nil];
    [topBar setItems:array];
    [self.emailText setInputAccessoryView:topBar];
    [self.passwordText setInputAccessoryView:topBar];
    [self.confirmPassText setInputAccessoryView:topBar];
    [self.confirmPassText setDelegate:self];
}

- (void)initColor
{
    self.registBtn.backgroundColor = vip_loginBtnColor;
    [self.registBtn setTitle:NSLocalizedString(@"vip_registerBtn", nil) forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.emailLbl.textColor = vip_loginBtnColor;
    self.emailText.delegate = self;
    self.passLbl.textColor = vip_loginBtnColor;
    self.emailLbl.text = NSLocalizedString(@"vip_email", nil);
    self.passLbl.text = NSLocalizedString(@"vip_password", nil);
    self.confirmLbl.text = NSLocalizedString(@"vip_passConfirm", nil);
    self.emailText.textColor = vip_loginBtnColor;
    self.passwordText.textColor = vip_loginBtnColor;
    self.confirmPassText.textColor = vip_loginBtnColor;
    self.confirmLbl.textColor = vip_loginBtnColor;
    for(UIImageView *image in self.imageLine)
    {
        image.backgroundColor = vip_loginBtnColor;
    }
    
}

- (void)hideKeyBoard
{
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.confirmPassText resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.emailText)
    {
        if([string isEqualToString:@""] || [string isEqualToString:@"\n"])
        {
            return YES;
        }
        NSLog(@"string is %@",string);
        NSString *emailText = @"[A-Z0-9a-z._%+-@]";
        NSPredicate *emailRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailText];
        return [emailRegex evaluateWithObject:string];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.confirmPassText)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-50, currentFrame.size.width, currentFrame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.confirmPassText)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = currentFrame;
        }];
    }
}

-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
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
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registAction:(id)sender
{
    if(![ZXYNETHelper isNETConnect])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"AppDelegate_NetConnect", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if([self validateRe])
    {
        [progress setLabelText:NSLocalizedString(@"HUD_Regist", nil)];
        [progress show:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@service=UserManager&method=addUser&useremail=%@&userpass=%@&usernicename=nfh&idsource=a&idlangid=3&idcity=2&iduser!",URL_Inner,self.emailText.text,self.passwordText.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",[operation responseString]);
            NSString *xmlString = [ZXYTourOfJapanHelper toMyXML:[operation responseString]];
            [self parseXML:xmlString];
            [progress hide:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [progress hide:YES];
            NSLog(@"%@",error);
        }];
        [operation start];
    }
    else
    {
        return;
    }
}

-(void)parseXML:(NSString *)xmlString
{
    NSData *xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:xmlData encoding:NSUTF8StringEncoding options:0 error:nil];
    NSString *userID ;
    CXMLElement *rootElement = [document rootElement];
    for(CXMLElement *element in rootElement.children)
    {
        if([element isKindOfClass:[CXMLElement class]])
        {
            if([element.name isEqualToString:@"id"])
            {
                userID = element.stringValue;
            }
            if([element.name isEqualToString:@"adduserflag"])
            {
                if([element.stringValue isEqualToString:@"3"])
                {
                    NSLog(@"注册成功");
                    
                    successAlert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"HUD_RegistSuccess", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
                    [successAlert show];
                    
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"RepeatEmail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateRe
{
    if([[self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONEmail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(![self isValidateEmail:self.emailText.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONEmailFormat", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    
    if(self.passwordText.text.length == 0 || self.confirmPassText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONPassword", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(self.passwordText.text.length < 6 || self.confirmPassText.text.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LessThanSix", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(![self.passwordText.text isEqualToString:self.confirmPassText.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NONSameOfTwoPass", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
        return YES;

}


- (IBAction)firstNext:(id)sender
{
    [self.emailText resignFirstResponder];
    [self.passwordText becomeFirstResponder];
}

- (IBAction)secondNext:(id)sender
{
    [self.passwordText resignFirstResponder];
    [self.confirmPassText becomeFirstResponder];
}

- (IBAction)thirdDown:(id)sender
{
    [self registAction:nil];
}
@end
