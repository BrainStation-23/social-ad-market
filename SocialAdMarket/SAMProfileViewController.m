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

@interface SAMProfileViewController (){
    SAMUserPropertiesAndAssets *userAssets;
    NSMutableArray *swapppedOffers;
}

@end
static AFHTTPRequestOperationManager *manager;

@implementation SAMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
   
    userAssets=[SAMUserPropertiesAndAssets sharedInstance];
    self.userName.text= [[userAssets getUerInformation] objectForKey:@"userName"];
    
    swapppedOffers = [[NSMutableArray alloc] init];
    [self setSwappedOffers];
}

-(void)viewWillAppear:(BOOL)animated{
    DELEGATE.segmentedView.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            
            for(NSDictionary *dic in (NSArray *)[(NSDictionary *)responseObject objectForKey:@"ResponseResult"]){
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
    return [swapppedOffers count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAMTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"swappedOfferCell"];
    SwappedOfferDetails *offer =[swapppedOffers objectAtIndex:indexPath.row];
    
    cell.ppTitle.text= offer.Title;
    cell.ppSubTitle.text=offer.Title;
    cell.ppDistance.text = [NSString stringWithFormat:@"%f",offer.Distance];
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
    DELEGATE.segmentedView.hidden=YES;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if(sender.tag==1){
        SocialAddMarketViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==2){
        SAMMapViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==3){
        SAMMessageViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
