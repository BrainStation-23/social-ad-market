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

@interface SAMProfileViewController ()<APParallaxViewDelegate,APParallaxViewDelegate>{
    SAMUserPropertiesAndAssets *userAssets;
    NSMutableArray *swapppedOffers;
    
    NSInteger counterForLocal;
    NSInteger counterForGigs;
    BOOL isAlreadySwapped;
    BOOL parallaxWithView;
    
    NSTimer *imageTimer;
    
    BOOL flagForLocalIndex;
    UIRefreshControl *refreshControl;
    //BOOL flagForGigsIndex;
}

@end
static AFHTTPRequestOperationManager *manager;
UIStoryboard *storyBoard;

@implementation SAMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self toggle:nil];
    
    
    
//    userAssets=[SAMUserPropertiesAndAssets sharedInstance];
//    swapppedOffers = [[NSMutableArray alloc] init];
//    [self setSwappedOffers];
    
    /*
    APIManager *manager = [APIManager sharedManager];
    manager.delegate = self;
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];
    NSLog(@"%@",userId);
    //[manager getGigsOffers:userId WithPageIndex:0];
    [manager getUserLocalOffers:0];
*/
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
    
    
    DELEGATE.segmentedView.delegate=self;
    flagForLocalIndex = YES;
    
    if(DELEGATE.paginIndexForLocal>=0){
        counterForLocal=-1;
        [SVProgressHUD showWithStatus:@"Loading..."];
        //[offerLogic setUserOffers:DELEGATE.paginIndexForLocal];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate = self;
        NSString *userId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"UserID"];
        NSLog(@"%@",userId);
        [manager getUserLocalOffers:DELEGATE.paginIndexForGigs];
    }
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.swappedTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];

}

- (void)refreshControlAction:(UIRefreshControl *)sender
{
    NSLog(@"refreshControlAction");
    
    if(flagForLocalIndex==YES && self.localOffers.count){
        
        BSOfferDetails *offer =[self.localOffers objectAtIndex:++counterForLocal];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        //[imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if (offer.PictureUrl) {
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:offer.PictureUrl]
                         placeholderImage:nil
                                  options:SDWebImageProgressiveDownload
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     if (!activityIndicator) {
                                         [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                     }
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    [self.swappedTable addParallaxWithImage:image andHeight:300 andShadow:YES];
                                    
                                    
                                    [self reloadTimer];
                                    
                                    
                                }];
        }
    }
    
    
    
    else if(flagForLocalIndex==NO && self.gigsOffers.count){
        
        GigsOfferList *offer =[self.gigsOffers objectAtIndex:++counterForGigs];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        //[imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if (offer.PictureUrl) {
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:offer.PictureUrl]
                         placeholderImage:nil
                                  options:SDWebImageProgressiveDownload
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     if (!activityIndicator) {
                                         [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                     }
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    [self.swappedTable addParallaxWithImage:image andHeight:300 andShadow:YES];
                                    
                                    [self reloadTimer];
                                    
                                    
                                }];
        }
    }
    
    
    
    
    [sender endRefreshing];
    
}

- (void) reloadTimer {
    if (imageTimer) {
        [imageTimer invalidate];
        imageTimer = nil;
    }
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

-(void)scrollToNextPage{
    
    
    if(flagForLocalIndex && self.localOffers.count>0){
        
        if(counterForLocal==self.localOffers.count-1)
            counterForLocal=-1;
        
        
        BSOfferDetails *offer =[self.localOffers objectAtIndex:++counterForLocal];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        //[imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if (offer.PictureUrl) {
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:offer.PictureUrl]
                         placeholderImage:nil
                                  options:SDWebImageProgressiveDownload
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     if (!activityIndicator) {
                                         [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                     }
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    //[imageView setFrame:CGRectMake(0, 0, 200, 300)];
                                    //[imageView setContentMode:UIViewContentModeScaleAspectFill];
                                    //[imageView setImage:image];
                                    //UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image] ;
                                    //[imageView2 setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
                                    //[imageView2 setContentMode:UIViewContentModeScaleAspectFill];
                                    
                                    //[self.saTableView addParallaxWithImage:image andHeight:300 andShadow:YES];
                                    
                                    [self.swappedTable addParallaxWithView:imageView andHeight:300];
                                    
                                    
                                }];
        }
    }
    
    
    else if(!flagForLocalIndex && self.gigsOffers.count>0){
        
        if(counterForGigs==self.gigsOffers.count-1)
            counterForGigs=-1;
        
        
        GigsOfferList *offer =[self.gigsOffers objectAtIndex:++counterForGigs];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        //[imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if (offer.PictureUrl) {
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:offer.PictureUrl]
                         placeholderImage:nil
                                  options:SDWebImageProgressiveDownload
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     if (!activityIndicator) {
                                         [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                     }
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    //[imageView setFrame:CGRectMake(0, 0, 200, 300)];
                                    //[imageView setContentMode:UIViewContentModeScaleAspectFill];
                                    //[imageView setImage:image];
                                    //UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image] ;
                                    //[imageView2 setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
                                    //[imageView2 setContentMode:UIViewContentModeScaleAspectFill];
                                    
                                    //[self.saTableView addParallaxWithImage:image andHeight:300 andShadow:YES];
                                    
                                    [self.swappedTable addParallaxWithView:imageView andHeight:300];
                                    
                                    
                                }];
        }
        
        
    }
    
    
    
    
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


