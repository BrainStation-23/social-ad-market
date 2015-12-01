//
//  InstagramMediaViewController.m
//  SocialAdMarket
//
//  Created by BS-125 on 11/27/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "InstagramMediaViewController.h"
#import "InstagramMediaCollectionViewCell.h"
#import "APIManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "InstagramAPI.h"
#import "AppDelegate.h"

#include "SAMUserPropertiesAndAssets.h"
#import <AFNetworking.h>

@interface InstagramMediaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,APIManagerDelegate>{
    
    __weak IBOutlet UICollectionView *contentCollectionView;
    NSMutableArray *instagramMediaArray;
    NSInteger selectedIndex;
    BOOL hasFollowers;
    BOOL isAlreadySwapped;
    CLLocation *userLocation;
    CLLocationCoordinate2D offerLatAndLong;

}

@end
static AFHTTPRequestOperationManager *manager;

@implementation InstagramMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //APIManager *manager = [APIManager sharedManager];
    
    //manager.delegate = self;
    //[manager loadMedia];

    
    instagramMediaArray = [[NSMutableArray alloc]initWithObjects:@"a.png",@"b.png",@"c.png",@"d.png",@"e.png",@"f.png",@"g.png",@"h.png",@"j.png",@"k.png",@"l.png",@"m.png",@"n.png",@"o.png",@"p.png", nil];
    
    [contentCollectionView registerClass:[InstagramMediaCollectionViewCell class] forCellWithReuseIdentifier:@"InstagramMediaCollectionViewCell"];
    UINib * cellNib = [UINib nibWithNibName:@"InstagramMediaCollectionViewCell" bundle:nil];
    [contentCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InstagramMediaCollectionViewCell"];
    
    selectedIndex = -1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - All UIAction

- (IBAction)backBtnAct:(id)sender {
    
    //DELEGATE.instagramMediaId = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnAct:(id)sender {
    
    if(selectedIndex != -1) {
        
        
        
        
        
      InstagramAPI *IAPI = [instagramMediaArray objectAtIndex:selectedIndex];
     // DELEGATE.instagramMediaId = IAPI.imageID;
     // [self.navigationController popViewControllerAnimated:YES];
        
        
        if([self canSwap]){
            
            SAMUserPropertiesAndAssets *userWithOffers = [SAMUserPropertiesAndAssets sharedInstance];
            [userWithOffers getUserID];
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer=[AFJSONResponseSerializer serializer];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            
            //NSString *offerId = [NSString stringWithFormat:@"%@",self.gigsOfferId];
            NSDictionary *parameters = @{@"BsInstagramUserId":[userWithOffers getUserID] ,@"OfferId": self.gigsOfferId, @"PostId": IAPI.imageID};
            NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@",BASE_URL,GIGSOFFERSWAP];
            
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
    else{
        UIAlertView *alertMessage =[[UIAlertView alloc]initWithTitle:@"Message!"
                                                             message:@"Please select Instagram Media"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        [alertMessage show];
    }
}


#pragma mark-
#pragma mark- Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //if(alertView.tag!=0){
        //[self gestureHandlerMethod:self];
    //}
    
    [self gestureHandlerMethod];
}


#pragma mark-
#pragma mark- Gesture method


-(void)gestureHandlerMethod{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return dataArray.count+12;
    //UserInfo *info = [UserInfo sharedInstance];
    return instagramMediaArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    InstagramMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstagramMediaCollectionViewCell" forIndexPath:indexPath];
    
    if (cell) {
        
          cell.image_View.image = [UIImage imageNamed:[instagramMediaArray objectAtIndex:indexPath.item]];

        
            }
//    InstagramAPI *IAPI = [instagramMediaArray objectAtIndex:indexPath.item];
//    
//    if (IAPI.profile_picture) {
//        __block UIActivityIndicatorView *activityIndicator;
//        __weak UIImageView *weakImageView = cell.image_View;
//        [cell.image_View sd_setImageWithURL:[NSURL URLWithString:IAPI.profile_picture]
//                            placeholderImage:nil
//                                     options:SDWebImageProgressiveDownload
//                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                        if (!activityIndicator) {
//                                            [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
//                                        }
//                                    }
//                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                       
//                                   }];
//    }

    
    
    if(selectedIndex == indexPath.item)
        cell.overLayImage.hidden=NO;
    else
        cell.overLayImage.hidden=YES;
 

    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = contentCollectionView.bounds.size.width /3 - 10;
    return CGSizeMake(width, 135);
    
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    selectedIndex = indexPath.item;
    
    [contentCollectionView reloadData];
    
    
}


#pragma mark - APIManagerDelegate

-(void)gotInstagramMedia:(NSArray *)mediaArray{
    
    instagramMediaArray = [mediaArray copy];
    [contentCollectionView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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




@end
