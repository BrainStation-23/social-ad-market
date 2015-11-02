//
//  InboxDetails.h
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxDetails : NSObject
@property (nonatomic, retain) NSString *CreatedOn;
@property (nonatomic, retain) NSString *CustomerFromName;
@property (nonatomic, retain) NSString *CustomerToName;
@property (nonatomic, retain) NSString *FromCustomerId;
@property (nonatomic, retain) NSString *Message;
@property (nonatomic, retain) NSString *Id;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, retain) NSString *Subject;
@property (nonatomic, retain) NSString *ToCustomerId;




@end
