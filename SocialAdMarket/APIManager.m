//
//  APIManager.m
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "APIManager.h"
#import "InboxDetails.h"
#import "SVProgressHUD.h"
#import "InstagramAPI.h"
#import "Constants.h"
#import "BSOfferDetails.h"
#import "AppDelegate.h"
#import "GigsOfferList.h"
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
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
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
-(void)getUserLocalOffers:(NSInteger)pageIndex{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"UserID"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userId] forHTTPHeaderField:@"UserId"];
    
    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?lat=%g&lon=%g&pageIndex=%ld",BASE_URL,OFFERLIST_URL,DELEGATE.currentLocation.coordinate.latitude ,DELEGATE.currentLocation.coordinate.longitude,(long)pageIndex];
    
            [manager GET: offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
                
                if(pageIndex==0){
                    DELEGATE.totalPageForLocal = [[[responseObject objectForKey:@"ResponseResult"]objectForKey:@"TotalPage"] integerValue];
                    self.localOfferList=[[NSMutableArray alloc] init];
                }
                
                for(NSDictionary *dic in offerListDictionary){
                    
                    BSOfferDetails *offerWithDetails=[[BSOfferDetails alloc] initWithDictionary:dic];
                    
                    [self.localOfferList addObject:offerWithDetails];
                    
                }
                //[self setUserWithUserID:userId andOfferList:offerList];
                
                [self.delegate gotLocalOffers:self.localOfferList];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}



