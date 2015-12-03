//
//  BSContainerViewController.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SocialAddMarketViewController.h"
#import "AppDelegate.h"
#import "DWBubbleMenuButton.h"
#import "BSShortDescriptionView.h"
#import <AFNetworking.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "APIManager.h"
#import "GigsOfferList.h"
//#import "UIImageView+AFNetworking.h"


#import "UIScrollView+APParallaxHeader.h"

static AFHTTPRequestOperationManager *manager;

@interface SocialAddMarketViewController ()<UIAlertViewDelegate,APParallaxViewDelegate,APIManagerDelegate>{
    UIStoryboard *storyBoard;
    BSLoginViewController *loginViewController;
    SAMUserPropertiesAndAssets *userAssets;
    OfferLogic *offerLogic;
    
    UIImageView *offerEnlargedImage;
    BSShortDescriptionView *offerDesciptionView;
    
    
    CLLocationCoordinate2D offerLatAndLong;
    UITapGestureRecognizer *tapRecognizer;
    CLLocation *userLocation;
    BOOL hasFollowers;
    BOOL isAlreadySwapped;

    
    BOOL parallaxWithView;
    
    NSTimer *imageTimer;
    
    NSInteger counterForLocal;
    NSInteger counterForGigs;
    UIRefreshControl *refreshControl;
    
    BOOL flagForLocalIndex;
    BOOL flagForGigsIndex;


}

@property BOOL initialLaunch;
@property BOOL shouldExpand;
@end

@implementation SocialAddMarketViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
        self.delegate=self;
        storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //offerLogic = [[OfferLogic alloc]init];
        //offerLogic.delegate = self;
        userAssets =[SAMUserPropertiesAndAssets sharedInstance];
        NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];

        [userAssets setUserID:userId];
    
    
        DELEGATE.segmentedView = [[BSCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x +20, 220, self.view.frame.size.width-40, 40)];
        DELEGATE.segmentedView.backgroundColor = [UIColor lightGrayColor];
        DELEGATE.segmentedView.delegate=self;
        [DELEGATE.window addSubview:DELEGATE.segmentedView];
        [DELEGATE.segmentedView.localButton setBackgroundColor:[UIColor darkGrayColor]];
    
    
//        [SVProgressHUD showWithStatus:@"Loading..."];
//        APIManager *manager = [APIManager sharedManager];
//        manager.delegate = self;
//        NSString *userId = [[NSUserDefaults standardUserDefaults]
//                        stringForKey:@"UserID"];
//        NSLog(@"%@",userId);
//        [manager getGigsOffers:userId WithPageIndex:0];
    
        flagForLocalIndex = YES;
    
       if(DELEGATE.paginIndexForLocal==0){
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
    
    
    [self reloadTimer];
    
    [self toggle:nil];


    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.saTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];

    
}

- (void)refreshControlAction:(UIRefreshControl *)sender
{
    NSLog(@"refreshControlAction");
    
    if(flagForLocalIndex==YES && self.localOffers.count){
       counterForLocal=-1;
    
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

                                [self.saTableView addParallaxWithImage:image andHeight:300 andShadow:YES];
                                
                                
                                [self reloadTimer];

                                
                            }];
              }
         }
    

    
   else if(flagForGigsIndex==YES && self.gigsOffers.count){
        counterForGigs=-1;
        
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
                                    
                                    [self.saTableView addParallaxWithImage:image andHeight:300 andShadow:YES];
                                    
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
                                       
                                       [self.saTableView addParallaxWithView:imageView andHeight:300];


                                   }];
                      }
                }
    
    
    else if(flagForGigsIndex && self.gigsOffers.count>0){
        
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
                                    
                                    [self.saTableView addParallaxWithView:imageView andHeight:300];
                                    
                                    
                                }];
        }
        
        
    }

    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    DELEGATE.segmentedView.hidden=NO;
    //DELEGATE.paginIndex=0;
    //[offerLogic setUserOffers:DELEGATE.paginIndex];
    userAssets = [SAMUserPropertiesAndAssets sharedInstance];
    self.localOffers = [[userAssets getOfferList] mutableCopy];
    [self.saTableView reloadData];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)toggle:(id)sender{
    /**
     *  For demo purposes this view controller either adds a parallaxView with a custom view
     *  or a parallaxView with an image.
     */
    if(parallaxWithView == NO) {
        
        // add parallax with view
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images.jpeg"]];
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.saTableView addParallaxWithView:imageView andHeight:300];

        
        parallaxWithView = YES;
        
        // Update the toggle button
        //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        //[self.navigationItem setRightBarButtonItem:barButton];
    }
    else {
        // add parallax with image
        
        
        [self.saTableView addParallaxWithImage:[UIImage imageNamed:@"images.jpeg"] andHeight:300 andShadow:YES];
        //parallaxWithView = NO;
        
        
        
        
        // Update the toggle button
        //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        //[self.navigationItem setRightBarButtonItem:barButton];
    }
    
    /**
     *  Setting a delegate for the parallaxView will allow you to get callbacks for when the
     *  frame of the parallaxView changes.
     *  Totally optional thou.
     */
    self.saTableView.parallaxView.delegate = self;
    
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
    //NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
    
   // NSLog(@"frame.origin.x===%f frame.origin.y%f",frame.origin.x,frame.origin.y);
    
    //if(frame.origin.y)
    
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
    //NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
    
    //DELEGATE.segmentedView.frame = frame;

    
    if(frame.origin.y>=-260){
        DELEGATE.segmentedView.alpha=0;
    }
    else{
        DELEGATE.segmentedView.alpha=1;

        
    }
    
    
}



