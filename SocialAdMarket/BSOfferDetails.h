//
//  BSOfferDetails.h
//  SocialAdMarket
//
//  Created by BS-126 on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSOfferDetails : NSObject

@property (nonatomic,strong) NSString *IsUsed;
@property (nonatomic,strong) NSString *IsAlreadySwapped;
@property (nonatomic,strong) NSString *Latitude;
@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *RequiredMinimumInstagramFollowers;
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *SwapbaleByFollowerRules;
@property (nonatomic,strong) NSString *Distance;
@property (nonatomic,strong) NSString *Longitude;
@property (nonatomic,strong) NSString *Details;
@property (nonatomic,strong) NSString *PictureUrl;

-(BSOfferDetails*)initWithDictionary:(NSDictionary*)dictionary;

@end