-(void)getGigsOffers:(NSString *)currentUserId WithPageIndex:(NSInteger )pageIndex{
    
    
     [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",currentUserId]forHTTPHeaderField:@"UserId"];
    
    //NSString *userSentItems=[NSString stringWithFormat:@"%@%@?lat=23&lon=90&pageIndex=0",BASE_URL, LOCALOFFERLIST_URL];
    
    
    NSString *offerTodayAndFutureUrl=[NSString stringWithFormat: @"%@%@?lat=%g&lon=%g&pageIndex=%ld",BASE_URL,LOCALOFFERLIST_URL,DELEGATE.currentLocation.coordinate.latitude ,DELEGATE.currentLocation.coordinate.longitude,(long)pageIndex];

    [manager GET:offerTodayAndFutureUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Reply responseObject===%@",responseObject);
        
        
        NSMutableDictionary *offerListDictionary=[[(NSMutableDictionary *)responseObject objectForKey:@"ResponseResult"] objectForKey:@"OfferList"];
        
        if(pageIndex==0){
            DELEGATE.totalPageForGigs = [[[responseObject objectForKey:@"ResponseResult"]objectForKey:@"TotalPage"] integerValue];
            self.gigsOfferList=[[NSMutableArray alloc] init];
        }
        
        
        for(NSDictionary *dic in offerListDictionary){
            GigsOfferList *gigsOffer = [[GigsOfferList alloc]init];
            
            gigsOffer.AboutTheBrand = [[dic objectForKey:@"Details"] valueForKey:@"AboutTheBrand"];
            gigsOffer.Details = [[dic objectForKey:@"Details"] valueForKey:@"Details"];
            gigsOffer.IntagramHandle = [[dic objectForKey:@"Details"] valueForKey:@"IntagramHandle"];
            gigsOffer.NumberOfPhotos = [[[dic objectForKey:@"Details"] valueForKey:@"NumberOfPhotos"] integerValue];
            gigsOffer.OfferContactEmail = [[dic objectForKey:@"Details"] valueForKey:@"OfferContactEmail"];
            gigsOffer.OfferContactName = [[dic objectForKey:@"Details"] valueForKey:@"OfferContactName"];
            gigsOffer.OfferContactNumber = [[[dic objectForKey:@"Details"] valueForKey:@"OfferContactNumber"] integerValue];
            gigsOffer.OfferContactTitle = [[dic objectForKey:@"Details"] valueForKey:@"OfferContactTitle"];
            gigsOffer.OfferEndDateTimeUtc = [[dic objectForKey:@"Details"] valueForKey:@"OfferEndDateTimeUtc"];
            gigsOffer.OfferStartDateTimeUtc = [[dic objectForKey:@"Details"] valueForKey:@"OfferStartDateTimeUtc"];
            gigsOffer.OptionalTags = [[dic objectForKey:@"Details"] valueForKey:@"OptionalTags"];
            gigsOffer.PostingInstructions = [[dic objectForKey:@"Details"] valueForKey:@"PostingInstructions"];
            gigsOffer.ProductLinks = [[dic objectForKey:@"Details"] valueForKey:@"ProductLinks"];
            gigsOffer.ProductNameOptional = [[dic objectForKey:@"Details"] valueForKey:@"ProductNameOptional"];
            gigsOffer.ProductToFeature = [[dic objectForKey:@"Details"] valueForKey:@"ProductToFeature"];
            gigsOffer.RequiredInCaption = [[dic objectForKey:@"Details"] valueForKey:@"RequiredInCaption"];
            gigsOffer.Rights = [[dic objectForKey:@"Details"] valueForKey:@"Rights"];
            gigsOffer.StayingDays = [[[dic objectForKey:@"Details"] valueForKey:@"StayingDays"] integerValue];
            gigsOffer.StyleInstructions = [[dic objectForKey:@"Details"] valueForKey:@"StyleInstructions"];

            
            gigsOffer.Distance = [[dic valueForKey:@"Distance"] doubleValue];
            gigsOffer.Idd = [[dic valueForKey:@"Id"] integerValue];
            gigsOffer.IsAlreadySwapped = [[dic valueForKey:@"IsAlreadySwapped"] boolValue];
            gigsOffer.IsUsed = [[dic valueForKey:@"IsUsed"] boolValue];
            gigsOffer.IsConfirmed = [[dic valueForKey:@"IsConfirmed"] boolValue];
            gigsOffer.Latitude = [[dic valueForKey:@"Latitude"] doubleValue];
            gigsOffer.Longitude = [[dic valueForKey:@"Longitude"] doubleValue];
            gigsOffer.PictureUrl = [dic valueForKey:@"PictureUrl"];
            gigsOffer.RequiredMinimumInstagramFollowers = [[dic valueForKey:@"RequiredMinimumInstagramFollowers"] integerValue];
            gigsOffer.SubTitle = [dic valueForKey:@"SubTitle"];
            gigsOffer.SwapbaleByFollowerRules = [[dic valueForKey:@"SwapbaleByFollowerRules"] boolValue];
            gigsOffer.Title = [dic valueForKey:@"Title"];

            
            [self.gigsOfferList addObject:gigsOffer];
            
        }
        [delegate gotGigsOffers:self.gigsOfferList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
}



//[NSString stringWithFormat:@"users/self/media/recent"] parameters:params responseModel:[InstagramMedia class]
//accessToken===1927031051.97e74bb.3bdf700675ee4f91a55b453d1fa5697c  Asif
//"access_token" = "2050300525.97e74bb.bad945f595f04cf4bf9e75b6752486b1"; Rupak


- (void)loadMedia
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
        [SVProgressHUD show];

    
    //NSString *link= [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]];
    //NSString *link= [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/snow/media/recent?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]];
    //NSString *link=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed/?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]];

    NSString *link=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]];

    NSLog(@"DDDD%@",link);
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"responseObject===%@",responseObject);
         
             NSArray* userMedia = (NSArray*)[responseObject objectForKey:@"data"];
             NSMutableArray *instagramMedia = [[NSMutableArray alloc] init];
             for(NSDictionary *dic in userMedia){
                 InstagramAPI *IAPI   =[[InstagramAPI alloc] init];
                 //IAPI.created_time  =[[dic objectForKey:@"user"] valueForKey:@"username"];
                 IAPI.full_name       =[[dic objectForKey:@"user"]valueForKey:@"full_name"];
                 IAPI.idd             =[[[dic objectForKey:@"user"] valueForKey:@"id"] integerValue];
                 IAPI.profile_picture =[[dic objectForKey:@"user"]valueForKey:@"profile_picture"];
                 IAPI.username        =[[dic objectForKey:@"user"] valueForKey:@"username"];
                 IAPI.images          =[[[dic objectForKey:@"images"] objectForKey:@"standard_resolution"]valueForKey:@"url"];
                 IAPI.imageID         =[dic valueForKey:@"id"];
                 NSLog(@"imageID===%@",IAPI.images);
                 
                 [instagramMedia addObject:IAPI];
             }
         
             [delegate gotInstagramMedia:instagramMedia];
             [SVProgressHUD dismiss];

     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {

     }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}


@end