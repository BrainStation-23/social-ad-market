//
//  ViewController.m
//  SocialAdMarket
//
//  Created by BS23 on 9/21/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSLoginViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static AFHTTPRequestOperationManager *manager;

@interface BSLoginViewController (){
    SAMUserPropertiesAndAssets *userWithOffers;
    
}

@end

@implementation BSLoginViewController{
    BSAuthenticationUIWebView *authenticationWebView;
    
    BOOL isAccessTokenValid;
    
    UIButton *signOutButton;

    UILabel *accessTokenTimeRemainingLabel;
    
    NSTimer *accessTokenExpirationTimer;
    double accessTokenTimeRemaining;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    locationManager = [[CLLocationManager alloc] init] ;
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER){
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
    
    signOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signOutButton addTarget:self
                      action:@selector(handleSignOutButton:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [signOutButton setTitle:@"Clear previous login"
                   forState: UIControlStateNormal];
    
    signOutButton.frame =
    CGRectMake(10,self.view.frame.size.height-54,self.view.frame.size.width-10,44);
    [self.view addSubview:signOutButton];
    
    accessTokenTimeRemainingLabel =
    [[UILabel alloc]
     initWithFrame:CGRectMake(18, self.view.frame.size.height-86, 283, 21)];
    
    [accessTokenTimeRemainingLabel
     setFont:[UIFont fontWithName:@"Courier New" size:13.0f]];
    
    [accessTokenTimeRemainingLabel setTextColor:[UIColor blackColor]];
    
    [accessTokenTimeRemainingLabel
     setText: @"Access Token Time Remaining: expired"];

    [SVProgressHUD showWithStatus:@"Loading..."];
    
//    activityIndicator =
//    [[UIActivityIndicatorView alloc]
//     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicator.frame =CGRectMake(self.view.frame.size.width/2-25,
//                                        self.view.frame.size.height/2-50,50,50);
//    
//    activityIndicator.color = [UIColor grayColor];
//    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(-20, activityIndicator.frame.size.height, activityIndicator.frame.size.width+40, 20)];
//    textLabel.text=@"Loading ...";
//    textLabel.textAlignment=NSTextAlignmentCenter;
//    [activityIndicator.viewForBaselineLayout addSubview:textLabel];
//    
//    [activityIndicator startAnimating];
    isAccessTokenValid = NO;
    
    [self authenticate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)authenticate {
    
    self.requestParameters = [[NSMutableDictionary alloc] init];
    [self.requestParameters setObject:@"97e74bbb6d314f98b0d28e936221fee3" forKey:@"key"];
    [self.requestParameters setObject:@"http://localhost" forKey:@"redirectUrl"];
    
    if ([self.requestParameters[@"key"] isEqualToString:@""] ||
        [self.requestParameters[@"redirectUrl"] isEqualToString:@""]) {
        NSLog(@"resirect url or key is invalid");
        
    } else {
        authenticationWebView = [[BSAuthenticationUIWebView alloc]
                                 initWithFrame:CGRectMake
                                 (0, 20, self.view.frame.size.width,
                                  self.view.frame.size.height-79)];
        authenticationWebView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        authenticationWebView.authenticationDelegate = self;
        
        [self.view addSubview:authenticationWebView];
        
        [authenticationWebView getToken:_requestParameters];
    }
}

- (void)authenticatedSuccess:(BOOL)success result:(NSMutableDictionary *)result {
    
    userWithOffers =[SAMUserPropertiesAndAssets sharedInstance];
    self.resultParameters = result;
    
    if ([result objectForKey:@"expires_in"] != nil) {
        
        accessTokenTimeRemaining =
        [[result objectForKey:@"expires_in"] floatValue];
        
        if (accessTokenExpirationTimer.isValid) {
            [accessTokenExpirationTimer invalidate];
        }
        
        accessTokenExpirationTimer = [NSTimer
                                      scheduledTimerWithTimeInterval:1.0
                                      target:self
                                      selector:@selector(decrementAccessTokenTimer:)
                                      userInfo:nil
                                      repeats:YES];
        
    } else {
        [accessTokenTimeRemainingLabel
         setText: @"Error in Authentication Process"];
    }
    
    if (success) {
        NSMutableDictionary *jsonDataDictionary=[[NSMutableDictionary alloc]init];
        NSString *url=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@",[result objectForKey:@"access_token"]];
        NSURL *jsonURL = [NSURL URLWithString:url];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        NSError *error = nil;
        jsonDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        // To check temporary details
        [authenticationWebView removeFromSuperview];
        authenticationWebView = nil;
        
        NSString *followers=[[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"counts"] objectForKey:@"followed_by"];
        __block NSString *userId=[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"id"];
        
        //NSString *valueToSave = @"someValue";
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"access_token"] forKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSString *username=[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"username"];
        NSString *full_name=[[jsonDataDictionary objectForKey:@"data"] objectForKey:@"full_name"];
        
        NSMutableDictionary *currentUserInfo = [[NSMutableDictionary alloc]init];
        [currentUserInfo setObject:username forKey:@"userName"];
        [currentUserInfo setObject:full_name forKey:@"fullName"];
        [currentUserInfo setObject:followers forKey:@"followers"];
        
        [userWithOffers setUerInformation:currentUserInfo];
        
        NSDictionary *parameters = @{@"BsInstagramUserId": userId,@"Username": username,@"Name": full_name,@"Authenticate_Token": [result objectForKey:@"access_token"],@"TotalFollowers": followers};
        NSString *registrationUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTRATION_URL];
        
        [manager POST: registrationUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *registrationInfo=(NSDictionary *) responseObject;
            
            if([[registrationInfo objectForKey:@"Success"] intValue]==1&&[[registrationInfo objectForKey:@"ErrorCode"] intValue]==0){
                
                NSString *loginUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL];
                [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId] forHTTPHeaderField:@"UserId"];
                
                [manager GET: loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *loginInfo=(NSDictionary *) responseObject;
                    
                    if([[loginInfo objectForKey:@"Success"] intValue]==1&&[[loginInfo objectForKey:@"ErrorCode"] intValue]==0){
                      
                        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId] forHTTPHeaderField:@"UserId"];
                        NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?lat=%g&lon=%g&pageIndex=0",BASE_URL,OFFERLIST_URL,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
                        
                        [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
                            
                            NSMutableArray *offerList=[[NSMutableArray alloc] init];
                            
                            for(NSDictionary *dic in offerListDictionary){
                                
                                BSOfferDetails *offerWithDetails=[[BSOfferDetails alloc] initWithDictionary:dic];
                                [offerList addObject:offerWithDetails];
                                
                            }
                            [self setUserWithUserID:userId andOfferList:offerList];
                            
                            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            SocialAddMarketViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
                            
                            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [self presentViewController:navController animated:YES completion:nil];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                        }];
                    }else{
                         NSLog(@"Error");
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Request failure. %@",error);
                }];
            }else{
                NSLog(@"Error");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request failure. %@",error);
        }];
        
        isAccessTokenValid = YES;
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"FAILURE\n%@",result]);
        isAccessTokenValid = NO;
    }
}
-(void)setUserWithUserID:(NSString*)userId andOfferList:(NSMutableArray*)offerList{
    [userWithOffers setCurrentLocation:currentLocation];
    [userWithOffers setUserID:userId];
    [userWithOffers setOfferList:offerList];
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

- (IBAction)handleSignInAgainButton:(id)sender {
    [self authenticate];
}

- (IBAction)handleSignOutButton:(id)sender {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage =[NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self authenticate];
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [signOutButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else{
        //reset clicked
    }
}

- (void)decrementAccessTokenTimer:(id)sender {
    
    accessTokenTimeRemaining--;
    
    if (accessTokenTimeRemaining < 0) {
        [accessTokenTimeRemainingLabel
         setText: @"Access Token Time Remaining: expired"];
        [accessTokenExpirationTimer invalidate];
        isAccessTokenValid = NO;
    } else {
        [accessTokenTimeRemainingLabel setText:
         [NSString stringWithFormat:@"Access Token Time Remaining: %d",
          (int)accessTokenTimeRemaining]];
    }
}


- (void) displayActivityIndicator {
   // [self.view addSubview:activityIndicator];
}

- (void) hideActivityIndicator {
    //[activityIndicator removeFromSuperview];
    [SVProgressHUD dismiss];
}

@end
