//
//  SAMProfileViewController.m
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMProfileViewController.h"
#import <AFNetworking.h>
#import "SAMUserPropertiesAndAssets.h"
#import "SVProgressHUD.h"
#import "SwappedOfferDetails.h"
#import "SDWebImage/UIImageView+WebCache.h"

#import "UIScrollView+APParallaxHeader.h"

@interface SAMProfileViewController ()<APParallaxViewDelegate>{
    SAMUserPropertiesAndAssets *userAssets;
    NSMutableArray *swapppedOffers;
    
    BOOL isAlreadySwapped;
    
    BOOL parallaxWithView;
    
    BOOL flagForLocalIndex;
    BOOL flagForGigsIndex;
}

@end
static AFHTTPRequestOperationManager *manager;

@implementation SAMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    
    [self toggle:nil];
    
    
    
    userAssets=[SAMUserPropertiesAndAssets sharedInstance];
    swapppedOffers = [[NSMutableArray alloc] init];
    [self setSwappedOffers];
    
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 170, 200, 25)];
    self.userName.text=  [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"UserName"];
    [self.userName setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.userName];
    
    
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 42, 120, 120)];
    self.profileImage.image = [UIImage imageNamed:@"light_profile_img.png"];
    [self.view addSubview:self.profileImage];
    
    
    
    self.settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settingsBtn addTarget:self
                         action:@selector(ShowSettingsPage:)
               forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"settings.png"];
    [self.settingsBtn setImage:btnImage forState:UIControlStateNormal];
    //[self.settingsBtn setTitle:@"Show View" forState:UIControlStateNormal];
    self.settingsBtn.frame = CGRectMake(self.view.frame.size.width-50, 22, 40, 40.0);
    [self.view addSubview:self.settingsBtn];
    
    DELEGATE.segmentedView = [[BSCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x +20, 220, self.view.frame.size.width-40, 40)];
    DELEGATE.segmentedView.backgroundColor = [UIColor lightGrayColor];
    DELEGATE.segmentedView.delegate=self;
    [DELEGATE.window addSubview:DELEGATE.segmentedView];
    [DELEGATE.segmentedView.localButton setBackgroundColor:[UIColor darkGrayColor]];
    
    flagForLocalIndex = YES;
    flagForGigsIndex=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    DELEGATE.segmentedView.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)toggle:(id)sender {
    /**
     *  For demo purposes this view controller either adds a parallaxView with a custom view
     *  or a parallaxView with an image.
     */
    if(parallaxWithView == NO) {
        // add parallax with view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images.jpeg"]];
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        //         DELEGATE.segmentedView = [[BSCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x +20, 220, self.view.frame.size.width-40, 40)];
        //         DELEGATE.segmentedView.backgroundColor = [UIColor lightGrayColor];
        //         DELEGATE.segmentedView.delegate=self;
        //        //[self.saTableView addParallaxWithView:DELEGATE.segmentedView andHeight:40];
        //        [DELEGATE.window addSubview:DELEGATE.segmentedView];
        //        [DELEGATE.segmentedView.localButton setBackgroundColor:[UIColor darkGrayColor]];
        
        [self.swappedTable addParallaxWithView:imageView andHeight:300];
        
        parallaxWithView = YES;
        
        // Update the toggle button
        //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        //[self.navigationItem setRightBarButtonItem:barButton];
    }
    else {
        // add parallax with image
        [self.swappedTable addParallaxWithImage:[UIImage imageNamed:@"images.jpeg"] andHeight:300 andShadow:YES];
        parallaxWithView = NO;
        // Update the toggle button
        //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        //[self.navigationItem setRightBarButtonItem:barButton];
    }
    
    /**
     *  Setting a delegate for the parallaxView will allow you to get callbacks for when the
     *  frame of the parallaxView changes.
     *  Totally optional thou.
     */
    self.swappedTable.parallaxView.delegate = self;
    
    
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
    //NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
    
    NSLog(@"frame.origin.x===%f frame.origin.y%f",frame.origin.x,frame.origin.y);
    
    //if(frame.origin.y)
    
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
    //NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
    
    //DELEGATE.segmentedView.frame = frame;
    
    
    if(frame.origin.y>=-260){
        DELEGATE.segmentedView.alpha=0;
        self.userName.alpha=0;
    }
    else{
        DELEGATE.segmentedView.alpha=1;
        self.userName.alpha=1;
    }
    
    
    if(frame.origin.y>=-165){
        self.profileImage.alpha=0;
    }
    else{
        self.profileImage.alpha=1;
    }
    
    
    if(frame.origin.y>=-90){
        self.settingsBtn.alpha=0;
    }
    else{
        self.settingsBtn.alpha=1;
        
    }
}



#pragma mark-
#pragma mark- Get Data for Swapped Table View

