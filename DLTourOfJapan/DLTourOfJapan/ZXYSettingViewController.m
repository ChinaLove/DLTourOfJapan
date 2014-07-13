//
//  ZXYSettingViewController.m
//  DLTourOfJapan
//
//  Created by developer on 14-7-11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYSettingViewController.h"
#import "ZCAddressBook.h"
#import "MBProgressHUD.h"
#import "ZXYUserLoginViewController.h"
#import "UserInfo.h"
#import "ZXYProvider.h"
@interface ZXYSettingViewController ()<UIAlertViewDelegate,UITextViewDelegate>
{
    
    __weak IBOutlet UILabel *LSNameLbl;
    __weak IBOutlet UILabel *LSAddressLbl;
    __weak IBOutlet UILabel *LSPhone;
    __weak IBOutlet UILabel *LSFax;
    __weak IBOutlet UILabel *LSEmail;
    
    __weak IBOutlet UILabel *CCTitle;
    
    __weak IBOutlet UILabel *ccDetail;
    __weak IBOutlet UILabel *_24Hour;
    __weak IBOutlet UILabel *commentLbl;
    __weak IBOutlet UITextView *commentText;
    __weak IBOutlet UIScrollView *contentScroll;
    __weak IBOutlet UILabel *lsAdd;
    __weak IBOutlet UILabel *lsPhone;
    __weak IBOutlet UILabel *lsFax;
    __weak IBOutlet UILabel *lsEmail;
    ZCAddressBook *addressBook;
    BOOL isLSCall;
    MBProgressHUD *progress;
    CGRect currentFrame;
    UIToolbar *topBar;
    ZXYProvider *dataProvider;
}
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *colorForYou;
- (IBAction)ccCallAction:(id)sender;
- (IBAction)ccAddPersonAction:(id)sender;
- (IBAction)lsCallAction:(id)sender;
- (IBAction)addPersonAction:(id)sender;
- (IBAction)submitCommentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)backViewAction:(id)sender;

@end

@implementation ZXYSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLSCall = NO;
        addressBook = [ZCAddressBook shareControl];
        dataProvider = [ZXYProvider sharedInstance];
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    currentFrame = self.view.frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:NSLocalizedString(@"public_finish", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtn,rightBtnItem, nil];
    [topBar setItems:array];
    [commentText setInputAccessoryView:topBar];
    commentText.delegate = self;
    self.titleLbl.text = NSLocalizedString(@"set_Title", nil);
    for(UILabel *lbl in self.colorForYou)
    {
        [lbl setTextColor:[UIColor colorWithRed:0.2627 green:0.3922 blue:0.6824 alpha:1]];
    }
    LSNameLbl.text = NSLocalizedString(@"set_LSName", nil);
    LSAddressLbl.text = NSLocalizedString(@"set_add", nil);
    LSPhone.text      = NSLocalizedString(@"set_LSphone", nil);
    LSFax.text        = NSLocalizedString(@"set_LSFax", nil);
    LSEmail.text      = NSLocalizedString(@"set_LSMail", nil);
    
    CCTitle.text      = NSLocalizedString(@"set_CC", nil);
    ccDetail.text     = NSLocalizedString(@"set_CCContent", nil);
    _24Hour.text      = NSLocalizedString(@"set_CC24Hour", nil);
    lsEmail.text      = NSLocalizedString(@"set_lsEmail", nil);
    lsAdd.text        = NSLocalizedString(@"set_Add", nil);
    lsFax.text        = NSLocalizedString(@"set_lsFax", nil);
    lsPhone.text      = NSLocalizedString(@"set_lsPhone", nil);
    
    
    commentLbl.text   = NSLocalizedString(@"set_Comment", nil);
    commentText.backgroundColor = [UIColor colorWithRed:0.9059 green:0.9059 blue:0.9059 alpha:1];
    contentScroll.contentSize = CGSizeMake(self.view.frame.size.width, 498);
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    
    progress.dimBackground = YES;
    [self.view addSubview:progress];
    // Do any additional setup after loading the view from its nib.
}

- (void)hideKeyBoard
{
    [commentText resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = currentFrame;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, currentFrame.origin.y-240, currentFrame.size.width, currentFrame.size.height);
    }];
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([ZXYTourOfJapanHelper isUserLogin])
    {
        return YES;
    }
    else
    {
        ZXYUserLoginViewController *login = [[ZXYUserLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
}

- (IBAction)backViewAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ccCallAction:(id)sender
{
    isLSCall = NO;
    UIAlertView *phoneAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PlacePage_Phone_IS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"PlacePage_PhoneY", nil), nil];
    [phoneAlert show];
}

- (IBAction)ccAddPersonAction:(id)sender
{
    NSString *contactName = NSLocalizedString(@"set_CC", nil);
    NSString *phoneNum = CCPhoneNum;
    if([addressBook existPhone:phoneNum]==ABHelperExistSpecificContact)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"set_PhoneExist", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [progress setMode:MBProgressHUDModeText];
    progress.labelText = NSLocalizedString(@"set_PhoneSuccess", nil);
    [addressBook addContactName:contactName phoneNum:phoneNum withLabel:nil];
    [progress show:YES];
    [progress hide:YES afterDelay:2];
    
}

- (IBAction)lsCallAction:(id)sender
{
    isLSCall = YES;
    UIAlertView *phoneAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PlacePage_Phone_IS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"PlacePage_PhoneY", nil), nil];
    [phoneAlert show];
}

- (IBAction)addPersonAction:(id)sender
{
    NSString *contactName = NSLocalizedString(@"set_LSName", nil);
    NSString *phoneNum = LSPhoneNum;
    if([addressBook existPhone:phoneNum] == ABHelperExistSpecificContact)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"set_PhoneExist", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [progress setMode:MBProgressHUDModeText];
    progress.labelText = NSLocalizedString(@"set_PhoneSuccess", nil);
   [addressBook addContactName:contactName phoneNum:phoneNum withLabel:nil];
    [progress show:YES];
    [progress hide:YES afterDelay:2];
}

- (IBAction)submitCommentAction:(id)sender
{
    if([ZXYTourOfJapanHelper isUserLogin])
    {
        progress.mode = MBProgressHUDModeIndeterminate;
        [progress show:YES];
        UserInfo *user = [[dataProvider readCoreDataFromDB:@"UserInfo"] objectAtIndex:0];
        NSString *urlString = [NSString stringWithFormat:@"%@service=Advice&method=addAdvice&iduser=%d&stcontent=%@",URL_Inner,user.userID.intValue,commentText.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation.responseString);
            [progress hide:YES];
            progress.labelText = NSLocalizedString(@"set_SubSuccess", nil);
            [progress show:YES];
            [progress hide:YES afterDelay:2];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [progress hide:YES];
            progress.labelText = NSLocalizedString(@"set_SubFail", nil);
            [progress show:YES];
            [progress hide:YES afterDelay:2];
        }];
        [operation start];
        
    }
    else
    {
        ZXYUserLoginViewController *login = [[ZXYUserLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        
        NSString *phoneNum ;
        if(isLSCall)
        {
            phoneNum = LSPhoneNum;
        }
        else
        {
            phoneNum = CCPhoneNum;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
@end
