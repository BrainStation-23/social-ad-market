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

//#import "UIImageView+AFNetworking.h"


#import "UIScrollView+APParallaxHeader.h"

static AFHTTPRequestOperationManager *manager;

@interface SocialAddMarketViewController ()<UIAlertViewDelegate,APParallaxViewDelegate>{
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
    
    NSInteger counter;
    UIRefreshControl *refreshControl;


}

@property BOOL initialLaunch;
@property BOOL shouldExpand;
@end

@implementation SocialAddMarketViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
        self.delegate=self;
        storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        offerLogic = [[OfferLogic alloc]init];
        offerLogic.delegate = self;
        userAssets =[SAMUserPropertiesAndAssets sharedInstance];
    
    
        DELEGATE.segmentedView = [[BSCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x +20, 220, self.view.frame.size.width-40, 40)];
        DELEGATE.segmentedView.backgroundColor = [UIColor lightGrayColor];
        DELEGATE.segmentedView.delegate=self;
        [DELEGATE.window addSubview:DELEGATE.segmentedView];
        [DELEGATE.segmentedView.localButton setBackgroundColor:[UIColor darkGrayColor]];
    
    
       if(DELEGATE.paginIndex==0){
           counter=-1;
           [SVProgressHUD showWithStatus:@"Loading..."];
           [offerLogic setUserOffers:DELEGATE.paginIndex];
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
    
    counter=-1;
    
    BSOfferDetails *offer =[self.offers objectAtIndex:++counter];
    
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
    
    BSOfferDetails *offer =[self.offers objectAtIndex:0];

    if(offer.PictureUrl){
          if(counter==self.offers.count-1)
              counter=-1;
    
    
          BSOfferDetails *offer =[self.offers objectAtIndex:++counter];
    
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
    self.offers = [[userAssets getOfferList] mutableCopy];
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
    
    if(segmentButton.tag==1){
        [DELEGATE.segmentedView.gigsButton setSelected:YES];
        CATransition *transition = [self setTransitionPropertiesWithType:kCATransitionFromLeft];
        [self.view.layer addAnimation:transition forKey:nil];
    }
    else{
        [DELEGATE.segmentedView.localButton setSelected:YES];
         CATransition *transition = [self setTransitionPropertiesWithType:kCATransitionFromRight];
        [self.view.layer addAnimation:transition forKey:nil];
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
    return [self.offers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAMTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"offerCell"];
    BSOfferDetails *offer =[self.offers objectAtIndex:indexPath.row];

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
    

    return cell;
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect myRect = [self.saTableView rectForRowAtIndexPath:indexPath];
    return myRect;
}


#pragma mark-
#pragma mark- TableView Delegate methods



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    //CGRect myRect = [self rectForRowAtIndexPath:indexPath];
    //[self animateFromLeft:myRect];

    
    
//    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
//    [self.view addGestureRecognizer:tapRecognizer];
//    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
//    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
//    self.yOrigin = cellFrameInSuperview.origin.y;
//    self.enlargedImageView.frame = CGRectMake(0, 0, self.enlargedImageView.frame.size.width, self.enlargedImageView.frame.size.height);
//    self.offer = [self.offers objectAtIndex:indexPath.row];
//    
//    [self getDataForDetailsView];
    

    
    
    
    
    
    
    
    //[self animateOnEntry];
    SAMOfferShortDetailsViewController* detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OfferShortDetailsViewController"];
    
    BSOfferDetails *offer = [self.offers objectAtIndex:indexPath.row];
    detailViewController.offer = offer;
    //detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    self.navigationController.navigationBarHidden=YES;
    
    //[self presentViewController:detailViewController animated:YES completion:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    
    
    
    
    
    
    
    
    
    
}

-(void)getDataForDetailsView{
    
    
    SAMUserPropertiesAndAssets *userWithOffers = [SAMUserPropertiesAndAssets sharedInstance];
    userLocation = [userWithOffers getCurrentLocation];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSString *offerId = [NSString stringWithFormat:@"%@",self.offer.Id];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[userWithOffers getUserID]] forHTTPHeaderField:@"UserId"];
    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?id=%@",BASE_URL,OFFERDETAILS_URL,offerId];
    
    
    [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *registrationInfo=(NSDictionary *) responseObject;
        NSDictionary *offerDetails = [responseObject objectForKey:@"ResponseResult"];
        
        
        if([[registrationInfo objectForKey:@"Success"] intValue]==1&&[[registrationInfo objectForKey:@"ErrorCode"] intValue]==0){
            
            if ([offerDetails objectForKey:@"PictureUrl"]) {
                
                self.enlargedImageView.image=nil;
                
                
                
                __block UIActivityIndicatorView *activityIndicator;
                __weak UIImageView *weakImageView = self.enlargedImageView;
                [self.enlargedImageView sd_setImageWithURL:[NSURL URLWithString:[offerDetails objectForKey:@"PictureUrl"]]
                                          placeholderImage:nil
                                                   options:SDWebImageProgressiveDownload
                                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                      if (!activityIndicator) {
                                                          [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                                      }
                                                  }
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                     
                                                     
                                                     self.enlargedImageView.hidden=NO;
                                                     self.shortDescriptionView.hidden=NO;

                                                     
                                                     [self animateOnEntry];
                                                     
                                                     offerLatAndLong.latitude = [[offerDetails valueForKey:@"Latitude"] doubleValue];
                                                     offerLatAndLong.longitude =  [[offerDetails valueForKey:@"Longitude"] doubleValue];
                                                     
                                                     hasFollowers = [[offerDetails objectForKey:@"SwapbaleByFollowerRules"] boolValue];
                                                     isAlreadySwapped = [[offerDetails objectForKey:@"IsAlreadySwapped"] boolValue];
                                                     
                                                     self.shortDescriptionView.titleLabel.text = [offerDetails objectForKey:@"Title"];
                                                     self.shortDescriptionView.subTitleLabel.text = [offerDetails objectForKey:@"SubTitle"];
                                                     self.shortDescriptionView.briefDescriptionLabel.text = [offerDetails objectForKey:@"Details"];
                                                     self.shortDescriptionView.requiredFollowersLabel.text = [[NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"RequiredMinimumInstagramFollowers"]] stringByAppendingString:@" followers"];
                                                     
                                                     if([NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]]!=nil || ![NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]].length){
                                                         self.shortDescriptionView.milesLabel.text = @" km";
                                                     }
                                                     else{
                                                         self.shortDescriptionView.milesLabel.text = [[NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]] stringByAppendingString:@" mi"];
                                                         
                                                     }
                                                     if([self canSwap]){
                                                         [self.shortDescriptionView.swapButton setBackgroundColor:[UIColor colorWithRed:45/255.0 green:166/255.0 blue:80/255.0 alpha:1]];
                                                         [self.shortDescriptionView.swapButton setTitle:@"Swap" forState:UIControlStateNormal];
                                                     }
                                                     else if([self isAlreadySwapped]){
                                                         [self.shortDescriptionView.swapButton setBackgroundColor:[UIColor lightGrayColor]];
                                                         [self.shortDescriptionView.swapButton setTitle:@"You Have Already Swapped" forState:UIControlStateNormal];
                                                     }
                                                     else{
                                                         [self.shortDescriptionView.swapButton setBackgroundColor:[UIColor lightGrayColor]];
                                                         [self.shortDescriptionView.swapButton setTitle:@"You Need More Followers" forState:UIControlStateNormal];
                                                         
                                                     }
                                                     //self.shortDescriptionView.hidden=NO;
                                                 }];
            }
            
        }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Request failure. %@",error);
         }];

    
}