-(void)setSwappedOffers{
    [SVProgressHUD showWithStatus:@"Loading..."];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[userAssets getUserID]] forHTTPHeaderField:@"UserId"];
    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@",BASE_URL,USERDETAILS];
    
    [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *registrationInfo=(NSDictionary *) responseObject;
        
        if([[registrationInfo objectForKey:@"Success"] intValue]==1&&[[registrationInfo objectForKey:@"ErrorCode"] intValue]==0){
            
            for(NSDictionary *dic in (NSArray *)[(NSDictionary *)[responseObject objectForKey:@"ResponseResult"] objectForKey:@"GigsOfferList"]){
                
                SwappedOfferDetails *swappedItem =[[SwappedOfferDetails alloc] initWithDictionary:dic];
                [swapppedOffers addObject:swappedItem];
            }
            
        }
        [SVProgressHUD dismiss];
        [self.swappedTable reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Request failure. %@",error);
             [SVProgressHUD dismiss];
         }];
}


#pragma mark-
#pragma mark- Action method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(flagForGigsIndex==YES){
        
        return  self.gigsOffers.count;
    }
    else if (flagForLocalIndex==YES){
        
        return [self.localOffers count];
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAMTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"swappedOfferCell"];
    SwappedOfferDetails *offer =[swapppedOffers objectAtIndex:indexPath.row];
    
    cell.ppTitle.text= offer.Title;
    cell.ppSubTitle.text=offer.Title;
    //cell.ppDistance.text = [NSString stringWithFormat:@"%f",offer.Distance];
    cell.ppFollowers.text = [NSString stringWithFormat:@"%ld", (long)offer.RequiredMinimumInstagramFollowers];
    
    
    if (offer.PictureUrl) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = cell.imageView;
        [cell.ppImageView sd_setImageWithURL:[NSURL URLWithString:offer.PictureUrl]
                            placeholderImage:nil
                                     options:SDWebImageProgressiveDownload
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        if (!activityIndicator) {
                                            [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                        }
                                    }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   }];
    }
    
    return cell;
}
#pragma mark-
#pragma mark- Action method

-(IBAction)ShowSettingsPage:(id)sender{
    
    
    DELEGATE.segmentedView.hidden=YES;
    SAMSettingsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
#pragma mark- BaseViewControllerDelegate method

- (void)loadView:(UIButton *)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if(sender.tag==1){
        DELEGATE.segmentedView.hidden=YES;
        SocialAddMarketViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==2){
        DELEGATE.segmentedView.hidden=YES;
        SAMMapViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==3){
        DELEGATE.segmentedView.hidden=YES;
        SAMMessageViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma marks- Custom Segment Button View Delegate

-(void)selectedOption:(UIButton*)sender{
    
    UIButton *segmentButton = (UIButton*)sender;
    
    if(segmentButton.tag==1)
    {
        flagForGigsIndex = YES;
        flagForLocalIndex = NO;
        
        [DELEGATE.segmentedView.gigsButton setSelected:YES];
        CATransition *transition = [self setTransitionPropertiesWithType:kCATransitionFromLeft];
        [self.view.layer addAnimation:transition forKey:nil];
        if(!self.gigsOffers.count){
            [SVProgressHUD showWithStatus:@"Loading..."];
            APIManager *manager = [APIManager sharedManager];
            manager.delegate = self;
            NSString *userId = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"UserID"];
            NSLog(@"%@",userId);
            [manager getGigsOffers:userId WithPageIndex:0];
        }
        [self.swappedTable reloadData];
    }
    else
    {
        flagForGigsIndex = NO;
        flagForLocalIndex = YES;
        
        [DELEGATE.segmentedView.localButton setSelected:YES];
        CATransition *transition = [self setTransitionPropertiesWithType:kCATransitionFromRight];
        [self.view.layer addAnimation:transition forKey:nil];
        
        if(!self.localOffers.count){
            [SVProgressHUD showWithStatus:@"Loading..."];
            APIManager *manager = [APIManager sharedManager];
            manager.delegate = self;
            NSString *userId = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"UserID"];
            NSLog(@"%@",userId);
            //[manager getGigsOffers:userId WithPageIndex:0];
            [manager getUserLocalOffers:0];
        }
        
        [self.swappedTable reloadData];
        
    }
    
}

#pragma mark-utility Method.
-(CATransition*)setTransitionPropertiesWithType:(NSString*)transitionSubType{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = transitionSubType;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return transition;
}

#pragma mark - APIManagerDelegate

//-(void)setupOfferDownloadCompleted:(OfferLogic*)offerLogic{
//
//    self.localOffers = [[userAssets getOfferList] mutableCopy];
//
//    [self.saTableView reloadData];
//    [SVProgressHUD dismiss];
//
//}

-(void)gotGigsOffers:(NSMutableArray *)gigsOfferList{
    
    self.gigsOffers = [gigsOfferList copy];
    [self.swappedTable reloadData];
    [SVProgressHUD dismiss];
    
}

-(void) gotLocalOffers:(NSMutableArray *)localOfferArray{
    
    self.localOffers = [[userAssets getOfferList] mutableCopy];
    [self.swappedTable reloadData];
    [SVProgressHUD dismiss];
    
}

@end
