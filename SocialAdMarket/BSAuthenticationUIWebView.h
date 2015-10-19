//
//  BSAuthenticationUIWebView.h
//  SocialAdMarket
//
//  Created by BS-126 on 9/21/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthenticationDelegate <NSObject>

- (void)authenticatedSuccess: (BOOL) success result: (NSDictionary *) result;
- (void)displayActivityIndicator;
- (void)hideActivityIndicator;

@end

@interface BSAuthenticationUIWebView : UIWebView <UIWebViewDelegate>{
    id <AuthenticationDelegate> authenticationDelegate;
}

@property (strong, nonatomic) id <AuthenticationDelegate>authenticationDelegate;
- (void)getToken: (NSMutableDictionary *)request;

@end
