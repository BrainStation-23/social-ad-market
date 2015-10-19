//
//  SAMMessageViewController.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SAMMapViewController.h"
#import "SAMProfileViewController.h"
#import "SocialAddMarketViewController.h"


@interface SAMMessageViewController : BaseViewController<BaseViewControllerDelegate>

@property(nonatomic,strong) IBOutlet UILabel *placeHolderTextLabel;
@end
