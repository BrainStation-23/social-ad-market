//
//  BaseViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/15/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DWBubbleMenuButton.h"
#import "AppDelegate.h"


@protocol BaseViewControllerDelegate;


@interface BaseViewController : UIViewController

@property(nonatomic, strong) DWBubbleMenuButton *expandableMenu;
@property(nonatomic, strong) UILabel *expandButtonLabel;

@property(nonatomic, strong) id<BaseViewControllerDelegate> delegate;

@end


@protocol BaseViewControllerDelegate <NSObject>

- (void)loadView:(UIButton *)sender;

@end