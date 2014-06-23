//
//  ShowBigImageViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-23.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ShowBigImageViewController.h"

@interface ShowBigImageViewController ()
{
    CGFloat zs ;
    NSData *_imageData;
    BOOL isBarHidden;
   // UITabBar *tabBar;
    BOOL isSave;
    __weak IBOutlet UIActivityIndicatorView *circulProgress;
}
@property (nonatomic,strong)NSData *imageData;
@end

@implementation ShowBigImageViewController
@synthesize imageData = _imageData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithImageData:(NSData *)imageData
{
    self = [super initWithNibName:@"ShowBigImageViewController" bundle:nil];
    if(self)
    {
        self.imageData = imageData;
        zs = 2;
        isBarHidden = NO;
        isSave = NO;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bigImageScroll.delegate = self;
    self.bigImageView.image = [UIImage imageWithData:self.imageData];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 45, 45);
    [backBtn setImage:[UIImage imageNamed:@"placePage_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"AllNavi"] forBarMetrics:UIBarMetricsDefault];
    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNaviBar)];
//    tapGes.numberOfTapsRequired = 1;
//    [self.bigImageView addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *tapGesTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleTheImage)];
    tapGesTwo.numberOfTapsRequired = 2;
    [self.bigImageScroll addGestureRecognizer:tapGesTwo];
//    tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
//    UITabBarItem *item = [[UITabBarItem alloc] init];
//    item.selectedImage = [UIImage imageNamed:@"download_icon"];
//    
//    item.image = [UIImage imageNamed:@"download_icon"];
//    //[self.navigationController setTabBarItem:item];
//    NSArray *items = [NSArray arrayWithObjects:item, nil];
//    [tabBar setItems:items];
//    [tabBar setDelegate:self];
//    [tabBar setTintColor:[UIColor grayColor]];
//    [self.view addSubview:tabBar];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    UIImage *imageForView = [UIImage imageWithData:self.imageData];
    float radio = imageForView.size.height/imageForView.size.width;
    if(!iPhone5)
    {
        
    }
    if(iPhone5)
    {
        [self.bigImageView setFrame:CGRectMake(0, self.bigImageView.frame.origin.y, self.view.frame.size.width, 320*radio)];
    }
    else
    {
        [self.bigImageView setFrame:CGRectMake(0, self.bigImageView.frame.origin.y+45, self.view.frame.size.width, 320*radio)];
    }
    if(!iPhone5)
    {
       // tabBar.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    }
    //self.bigImageScroll.frame = CGRectMake(0, 0, imageForView.size.width, imageForView.size.height);
    self.bigImageScroll.contentSize = CGSizeMake(self.bigImageView.bounds.size.width, self.bigImageView.bounds.size.height+45);
    NSLog(@"size is %f   ,   %f",imageForView.size.width,imageForView.size.height);
    [super viewWillAppear:animated];
    //[self.bigImageScroll setContentSize:CGSizeMake(20000,20000)];
}

- (void)backViewBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNaviBar
{
    
    if(!isBarHidden)
    {
        isBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        isBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)scaleTheImage
{
    if(self.navigationController.navigationBar.isHidden == YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
       // [tabBar setFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
        [UIView commitAnimations];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
       // [tabBar setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
        [UIView commitAnimations];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }

    CGFloat zoomSize = zs;
    zs = (zoomSize == 1)?3.0:1.0;
    [self.bigImageScroll setZoomScale:zoomSize animated:YES];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if([touch tapCount])
    {
        CGFloat zoomSize = zs;
        zoomSize = (zoomSize == 1)?2.0:1;
        [self.bigImageScroll setZoomScale:zoomSize];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    [circulProgress setHidden:NO];
    [circulProgress startAnimating];
    [NSThread detachNewThreadSelector:@selector(saveThread) toTarget:self withObject:nil];
}

- (void)saveFinish
{
    [circulProgress setHidden:YES];
    [circulProgress stopAnimating];
    
}

- (void)saveThread
{
     UIImageWriteToSavedPhotosAlbum([self.bigImageView image], nil, nil,nil);
    [self performSelectorOnMainThread:@selector(saveFinish) withObject:nil waitUntilDone:YES];
}



@end
