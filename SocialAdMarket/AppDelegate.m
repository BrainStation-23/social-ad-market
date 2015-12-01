//
//  AppDelegate.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/19/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "AppDelegate.h"
#import "SocialAddMarketViewController.h"
#import "BSLoginViewController.h"
#import "SAMUserPropertiesAndAssets.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>{
    SAMUserPropertiesAndAssets *userWithOffers;
    CLLocationManager *locationManager;
}

@end

@implementation AppDelegate
@synthesize currentLocation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];
    
    
    userID = @"1599700360";
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];

    
   // NSString *accessToken = [[NSUserDefaults standardUserDefaults]
     //                   stringForKey:@"accessToken"];
    //SocialAdMarket[2248:51974] 1599700360
    NSLog(@"%@",userID);
    if(userID.length){
        SocialAddMarketViewController *homeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
        self.customNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        self.window.rootViewController = self.customNav;
        
    }else{
        BSLoginViewController *homeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BSLoginViewControllerStoryBoard"];
        self.customNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        self.window.rootViewController = self.customNav;
    }
    
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
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    currentLocation = newLocation;
    
    [userWithOffers setCurrentLocation:newLocation];
    
   // NSLog(@"currentLocation===%@",currentLocation);
    
}
@end