#pragma mark-
#pragma mark- UIScrollViewDelegate method

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // self.expandableMenu.alpha=1;
   
    
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    

//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    
//    NSLog(@"scrollView.contentOffset.y===%f  scrollView.frame.size.height===%f",scrollView.contentOffset.y,scrollView.frame.size.height);
//
//    
//    
//    if (bottomEdge >= scrollView.contentSize.height-20)
//    {
//        // we are at the end
//        self.expandableMenu.alpha=0;
//    }
//    else
//        self.expandableMenu.alpha=1;
//    

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        
    if (scrollView == self.saTableView)
    {
        
        
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if (bottomEdge >= scrollView.contentSize.height) {
            
            DELEGATE.paginIndex = DELEGATE.paginIndex+1;
            if(DELEGATE.paginIndex < DELEGATE.totalPage)
            {
                [SVProgressHUD showWithStatus:@"Loading..."];
                NSLog(@"DELEGATE.paginIndex===%ld",(long)DELEGATE.paginIndex);
                [offerLogic setUserOffers:DELEGATE.paginIndex];
            }
        }
        
        
        
//        float scrollViewHeight = aScrollView.frame.size.height;
//        float scrollContentSizeHeight = aScrollView.contentSize.height;
//        float scrollOffset = aScrollView.contentOffset.y;
//        if (scrollOffset + scrollViewHeight == scrollContentSizeHeight){
        
        
//        CGFloat bottomInset = scrollView.contentInset.bottom;
//        CGFloat bottomEdge2 = scrollView.contentOffset.y + scrollView.frame.size.height - bottomInset;
//        if (bottomEdge2 == scrollView.contentSize.height) {
//            // Scroll view is scrolled to bottom
//
//            self.expandableMenu.alpha=0;
//        }
//        else
//            self.expandableMenu.alpha=1;
        
        
        
        
//        CGPoint offset = aScrollView.contentOffset;
//        CGRect bounds = aScrollView.bounds;
//        CGSize size = aScrollView.contentSize;
//        UIEdgeInsets inset = aScrollView.contentInset;
//        float y = offset.y + bounds.size.height - inset.bottom;
//        float h = size.height;
//        
//        float reload_distance = 60;
        
        //if(offset.y > 0 && y>(h+reload_distance)){
           
//            DELEGATE.paginIndex = DELEGATE.paginIndex+1;
//            if(DELEGATE.paginIndex < DELEGATE.totalPage)
//             {
//                [SVProgressHUD showWithStatus:@"Loading..."];
//                NSLog(@"DELEGATE.paginIndex===%ld",(long)DELEGATE.paginIndex);
//                [offerLogic setUserOffers:DELEGATE.paginIndex];
//            }
        //}
    }
}
#pragma mark - OfferLogicDelegate method

