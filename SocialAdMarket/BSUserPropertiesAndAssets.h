//
//  BSUserPropertiesAndAssets.h
//  SocialAdMarket
//
//  Created by BS-126 on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "BSOfferDetails.h"

@interface BSUserPropertiesAndAssets : NSObject{
  NSString *userId;
  CLLocation *currentLocation;
  NSDictionary *userInformation;
  NSMutableArray *offerList;
  NSMutableDictionary *detailsOfferList;
}
+(BSUserPropertiesAndAssets*) sharedInstance;

//setter
-(void)setUserID:(NSString*)currentUserId;
-(void)setCurrentLocation:(CLLocation*)currentUserLocation;
-(void)setUerInformation:(NSDictionary*)currentUserInformation;
-(void)setOfferList:(NSMutableArray*)offerListForUser;
-(void)setDetailsOfferList:(NSMutableDictionary*)detailsOfferListForUser;

//getter
-(NSString*)getUserID;
-(CLLocation*)getCurrentLocation;
-(NSDictionary*)getUerInformation;
-(NSMutableArray*)getOfferList;
-(NSMutableDictionary*)getDetailsOfferList;



- (void) addDetailsOfferList: (BSOfferDetails *) offer;
- (void) addOfferListByPageIndex: (NSString *)pageIndex;


@end