#pragma mark-
#pragma mark- BaseView Controller Delegate

- (void)loadView:(UIButton *)sender {
    
    DELEGATE.segmentedView.hidden=NO;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    if(sender.tag==2){
        DELEGATE.segmentedView.hidden=YES;
        SAMMapViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==3){
        DELEGATE.segmentedView.hidden=YES;
        SAMMessageViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==4){
        DELEGATE.segmentedView.hidden=NO;
        SAMProfileViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma marks-
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

        
          [self.saTableView reloadData];
    }
    else
       {
           
           flagForGigsIndex = NO;
           flagForLocalIndex = YES;
           
        [DELEGATE.segmentedView.localButton setSelected:YES];
         CATransition *transition = [self setTransitionPropertiesWithType:kCATransitionFromRight];
        [self.view.layer addAnimation:transition forKey:nil];
    
        [self.saTableView reloadData];

    }

}

#pragma mark-
#pragma mark-utility Method.

-(CATransition*)setTransitionPropertiesWithType:(NSString*)transitionSubType{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = transitionSubType;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return transition;
}


#pragma mark-
#pragma mark- TableView Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if(flagForGigsIndex==YES){
        
        return  self.gigsOffers.count;
    }
    
    else if (flagForLocalIndex==YES){
        
        return [self.localOffers count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SAMTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"offerCell"];
    
    
    
    if(flagForLocalIndex==YES){

      BSOfferDetails *offer =[self.localOffers objectAtIndex:indexPath.row];
      cell.ppTitle.text= offer.Title;
      cell.ppSubTitle.text=offer.SubTitle;
      cell.ppDistance.text = [[NSString stringWithFormat:@"%0.2f",[offer.Distance doubleValue]] stringByAppendingString:@" km"];
      cell.ppFollowers.text = [NSString stringWithFormat:@"%ld",(long)[offer.RequiredMinimumInstagramFollowers integerValue]];
    
    
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
    
      else if (flagForGigsIndex==YES){
          
          
          GigsOfferList *offer =[self.gigsOffers objectAtIndex:indexPath.row];
          cell.ppTitle.text= offer.Title;
          cell.ppSubTitle.text=offer.SubTitle;
          cell.ppDistance.text = [[NSString stringWithFormat:@"%0.2f",offer.Distance] stringByAppendingString:@" km"];
          cell.ppFollowers.text = [NSString stringWithFormat:@"%ld",(long)offer.RequiredMinimumInstagramFollowers];
          
          
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

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect myRect = [self.saTableView rectForRowAtIndexPath:indexPath];
    return myRect;
}


#pragma mark-
#pragma mark- TableView Delegate methods



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if(flagForLocalIndex==YES){
    
    SAMOfferShortDetailsViewController* detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OfferShortDetailsViewController"];
    BSOfferDetails *offer = [self.localOffers objectAtIndex:indexPath.row];
    detailViewController.offer = offer;
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    else if (flagForGigsIndex==YES){
        
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
        
    if (scrollView == self.saTableView)
    {

        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if (bottomEdge >= scrollView.contentSize.height) {
            
            if (flagForGigsIndex==YES) {
                
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
    [self.saTableView reloadData];
    [SVProgressHUD dismiss];
    
}

-(void) gotLocalOffers:(NSMutableArray *)localOfferArray{
    
    self.localOffers = [[userAssets getOfferList] mutableCopy];
    [self.saTableView reloadData];
    [SVProgressHUD dismiss];
    
}



@end
