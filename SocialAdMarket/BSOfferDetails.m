//
//  BSOfferDetails.m
//  SocialAdMarket
//
//  Created by BS-126 on 9/28/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSOfferDetails.h"

@implementation BSOfferDetails

-(BSOfferDetails*)initWithDictionary:(NSDictionary*)dictionary{
   
    if(dictionary){
        for(NSString *key in [dictionary allKeys]){
            [self setValue:[dictionary valueForKey:key] forKey:key];
        }
        
    }
    return self;
}

@end
