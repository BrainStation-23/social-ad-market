//
//  SwappedOfferDetails.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/16/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwappedOfferDetails : NSObject

@property (nonatomic, retain) NSString *Details;
@property (nonatomic, assign) double Distance;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) BOOL IsAlreadySwapped;
@property (nonatomic, assign) BOOL IsUsed;
@property (nonatomic, retain) NSString *Latitude;
@property (nonatomic, retain) NSString *Longitude;
@property (nonatomic, retain) NSString *PictureUrl;
@property (nonatomic, assign) NSInteger RequiredMinimumInstagramFollowers;
@property (nonatomic, assign) BOOL SwapbaleByFollowerRules;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *SubTitle;


-(SwappedOfferDetails*)initWithDictionary:(NSDictionary*)dictionary;

@end
