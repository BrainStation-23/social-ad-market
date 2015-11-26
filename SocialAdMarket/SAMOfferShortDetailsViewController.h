//
//  SAMOfferShortDetailsViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSShortDescriptionView.h"
#import "BSOfferDetails.h"
#import "AppDelegate.h"
#import "GigsOfferList.h"
#define MAIN_LABEL_Y_ORIGIN 0
#define IMAGEVIEW_Y_ORIGIN 15


@interface SAMOfferShortDetailsViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *enlargedImageView;
@property(nonatomic, strong) IBOutlet BSShortDescriptionView *shortDescriptionView;
@property (readwrite, nonatomic) int yOrigin;


@property (readwrite, nonatomic) BSOfferDetails *offer;
@property (nonatomic, retain) GigsOfferList *gigsOfferList;
@property (nonatomic , assign) BOOL flagForGigs;

@end
