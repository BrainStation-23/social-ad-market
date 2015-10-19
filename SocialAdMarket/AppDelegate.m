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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];
    
    if(userID.length){
        SocialAddMarketViewController *homeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
        self.customNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        self.window.rootViewController = self.customNav;
        
    }else{
        BSLoginViewController *homeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BSLoginViewControllerStoryBoard"];
        self.customNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        self.window.rootViewController = self.customNav;
    }
    
    
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

@end
