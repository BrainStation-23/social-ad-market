//
//  BSMapViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "BSMessageViewController.h"
#import "BSProfileViewController.h"
#import "SocialAddMarketViewController.h"


@interface BSMapViewController : BaseViewController<BaseViewControllerDelegate>

@property(nonatomic, strong) IBOutlet MKMapView *mapView;

@end