-(void)setupOfferDownloadCompleted:(OfferLogic*)offerLogic{
    
    self.offers = [[userAssets getOfferList] mutableCopy];
    
    
    [self.saTableView reloadData];
    [SVProgressHUD dismiss];
    
    
    
    
    

}




-(void)animateFromLeft:(CGRect)myFrame{
    
    CGFloat xPos = self.view.frame.size.width -  myFrame.size.height;
    self.saImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, self.view.frame.size.height/2 + myFrame.origin.y, myFrame.size.height, myFrame.size.height)];
    self.saImageView.image = [UIImage imageNamed:@"images.jpeg"];
    [self.view addSubview:self.saImageView];
    
    UIImageView *finalImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.saImageView.frame = finalImageView.frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}


- (void) animateOnEntry
{
    //set initial frames
    self.enlargedImageView.alpha = 0;
    self.enlargedImageView.frame = CGRectMake(self.view.frame.size.width+64, self.yOrigin, self.enlargedImageView.frame.size.height, self.enlargedImageView.frame.size.height);
    
    
    self.shortDescriptionView.alpha = 0;
    self.shortDescriptionView.frame = CGRectMake(-self.shortDescriptionView.frame.size.width, self.yOrigin, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
    
    [UIView animateWithDuration:0.8f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         
         self.enlargedImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.enlargedImageView.frame.size.height);
         self.enlargedImageView.alpha = 1;
         self.shortDescriptionView.frame = CGRectMake(0, self.shortDescriptionView.frame.size.height, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
         self.shortDescriptionView.alpha = 1;
     }completion:^(BOOL finished) {
         
         DELEGATE.segmentedView.hidden=YES;
         self.expandableMenu.hidden=YES;

     }];
    
}



