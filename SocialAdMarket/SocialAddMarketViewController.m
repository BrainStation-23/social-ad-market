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


@interface SocialAddMarketViewController (){
    UIStoryboard *storyBoard;
    BSLoginViewController *loginViewController;
    SAMUserPropertiesAndAssets *userAssets;
    OfferLogic *offerLogic;
    
    UIImageView *offerEnlargedImage;
    BSShortDescriptionView *offerDesciptionView;
    
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
    [SVProgressHUD showWithStatus:@"Loading..."];
    offerLogic.delegate = self;
    userAssets =[SAMUserPropertiesAndAssets sharedInstance];
    
    DELEGATE.segmentedView = [[BSCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x +20, 220, self.view.frame.size.width-40, 40)];
    DELEGATE.segmentedView.backgroundColor = [UIColor lightGrayColor];
    DELEGATE.segmentedView.delegate=self;
    [DELEGATE.window addSubview:DELEGATE.segmentedView];
    [DELEGATE.segmentedView.localButton setBackgroundColor:[UIColor darkGrayColor]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    DELEGATE.segmentedView.hidden=NO;
    DELEGATE.paginIndex=0;
    [offerLogic setUserOffers:DELEGATE.paginIndex];
    [self.saTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


#pragma mark-
#pragma mark- TableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    SAMOfferShortDetailsViewController* detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OfferShortDetailsViewController"];
    
    BSOfferDetails *offer = [self.offers objectAtIndex:indexPath.row];
    detailViewController.offer = offer;
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    
    self.navigationController.navigationBarHidden=YES;
    
    [self.navigationController pushViewController:detailViewController animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark-
#pragma mark- UIScrollViewDelegate method

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    
    if (aScrollView == self.saTableView)
    {
        
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 60;
        
        if(offset.y > 0 && y>(h+reload_distance)){
           
            DELEGATE.paginIndex = DELEGATE.paginIndex+1;
            if(DELEGATE.paginIndex <= DELEGATE.totalPage){
            
            [SVProgressHUD showWithStatus:@"Loading..."];

            [offerLogic setUserOffers:DELEGATE.paginIndex];
            }
        }
        
    }
}
#pragma mark - OfferLogicDelegate method

-(void)setupOfferDownloadCompleted:(OfferLogic*)offerLogic{
    self.offers = [userAssets getOfferList];
    [self.saTableView reloadData];
    [SVProgressHUD dismiss];
}


@end
