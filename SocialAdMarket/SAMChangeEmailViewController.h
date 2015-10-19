//
//  SAMChangeEmailViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/16/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SAMChangeEmailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) IBOutlet UITextField *emailTextField;
@property(nonatomic, strong) IBOutlet UIButton *submitEmailButton;

-(IBAction)goBack:(id)sender;

@end
