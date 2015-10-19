//
//  ViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 9/21/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSOfferDetails.h"
#import "Constants.h"
#import "BSUserPropertiesAndAssets.h"
#import <Foundation/Foundation.h>
#import "BSAuthenticationUIWebView.h"
#import <CoreLocation/CoreLocation.h>
#import "SocialAddMarketViewController.h"
#import "AppDelegate.h"

@protocol sendUserInformationDelegate;

@interface BSLoginViewController : UIViewController <AuthenticationDelegate,UIAlertViewDelegate, CLLocationManagerDelegate>
@property (nonatomic,strong) id<sendUserInformationDelegate> delegate;

@property (retain, nonatomic) NSMutableDictionary *requestParameters;
@property (retain, nonatomic) NSDictionary *resultParameters;

@end

@protocol sendUserInformationDelegate <NSObject>

- (void) userDetailsTaken: (BSLoginViewController *) viewController withText:(NSMutableDictionary *)userAllInfoDictionary;

@end
