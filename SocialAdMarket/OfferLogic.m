//
//  OfferLogic.m
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "OfferLogic.h"
#import "SAMUserPropertiesAndAssets.h"
#import "AppDelegate.h"

CLLocationManager *locationManager;
CLLocation *currentLocation;

static AFHTTPRequestOperationManager *manager;

@implementation OfferLogic

@synthesize offerList;

-(void)setUserOffers:(NSInteger)pageIndex{
    SAMUserPropertiesAndAssets *userWithOffers = [SAMUserPropertiesAndAssets sharedInstance];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    locationManager = [[CLLocationManager alloc] init] ;
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [locationManager startUpdatingLocation];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    
    
//    NSMutableDictionary *jsonDataDictionary=[[NSMutableDictionary alloc]init];
//    NSString *url=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", accessToken];
//    
//    NSURL *jsonURL = [NSURL URLWithString:url];
//    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
//    NSError *error = nil;
//    jsonDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//    
//    NSString *followers=[[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"counts"] objectForKey:@"followed_by"];
//    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
//    [userWithOffers setUserID:userId];
//    
//    NSString *username=[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"username"];
//    NSString *full_name=[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"full_name"];
//    
//    NSMutableDictionary *currentUserInfo = [[NSMutableDictionary alloc]init];
//    [currentUserInfo setObject:username forKey:@"userName"];
//    [currentUserInfo setObject:full_name forKey:@"fullName"];
//    [currentUserInfo setObject:followers forKey:@"followers"];
//    
//    [userWithOffers setUerInformation:currentUserInfo];
    
    NSString *loginUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId] forHTTPHeaderField:@"UserId"];
    
    [manager GET: loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *loginInfo=(NSDictionary *) responseObject;
                
                if([[loginInfo objectForKey:@"Success"] intValue]==1&&[[loginInfo objectForKey:@"ErrorCode"] intValue]==0){
                    
                    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId] forHTTPHeaderField:@"UserId"];
                    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?lat=%g&lon=%g&pageIndex=%ld",BASE_URL,OFFERLIST_URL,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,(long)pageIndex];
                  
                    [userWithOffers setCurrentLocation:currentLocation];
                    
                    [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
                        
                        if(pageIndex==0){
                            DELEGATE.totalPage = [[[responseObject objectForKey:@"ResponseResult"]objectForKey:@"TotalPage"] integerValue];
                            offerList=[[NSMutableArray alloc] init];
                        }
                        
                        
                        for(NSDictionary *dic in offerListDictionary){
                            
                            BSOfferDetails *offerWithDetails=[[BSOfferDetails alloc] initWithDictionary:dic];
                            [offerList addObject:offerWithDetails];
                            
                        }
                        [self setUserWithUserID:userId andOfferList:offerList];
                        
                        [self.delegate setupOfferDownloadCompleted:self];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
                }else{
                    NSLog(@"Error");
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Request failure. %@",error);
            }];
}
-(void)setUserWithUserID:(NSString*)userId andOfferList:(NSMutableArray*)offerListData{
    SAMUserPropertiesAndAssets *userWithOffers=[SAMUserPropertiesAndAssets sharedInstance];
    [userWithOffers setUserID:userId];
    [userWithOffers setOfferList:offerListData];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
}
@end
