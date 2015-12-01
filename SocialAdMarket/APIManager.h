//
//  APIManager.h
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@protocol APIManagerDelegate;

@interface APIManager : NSObject{
    
    AFHTTPRequestOperationManager *manager;
    
}
@property (strong, nonatomic) NSObject <APIManagerDelegate>* delegate;
+(APIManager*) sharedManager;

@property (nonatomic, retain) NSMutableArray *gigsOfferList;
@property (nonatomic, retain) NSMutableArray *localOfferList;


-(void)getSentItems:(NSString *)currentUserId;
-(void)getInboxItems:(NSString *)currentUserId;
-(void)viewUserInboxMessage:(NSString *)currentUserId WithId:(NSString *)Id;
-(void)deleteMessage:(NSString *)currentUserId WithId:(NSString *)Id;
-(void)replyMessage:(NSString *)currentUserId WithParameters:(NSDictionary *)parameters;
- (void)loadMedia;
-(void)getGigsOffers:(NSString *)currentUserId WithPageIndex:(NSInteger )pageIndex;


-(void)getUserLocalOffers:(NSInteger)pageIndex;

@end


@protocol APIManagerDelegate
@optional

- (void) gotSentItems:(NSArray *) sentItems;
- (void) gotInboxItems:(NSArray *) sentItems;
- (void) successFullySentMessage;
- (void) successFullyDeleteMessage;
- (void) successFullyReadMessage;
- (void) gotGigsOffers:(NSMutableArray *)gigsOfferArray;
- (void) gotLocalOffers:(NSMutableArray *)localOfferArray;

-(void) gotInstagramMedia:(NSArray *)mediaArray;
@end