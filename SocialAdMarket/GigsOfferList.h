//
//  GigsOfferList.h
//  SocialAdMarket
//
//  Created by BS-125 on 11/26/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GigsOfferList : NSObject

@property (nonatomic, retain) NSString *AboutTheBrand;
@property (nonatomic, retain) NSString *Details;
@property (nonatomic, retain) NSString *IntagramHandle;
@property (nonatomic, assign) NSInteger NumberOfPhotos;
@property (nonatomic, retain) NSString *OfferContactEmail;
@property (nonatomic, assign) NSString *OfferContactName;
@property (nonatomic, assign) NSInteger OfferContactNumber;
@property (nonatomic, retain) NSString *OfferContactTitle;
@property (nonatomic, retain) NSString *OfferEndDateTimeUtc;
@property (nonatomic, retain) NSString *OfferStartDateTimeUtc;
@property (nonatomic, retain) NSString *OptionalTags;
@property (nonatomic, retain) NSString *PostingInstructions;
@property (nonatomic, retain) NSString *ProductLinks;
@property (nonatomic, retain) NSString *ProductNameOptional;

@property (nonatomic, retain) NSString *ProductToFeature;
@property (nonatomic, retain) NSString *RequiredInCaption;
@property (nonatomic, retain) NSString *Rights;
@property (nonatomic, assign) NSInteger StayingDays;
@property (nonatomic, retain) NSString *StyleInstructions;

@property (nonatomic, assign) double Distance;
@property (nonatomic, assign) NSInteger Idd;
@property (nonatomic, assign) BOOL IsAlreadySwapped;
@property (nonatomic, assign) BOOL IsConfirmed;
@property (nonatomic, assign) BOOL IsUsed;
@property (nonatomic, assign) double Latitude;
@property (nonatomic, assign) double Longitude;
@property (nonatomic, retain) NSString *PictureUrl;
@property (nonatomic, assign) NSInteger RequiredMinimumInstagramFollowers;
@property (nonatomic, retain) NSString *SubTitle;
@property (nonatomic, assign) bool SwapbaleByFollowerRules;

@property (nonatomic, retain) NSString *Title;



@end

/*
Error = "<null>";
ErrorCode = 0;
ResponseResult =     {
    OfferList =         (
                         {
                             Details =                 {
                                 AboutTheBrand = sdfsafs;
                                 Details = ZSDszfdsfadf;
                                 IntagramHandle = Tok;
                                 NumberOfPhotos = 2;
                                 OfferContactEmail = "ewaw@sxfds.com";
 
                                 OfferContactName = asqwewq;
                                 OfferContactNumber = 12321324;
                                 OfferContactTitle = 231213214324;
                                 OfferEndDateTimeUtc = "2016-11-25T00:00:00";
                                 OfferStartDateTimeUtc = "2016-11-18T00:00:00";
                                 OptionalTags = dsfaf;
                                 PostingInstructions = asdfasd;
                                 ProductLinks = sadfsaf;
                                 ProductNameOptional = sdfsa;
                                 ProductToFeature = dfgdf;
                                 RequiredInCaption = wedwd;
                                 Rights = sadfsa;
                                 StayingDays = 23;
                                 StyleInstructions = sdasdfsfd;
                             };
                             Distance = "5625.153600019337";
                             Id = 1;
                             IsAlreadySwapped = 0;
                             IsConfirmed = 0;
                             IsUsed = 0;
                             Latitude = "39.8085360414459";
                             Longitude = "32.958984375";
                             PictureUrl = "http://104.215.139.165:2323/content/images/thumbs/0000041_600.jpeg";
                             RequiredMinimumInstagramFollowers = 0;
                             SubTitle = Coke;
                             SwapbaleByFollowerRules = 1;
                             Title = Soke;
                         }
                         );
    TotalPage = 0;
};
Success = 1;
} */