#pragma mark-
#pragma mark- Gesture method


-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    

    [UIView animateWithDuration:0.8f animations:^{
        self.enlargedImageView.frame = CGRectMake(self.enlargedImageView.frame.size.width,self.yOrigin, 0,0);
        
        self.shortDescriptionView.frame = CGRectMake(-self.shortDescriptionView.frame.size.width, self.yOrigin, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
        self.shortDescriptionView.alpha = 0;
    }
                     completion:^(BOOL finished){
                         
                         DELEGATE.segmentedView.hidden=NO;
                         self.expandableMenu.hidden=NO;
                         
                         self.enlargedImageView.hidden=YES;
                         self.shortDescriptionView.hidden=YES;
                         for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
                             [self.view removeGestureRecognizer:recognizer];
                         }
                     }
     ];
    
}









#pragma mark-
#pragma mark- Utility method

-(BOOL)hasEnoughFollowers{
    return hasFollowers;
}
-(BOOL)isAlreadySwapped{
    return isAlreadySwapped;
}
-(BOOL)withinTheDistance{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:offerLatAndLong.latitude longitude:offerLatAndLong.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:location1]/1000;
    
    if(distance <=10000){
        return YES;
    }
    return NO;
}
-(BOOL)canSwap{
    if([self hasEnoughFollowers] && ![self isAlreadySwapped]){
        if([self withinTheDistance]){
            return YES;
        }
        else{
            return NO;
        }
    }
    return NO;
}

#pragma mark-
#pragma mark- Action method


- (IBAction)swapBtnAct:(id)sender {
    if([self canSwap]){
        SAMUserPropertiesAndAssets *userWithOffers = [SAMUserPropertiesAndAssets sharedInstance];
        [userWithOffers getUserID];
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        
        NSString *offerId = [NSString stringWithFormat:@"%@",self.offer.Id];
        
        
        NSDictionary *parameters = @{@"BsInstagramUserId":[userWithOffers getUserID] ,@"OfferId": offerId};
        
        
        NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@",BASE_URL,OFFERSWAP];
        
        [manager POST: offerTodayAndFutureUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *registrationInfo=(NSDictionary *) responseObject;
            
            if([[registrationInfo objectForKey:@"Success"] intValue]==1&&[[registrationInfo objectForKey:@"ErrorCode"] intValue]==0){
                UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                     message:@"Swipe has been done"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                alertMessage.tag=0;
                [alertMessage show];
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Request failure. %@",error);
              }];
    }
    else if (![self hasEnoughFollowers]){
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Swap Failed!"
                                                             message:@"You Don't have enough followers"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        alertMessage.tag=1;
        
        [alertMessage show];
    }
    else if(![self withinTheDistance]){
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Swap Failed!"
                                                             message:@"You are Not Within Required Distance"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        alertMessage.tag=2;
        
        [alertMessage show];
    }
    else if([self isAlreadySwapped]){
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Already Swapped!"
                                                             message:@"You have Already Swapped This Offer"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        alertMessage.tag=3;
        
        [alertMessage show];
    }
    else{
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Swap Failed!"
                                                             message:@"You Can't swap. Unkown Error Occured"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        alertMessage.tag=4;
        
        [alertMessage show];
    }
    
}


#pragma mark-
#pragma mark- Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag!=0){
        [self gestureHandlerMethod:tapRecognizer];
    }
}



@end
