//
//  BSProfileViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSUserPropertiesAndAssets.h"
#import "BaseViewController.h"
#import "BSMapViewController.h"
#import "BSMessageViewController.h"
#import "SocialAddMarketViewController.h"
#import "SAMSettingsViewController.h"
#import "PopularPayTableViewCell.h"

@interface BSProfileViewController : BaseViewController<BaseViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel *userName;
@property(nonatomic, strong) IBOutlet UITableView *swappedTable;

-(IBAction)ShowSettingsPage:(id)sender;

@end
