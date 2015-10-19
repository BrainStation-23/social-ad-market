//
//  SAMSettingsViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/15/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SuggestMerchantViewController.h"

@interface SAMSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) IBOutlet UIButton *BackButton;
@property(nonatomic, strong) IBOutlet UITableView *settingsTableView;


-(IBAction)goBack:(id)sender;
-(void)presentEmailView;
@end
