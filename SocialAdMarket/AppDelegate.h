//
//  AppDelegate.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/19/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCustomSegmentedView.h"
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate : UIResponder <UIApplicationDelegate>
#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *customNav;
@property (nonatomic, retain) BSCustomSegmentedView *segmentedView;

@property(nonatomic, assign) NSInteger paginIndexForLocal;
@property(nonatomic, assign) NSInteger paginIndexForGigs;

@property(nonatomic, assign) NSInteger totalPageForLocal;
@property(nonatomic, assign) NSInteger totalPageForGigs;

@property (nonatomic, retain) CLLocation *currentLocation;


@end