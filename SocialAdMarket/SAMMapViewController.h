//
//  SAMMapViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "SAMMessageViewController.h"
#import "SAMProfileViewController.h"
#import "SocialAddMarketViewController.h"


@interface SAMMapViewController : BaseViewController<BaseViewControllerDelegate>

@property(nonatomic, strong) IBOutlet MKMapView *mapView;

@end
