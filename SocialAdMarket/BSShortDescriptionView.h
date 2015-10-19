//
//  BSShortDescriptionView.h
//  SocialAdMarket
//
//  Created by BS23 on 10/5/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSShortDescriptionView : UIView

@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *subTitleLabel; //green color

@property(nonatomic, strong) IBOutlet UILabel *briefDescriptionLabel;

@property(nonatomic, strong) IBOutlet UILabel *requiredFollowersLabel;

@property(nonatomic, strong) IBOutlet UILabel *milesLabel;

@property(nonatomic, strong) IBOutlet UIButton *swapButton;

@end
