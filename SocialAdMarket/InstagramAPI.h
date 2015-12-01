//
//  InstagramAPI.h
//  SocialAdMarket
//
//  Created by BS-125 on 11/17/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramAPI : NSObject

@property (nonatomic, retain) NSString *created_time;
@property (nonatomic, retain) NSString *full_name;
@property (nonatomic, assign) NSInteger idd;
@property (nonatomic, retain) NSString *profile_picture;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *images;
@property (nonatomic, retain) NSString *imageID;

@end



/*
 (
 {
 attribution = "<null>";
 caption =             {
 "created_time" = 1441182546;
 from =                 {
 "full_name" = "Niaj Hasan";
 id = 1927031051;
 "profile_picture" = "https://igcdn-photos-e-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-19/11906329_960233084022564_1448528159_a.jpg";
 username = "niaj.twinbit";
 };
 id = 1065038850223534424;
 text = Gaff;
 };
 comments =             {
 count = 0;
 data =                 (
 );
 };
 "created_time" = 1441182546;
 filter = Normal;
 id = "1065038848680030398_1927031051";
 images =             {
 "low_resolution" =                 {
 height = 320;
 url = "https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/s320x320/e35/11899657_890676307678502_633547342_n.jpg";
 width = 320;
 };
 "standard_resolution" =                 {
 height = 640;
 url = "https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/e35/11899657_890676307678502_633547342_n.jpg";
 width = 640;
 };
 thumbnail =                 {
 height = 150;
 url = "https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/s150x150/e35/11899657_890676307678502_633547342_n.jpg";
 width = 150;
 };
 };
 likes =             {
 count = 0;
 data =                 (
 );
 };
 link = "https://instagram.com/p/7HxzCnkHC-/";
 location = "<null>";
 tags =             (
 );
 type = image;
 user =             {
 "full_name" = "Niaj Hasan";
 id = 1927031051;
 "profile_picture" = "https://igcdn-photos-e-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-19/11906329_960233084022564_1448528159_a.jpg";
 username = "niaj.twinbit";
 };
 "user_has_liked" = 0;
 "users_in_photo" =             (
 );
 },
 
 
 */