//
//  APIManager.m
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "APIManager.h"
#import "InboxDetails.h"
#define baseURLString @""

static APIManager* sharedManger = nil;

@implementation APIManager
@synthesize delegate;

+ (APIManager*) sharedManager {
    
    if (!sharedManger) {
        sharedManger = [[APIManager alloc] initWithBaseURL];
    }
    
    return sharedManger;
}

- (instancetype)initWithBaseURL {
    self = [super init];
    
    if (self) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    
    return self;
}


-(void)getSentItems:(NSString*)currentUserId{
    
    
//    manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    NSString *userSentItems=[NSString stringWithFormat:@"http://104.215.139.165:2323/api/User/UserSentItems?PageIndex=0"];
    
    [manager GET:userSentItems parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSLog(@"responseObject===%@",responseObject);
        
        NSLog(@"responseObject===%@",responseObject);
        
        NSLog(@"responseObject===%@",responseObject);
        NSArray* sentItemArray = (NSArray*)[[responseObject objectForKey:@"ResponseResult"]objectForKey:@"Messages"];
        NSMutableArray *sentArray = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in sentItemArray){
            InboxDetails *IB = [[InboxDetails alloc] init];
            IB.CreatedOn = [dic valueForKey:@"CreatedOn"];
            IB.CustomerFromName = [dic valueForKey:@"CustomerFromName"];
            IB.CustomerToName = [dic valueForKey:@"CustomerToName"];
            IB.FromCustomerId = [dic valueForKey:@"FromCustomerId"];
            IB.Id = [dic valueForKey:@"Id"];
            IB.IsRead = [[dic valueForKey:@"IsRead"] boolValue];
            IB.Message = [dic valueForKey:@"Message"];
            IB.Subject = [dic valueForKey:@"Subject"];
            IB.ToCustomerId = [dic valueForKey:@"ToCustomerId"];
            [sentArray addObject:IB];
        }
        
        [delegate gotSentItems:sentArray];
        
        }
        //        NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
        //
        //        for(NSDictionary *dic in offerListDictionary){
        //            BSOfferDetails *offerWithDetails=[[BSOfferDetails alloc] initWithDictionary:dic];
        //            [offerList addObject:offerWithDetails];
        //        }
        
        /*
         if([self.delegate respondsToSelector:@selector(userDetailsTaken:withText:)]){
         [self.delegate userDetailsTaken:self withText:(NSMutableDictionary*) allUserInfoDictionary];
         }
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
}

-(void)getInboxItems:(NSString *)currentUserId {
    
//    manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    NSString *userInboxItems=[NSString stringWithFormat:@"http://104.215.139.165:2323/api/User/UserInbox?PageIndex=0"];
    
    [manager GET:userInboxItems parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
    if ([[responseObject objectForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
 
        
        NSArray* inboxItemArray = (NSArray*)[[responseObject objectForKey:@"ResponseResult"]objectForKey:@"Messages"];
        NSMutableArray *inboxArray = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in inboxItemArray){
            InboxDetails *IB = [[InboxDetails alloc] init];
            IB.CreatedOn = [dic valueForKey:@"CreatedOn"];
            IB.CustomerFromName = [dic valueForKey:@"CustomerFromName"];
            IB.CustomerToName = [dic valueForKey:@"CustomerToName"];
            IB.FromCustomerId = [dic valueForKey:@"FromCustomerId"];
            IB.Id = [dic valueForKey:@"Id"];
            IB.IsRead = [[dic valueForKey:@"IsRead"] boolValue];
            IB.Message = [dic valueForKey:@"Message"];
            IB.Subject = [dic valueForKey:@"Subject"];
            IB.ToCustomerId = [dic valueForKey:@"ToCustomerId"];
            [inboxArray addObject:IB];
        }
        [delegate gotInboxItems:inboxArray];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)viewUserInboxMessage:(NSString *)currentUserId WithId:(NSString *)Id{
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    NSString *userSentItems=[NSString stringWithFormat:@"http://104.215.139.165:2323/api/User/ViewUserInboxMessage?privateMessageId=%@",Id];
    
    [manager GET:userSentItems parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [delegate successFullyReadMessage];
        
        NSLog(@"Delete responseObject===%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
  
    
    
}


-(void)deleteMessage:(NSString *)currentUserId WithId:(NSString *)Id{
    
//    manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    NSString *userSentItems=[NSString stringWithFormat:@"http://104.215.139.165:2323/api/User/DeleteUserMessage?privateMessageId=%@",Id];
    
    [manager GET:userSentItems parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        [delegate successFullyDeleteMessage];
        NSLog(@"Delete responseObject===%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)replyMessage:(NSString *)currentUserId WithParameters:(NSDictionary *)parameters {
    
//    manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    
    NSString *userSentItems=[NSString stringWithFormat:@"http://104.215.139.165:2323/api/User/SendMessage"];
    [manager POST:userSentItems parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Reply responseObject===%@",responseObject);
        
        [delegate successFullySentMessage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}







@end