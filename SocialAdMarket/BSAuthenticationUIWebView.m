//
//  BSAuthenticationUIWebView.m
//  SocialAdMarket
//
//  Created by BS-126 on 9/21/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSAuthenticationUIWebView.h"

@implementation BSAuthenticationUIWebView{
    NSMutableDictionary *requestParameters;
    NSMutableDictionary *resultParameters;
}
@synthesize authenticationDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)getToken: (NSMutableDictionary *)request {
    requestParameters = request;
    NSURL *myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?"
                                         @"client_id=%@"
                                         @"&redirect_uri=%@"
                                         @"&response_type=token",
                                         requestParameters[@"key"],
                                         [self urlEncode: requestParameters[@"redirectUrl"]]]
                    ];
    
    NSMutableURLRequest *myRequest = [NSMutableURLRequest
                                      requestWithURL: myUrl
                                      cachePolicy:(NSURLRequestCachePolicy)NSURLCacheStorageAllowed
                                      timeoutInterval:60.0];
    
    [myRequest setHTTPShouldHandleCookies:YES];
    [self loadRequest:myRequest];
}

- (BOOL)webView: (UIWebView *)webView
shouldStartLoadWithRequest: (NSURLRequest *)request
 navigationType: (UIWebViewNavigationType)navigationType {
    
    if ([[request.URL.absoluteString lowercaseString]
         rangeOfString:[requestParameters[@"redirectUrl"]
                        lowercaseString]].location != 0) {
             return YES;
             
         } else {
             
             NSArray *urlArray = [request.URL.absoluteString
                                  componentsSeparatedByString:@"#"];
             NSArray *parameterArray = [NSArray new];
             resultParameters = [NSMutableDictionary new];
             
             if ([urlArray count] > 0) {
                 parameterArray = [urlArray[1] componentsSeparatedByString:@"&"];
                 for (NSString *item in parameterArray) {
                     [resultParameters
                      setObject:[item
                                 componentsSeparatedByString:@"="][1]
                      forKey:[item componentsSeparatedByString:@"="][0]];
                 }
             }
             return NO;
             
         }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [authenticationDelegate displayActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [authenticationDelegate hideActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [authenticationDelegate hideActivityIndicator];
    
    if (error.code == 102) {
        
        [self loadRequest:[NSURLRequest
                           requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self authenticationComplete];
        
    } else {
        NSLog(@"Unexpected error.code = %ld",(long)error.code);
    }
}


- (void)authenticationComplete {
    [authenticationDelegate authenticatedSuccess: YES result: resultParameters];
}

- (void)requestTimedOut {
    [self authenticationFailure];
}

- (void)authenticationFailure {
    [self stopLoading];
    [authenticationDelegate authenticatedSuccess: NO result: resultParameters];
}

-(NSString*) urlEncode: (NSString *)string
{
    NSString *encodedString = (NSString *)CFBridgingRelease( CFURLCreateStringByAddingPercentEscapes(
                                                                     NULL,                                                                                                  (CFStringRef)string,
                                                                     NULL,
                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}


@end
