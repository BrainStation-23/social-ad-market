//
//  SAMOfferShortDetailsViewController.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMOfferShortDetailsViewController.h"
#include "SAMUserPropertiesAndAssets.h"
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "SDWebImage/UIImageView+WebCache.h"

static AFHTTPRequestOperationManager *manager;

@interface SAMOfferShortDetailsViewController (){
    CLLocationCoordinate2D offerLatAndLong;
    UITapGestureRecognizer *tapRecognizer;
    CLLocation *userLocation;
    BOOL isSwapable;
}

@end

@implementation SAMOfferShortDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DELEGATE.segmentedView.hidden=YES;
    self.shortDescriptionView.hidden=YES;
 
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    
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
                __block UIActivityIndicatorView *activityIndicator;
                __weak UIImageView *weakImageView = self.enlargedImageView;
                [self.enlargedImageView sd_setImageWithURL:[NSURL URLWithString:[offerDetails objectForKey:@"PictureUrl"]]
                                          placeholderImage:[UIImage imageNamed:@"img2.jpg"]
                                             options:SDWebImageProgressiveDownload
                                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                if (!activityIndicator) {
                                                    [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                                }
                                            }
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                               
                                               [self animateOnEntry];

                                               
                                               offerLatAndLong.latitude = [[offerDetails valueForKey:@"Latitude"] doubleValue];
                                               offerLatAndLong.longitude =  [[offerDetails valueForKey:@"Longitude"] doubleValue];
                                               
                                               isSwapable = [offerDetails objectForKey:@"SwapbaleByFollowerRules"];
                                               
                                               self.shortDescriptionView.titleLabel.text = [offerDetails objectForKey:@"Title"];
                                               self.shortDescriptionView.briefDescriptionLabel.text = [offerDetails objectForKey:@"Details"];
                                               self.shortDescriptionView.requiredFollowersLabel.text = [[NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"RequiredMinimumInstagramFollowers"]] stringByAppendingString:@" followers"] ;
                                               
                                               if([NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]]!=nil || ![NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]].length){
                                                   self.shortDescriptionView.milesLabel.text = @" mi";
                                               }
                                               else{
                                                   self.shortDescriptionView.milesLabel.text = [[NSString stringWithFormat:@"%@",[offerDetails valueForKey:@"Distance"]] stringByAppendingString:@" mi"];
                                                   
                                               }
                                               if([self canSwap]){
                                                   [self.shortDescriptionView.swapButton setTitle:@"Swap" forState:UIControlStateNormal];
                                               }
                                               else{
                                                   [self.shortDescriptionView.swapButton setBackgroundColor:[UIColor lightGrayColor]];
                                                   [self.shortDescriptionView.swapButton setTitle:@"You Need More Followers" forState:UIControlStateNormal];
                                                   
                                               }
                                               self.shortDescriptionView.hidden=NO;
                                           }];
            }
            
        }
       
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failure. %@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark- Gesture method


-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    
    [UIView animateWithDuration:0.8f animations:^{
         self.enlargedImageView.frame = CGRectMake(self.enlargedImageView.frame.size.width,self.yOrigin, 0,0);
         self.shortDescriptionView.frame = CGRectMake(-self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
         self.shortDescriptionView.alpha = 0;
    }
    completion:^(BOOL finished){
         [self.navigationController popViewControllerAnimated:NO];
    }
    ];
    
}


- (void) animateOnEntry
{
    //set initial frames
    self.enlargedImageView.alpha = 0;
    self.enlargedImageView.frame = CGRectMake(self.view.frame.size.width, self.yOrigin-50, self.enlargedImageView.frame.size.width, self.enlargedImageView.frame.size.height);
    
    
    self.shortDescriptionView.alpha = 0;
    self.shortDescriptionView.frame = CGRectMake(-self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
    
    [UIView animateWithDuration:0.8f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.enlargedImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.enlargedImageView.frame.size.height);
         self.enlargedImageView.alpha = 1;
         self.shortDescriptionView.frame = CGRectMake(0, self.shortDescriptionView.frame.size.height, self.shortDescriptionView.frame.size.width, self.shortDescriptionView.frame.size.height);
         
         self.shortDescriptionView.alpha = 1;
     }
    completion:NULL];

}

#pragma mark-
#pragma mark- Utility method

-(BOOL)canSwap{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:offerLatAndLong.latitude longitude:offerLatAndLong.longitude];
    
    
    CLLocationDistance distance = [userLocation distanceFromLocation:location1]/1000;
     if(distance <=100 && isSwapable){
         return YES;
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
    else{
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Sorry!"
                                                             message:@"You Need More Followers"
                                                            delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
        alertMessage.tag=1;
        
        [alertMessage show];
    }

}


#pragma mark-
#pragma mark- Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
          [self gestureHandlerMethod:tapRecognizer];
    }
}

@end
