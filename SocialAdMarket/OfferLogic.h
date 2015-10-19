//
//  OfferLogic.h
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"


@protocol  OfferLogicDelegate;

@interface OfferLogic : NSObject<CLLocationManagerDelegate>


@property (nonatomic,weak) id <OfferLogicDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *offerList;

-(void)setUserOffers:(NSInteger)pageIndex;

@end

@protocol OfferLogicDelegate <NSObject>

-(void)setupOfferDownloadCompleted:(OfferLogic*)offerLogic;

@end
