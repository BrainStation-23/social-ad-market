//
//  SwappedOfferDetails.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/16/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SwappedOfferDetails.h"

@implementation SwappedOfferDetails

-(SwappedOfferDetails*)initWithDictionary:(NSDictionary*)dic{
    
    if(dic){
        if(![[dic valueForKey:@"Details"]isKindOfClass:[NSNull class]])
            self.Details = [dic valueForKey:@"Details"];
        
        if(![[dic valueForKey:@"Distance"]isKindOfClass:[NSNull class]])
            self.Distance = [[dic valueForKey:@"Distance"] doubleValue];
        
        self.Id = [[dic valueForKey:@"Id"] integerValue];
        self.IsAlreadySwapped = [[dic valueForKey:@"IsAlreadySwapped"] boolValue];
        self.IsUsed = [[dic valueForKey:@"IsUsed"] boolValue];
        
        if(![[dic valueForKey:@"Latitude"]isKindOfClass:[NSNull class]])
            self.Latitude = [dic valueForKey:@"Latitude"];
        
        if(![[dic valueForKey:@"Longitude"]isKindOfClass:[NSNull class]])
            self.Longitude = [dic valueForKey:@"Longitude"];
        self.PictureUrl = [dic valueForKey:@"PictureUrl"];
        self.RequiredMinimumInstagramFollowers = [[dic valueForKey:@"RequiredMinimumInstagramFollowers"] integerValue];
        self.SwapbaleByFollowerRules = [[dic valueForKey:@"SwapbaleByFollowerRules"] boolValue];
        self.Title = [dic valueForKey:@"Title"];
    }
    return self;
}

@end
