//
//  BSItemShortDetailsViewViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSShortDescriptionView.h"
#import "BSOfferDetails.h"
#import "AppDelegate.h"

#define MAIN_LABEL_Y_ORIGIN 0
#define IMAGEVIEW_Y_ORIGIN 15


@interface BSOfferShortDetailsViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *enlargedImageView;
@property(nonatomic, strong) IBOutlet BSShortDescriptionView *shortDescriptionView;
@property (readwrite, nonatomic) int yOrigin;


@property (readwrite, nonatomic) BSOfferDetails *offer;




@end
