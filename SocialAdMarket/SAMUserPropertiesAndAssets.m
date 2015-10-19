//
//  SAMUserPropertiesAndAssets.m
//  SocialAdMarket
//
//  Created by BS-126 on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMUserPropertiesAndAssets.h"

static SAMUserPropertiesAndAssets *instance;

@implementation SAMUserPropertiesAndAssets{
    AFHTTPRequestOperationManager *manager;
}

+ (SAMUserPropertiesAndAssets *) sharedInstance{
    if(instance==nil){
        instance = [[SAMUserPropertiesAndAssets alloc]init];
    }
    return instance;
}

-(void)setUserID:(NSString*)currentUserId{
    userId=currentUserId;
}
-(void)setCurrentLocation:(CLLocation*)currentUserLocation{
    currentLocation=currentUserLocation;
}
-(void)setUerInformation:(NSDictionary*)currentUserInformation{
    userInformation=currentUserInformation;
}
-(void)setOfferList:(NSMutableArray*)offerListForUser{
    offerList=offerListForUser;
}
-(void)setDetailsOfferList:(NSMutableDictionary*)detailsOfferListForUser{
    detailsOfferList = detailsOfferListForUser;
}



-(NSString*)getUserID{
    return userId;
}
-(CLLocation*)getCurrentLocation{
    return currentLocation;
}
-(NSDictionary*)getUerInformation{
    return userInformation;
}

- (NSMutableArray *) getOfferList{
    return offerList;
}

-(NSMutableDictionary*)getDetailsOfferList{
    return detailsOfferList;
}

- (void) addDetailsOfferList: (BSOfferDetails *) offer{
    [detailsOfferList setObject:offer forKey:offer.Id];
}


- (void) addOfferListByPageIndex: (NSString *)pageIndex{
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId]forHTTPHeaderField:@"UserId"];
    
    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?lat=%g&lon=%g&pageIndex=%@",BASE_URL,OFFERLIST_URL,currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, pageIndex];
    
    [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
        
        for(NSDictionary *dic in offerListDictionary){
            BSOfferDetails *offerWithDetails=[[BSOfferDetails alloc] initWithDictionary:dic];
            [offerList addObject:offerWithDetails];
        }
        
        /*
         if([self.delegate respondsToSelector:@selector(userDetailsTaken:withText:)]){
         [self.delegate userDetailsTaken:self withText:(NSMutableDictionary*) allUserInfoDictionary];
         }
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
