//
//  BLCLoginViewController.m
//  Blocstagram
//
//  Created by Eric Gu on 12/30/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import "BLCLoginViewController.h"
#import "BLCDataSource.h"

@interface BLCLoginViewController ( ) <UIWebViewDelegate>

//We use Instagram API's Login Page
@property ( nonatomic, weak ) UIWebView *webView;

@end

@implementation BLCLoginViewController

NSString *const BLCLoginViewControllerDidGetAccessTokenNotification = @"BLCLoginViewControllerDidGetAccessTokenNotification";

- ( void )loadView
{
  UIWebView *webView = [UIWebView new];
  webView.delegate = self;
  self.webView = webView;
  self.view = webView;
}

- ( void )viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
 
  NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", [BLCDataSource instagramClientID], [self redirectURI]];
  NSURL *url = [NSURL URLWithString:urlString];
 
  if ( url )
  {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
  }
  self.title = @"Login";
}

- ( NSString * )redirectURI
{
  return @"http://bloc.io";
}

- ( BOOL ) webView:( UIWebView * )webView shouldStartLoadWithRequest:( NSURLRequest * )request navigationType:( UIWebViewNavigationType )navigationType
{
  NSString *urlString = request.URL.absoluteString;
  if ( [urlString hasPrefix:[self redirectURI]] )
  {
    // This contains our auth token
    NSRange rangeOfAccessTokenParameter = [urlString rangeOfString:@"access_token="];
    NSUInteger indexOfTokenStarting = rangeOfAccessTokenParameter.location + rangeOfAccessTokenParameter.length;
    NSString *accessToken = [urlString substringFromIndex:indexOfTokenStarting];
    [[NSNotificationCenter defaultCenter] postNotificationName:BLCLoginViewControllerDidGetAccessTokenNotification object:accessToken];
    return NO;
  }
  return YES;
 }

- ( void ) dealloc
{
  // Removing this line causes a weird flickering effect when you relaunch the app after logging in, as the web view is briefly displayed, automatically authenticates with cookies, returns the access token, and dismisses the login view, sometimes in less than a second.
  [self clearInstagramCookies];
  self.webView.delegate = nil;
}

- ( void ) clearInstagramCookies
{
  for( NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] )
  {
    NSRange domainRange = [cookie.domain rangeOfString:@"instagram.com"];
    if( domainRange.location != NSNotFound )
    {
      [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
  }
}

@end
