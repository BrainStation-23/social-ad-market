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
#import "SAMUserPropertiesAndAssets.h"
#import "OfferLogic.h"
#import "SAMTableViewCell.h"
#import "SAMOfferShortDetailsViewController.h"
#import "BaseViewController.h"
#import "SAMMapViewController.h"
#import "SAMMessageViewController.h"
#import "SAMProfileViewController.h"

@interface SocialAddMarketViewController : BaseViewController<BaseViewControllerDelegate, BSCustomSegmentedViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *localOffers;
@property(nonatomic, strong) NSMutableArray *gigsOffers;

@property BOOL isLoggedIn;

@property (weak, nonatomic) IBOutlet BSShortDescriptionView *shortDescriptionView;
@property (readwrite, nonatomic) int yOrigin;
@property (weak, nonatomic) IBOutlet UIImageView *enlargedImageView;
@property (readwrite, nonatomic) BSOfferDetails *offer;



@property(nonatomic, strong) IBOutlet UIImageView *saImageView;
@property(nonatomic, strong) IBOutlet UITableView *saTableView;
@end