#pragma mark- Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    if (flagForLocalIndex==YES){
        
        return [self.localOffers count];
    }
    else {
        
        return  self.gigsOffers.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAMTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"swappedOfferCell"];
    
    
    
    
    if(flagForLocalIndex==YES) {
    
     SwappedOfferDetails *offer =[self.localOffers objectAtIndex:indexPath.row];
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
    
    }
    else{
        
        SwappedOfferDetails *offer =[self.gigsOffers objectAtIndex:indexPath.row];
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

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(flagForLocalIndex==YES){
        SAMOfferShortDetailsViewController* detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OfferShortDetailsViewController"];
        BSOfferDetails *offer = [self.localOffers objectAtIndex:indexPath.row];
        detailViewController.offer = offer;
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    else {
        
        SAMOfferShortDetailsViewController* detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OfferShortDetailsViewController"];
        GigsOfferList *gigsOffer = [self.gigsOffers objectAtIndex:indexPath.row];
        detailViewController.gigsOfferList = gigsOffer;
        detailViewController.flagForGigs=YES;
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
    
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
    
    if(segmentButton.tag==1&&flagForLocalIndex==YES)
    {
        //flagForGigsIndex = YES;
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
    else if(segmentButton.tag==2&&flagForLocalIndex==NO)
    {
        //flagForGigsIndex = NO;
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

#pragma mark- UIScrollViewDelegate method

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView == self.swappedTable)
    {
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if (bottomEdge >= scrollView.contentSize.height) {
            
            if (flagForLocalIndex==NO) {
                
                DELEGATE.paginIndexForGigs = DELEGATE.paginIndexForGigs+1;
                if(DELEGATE.paginIndexForGigs < DELEGATE.totalPageForGigs)
                {
                    [SVProgressHUD showWithStatus:@"Loading..."];
                    NSLog(@"DELEGATE.paginIndex===%ld",(long)DELEGATE.paginIndexForGigs);
                    
                    APIManager *manager = [APIManager sharedManager];
                    manager.delegate = self;
                    NSString *userId = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"UserID"];
                    NSLog(@"%@",userId);
                    [manager getGigsOffers:userId WithPageIndex:DELEGATE.paginIndexForGigs];
                }
            }
            else {
                DELEGATE.paginIndexForLocal = DELEGATE.paginIndexForLocal+1;
                if(DELEGATE.paginIndexForLocal < DELEGATE.totalPageForLocal)
                {
                    
                    [SVProgressHUD showWithStatus:@"Loading..."];
                    NSLog(@"DELEGATE.paginIndex===%ld",(long)DELEGATE.paginIndexForGigs);
                    
                    APIManager *manager = [APIManager sharedManager];
                    manager.delegate = self;
                    NSString *userId = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"UserID"];
                    NSLog(@"%@",userId);
                    [manager getUserLocalOffers:DELEGATE.paginIndexForGigs];
                    
                    
                    
                    //[SVProgressHUD showWithStatus:@"Loading..."];
                    //NSLog(@"DELEGATE.paginIndex===%ld",(long)DELEGATE.paginIndexForLocal);
                    //[offerLogic setUserOffers:DELEGATE.paginIndexForLocal];
                }
            }
            
        }
        
    }
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
    //self.localOffers = [[userAssets getOfferList] mutableCopy];
    self.localOffers = [localOfferArray mutableCopy];
    //BSOfferDetails *details=[self.localOffers objectAtIndex:0];
    
    [self.swappedTable reloadData];
    [SVProgressHUD dismiss];
}

@end
