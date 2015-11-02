//
//  SAMessageDetailsViewController.h
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxDetails.h"
@interface SAMessageDetailsViewController : UIViewController


@property (nonatomic, retain) InboxDetails *IBD;
@property (nonatomic, assign) BOOL flagForReplyBtn;

@end
