//
//  SAMProfileViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMUserPropertiesAndAssets.h"
#import "BaseViewController.h"
#import "SAMMapViewController.h"
#import "SAMMessageViewController.h"
#import "SocialAddMarketViewController.h"
#import "ItemElaborateDetailsViewController.h"
#import "SAMSettingsViewController.h"
#import "SAMTableViewCell.h"
#import "BSCustomSegmentedView.h"
#import "APIManager.h"

@interface SAMProfileViewController : BaseViewController<BSCustomSegmentedViewDelegate,BaseViewControllerDelegate, UITableViewDataSource, UITableViewDelegate,APIManagerDelegate>

@property(nonatomic, strong) IBOutlet UILabel *userName;
@property(nonatomic, strong) IBOutlet UITableView *swappedTable;
@property (nonatomic,strong) IBOutlet UIImageView *profileImage;

-(IBAction)ShowSettingsPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;


@property(nonatomic, strong) NSMutableArray *localOffers;
@property(nonatomic, strong) NSMutableArray *gigsOffers;
@end