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
#import "SAMSettingsViewController.h"
#import "SAMTableViewCell.h"

@interface SAMProfileViewController : BaseViewController<BaseViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel *userName;
@property(nonatomic, strong) IBOutlet UITableView *swappedTable;

-(IBAction)ShowSettingsPage:(id)sender;

@end
