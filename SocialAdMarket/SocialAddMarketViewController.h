//
//  SocialAddMarketViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "BSLoginViewController.h"
#import "BSCustomSegmentedView.h"
#import "BSUserPropertiesAndAssets.h"
#import "OfferLogic.h"
#import "PopularPayTableViewCell.h"
#import "BSOfferShortDetailsViewController.h"
#import "BaseViewController.h"
#import "BSMapViewController.h"
#import "BSMessageViewController.h"
#import "BSProfileViewController.h"

@interface SocialAddMarketViewController : BaseViewController<BaseViewControllerDelegate, BSCustomSegmentedViewDelegate, UITableViewDataSource, UITableViewDelegate,OfferLogicDelegate>

@property(nonatomic, strong) NSMutableArray *offers;

@property BOOL isLoggedIn;

@property(nonatomic, strong) IBOutlet UIImageView *saImageView;
@property(nonatomic, strong) IBOutlet UITableView *saTableView;
@end

