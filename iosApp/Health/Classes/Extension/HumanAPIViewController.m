//
//  HumanAPIViewController.m
//  HumanAPIDemo
//
//  Created by Yuri Subach on 05/06/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import "HumanAPIViewController.h"
#import "NXOAuth2.h"
#import "AFNetworking.h"

@implementation HumanAPIViewController

/** Definitions for type tags */
typedef enum {
    wvtMain = 1,
    wvtPopup = 2
} WebViewType;

NSString *HumanAPIAuthURL  = @"https://user.humanapi.co/oauth/authorize";
NSString *HumanAPITokenURL = @"https://user.humanapi.co/oauth/token";
NSString *redirectURL = @"https://oauth/";
NSString *HumanAPIConnectTokensURL = @"https://user.humanapi.co/v1/connect/tokens";

// geometry vars
CGFloat NavbarHeight = 54;


/** Initialization of the instance */
- (id)initWithClientID:(NSString *)cliendID andClientSecret:(NSString *)clientSecret
{
    self = [super init];
    self.clientID = cliendID;
    self.clientSecret = clientSecret;
    return self;
}

/** Initialization of the UI */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    // Geometry calculations
    int ScreenWidth = (int)[[UIScreen mainScreen ]bounds].size.width;
    int ScreenHeight = (int)[[UIScreen mainScreen ]bounds].size.height;
    
    // UIWebView init
    self.webView = [[UIWebView alloc] initWithFrame:
                    CGRectMake(0, NavbarHeight, ScreenWidth, ScreenHeight - NavbarHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
    self.webView.delegate = self;
    self.webView.tag = wvtMain;
    [self.view addSubview:self.webView];

    // Popup UIWebView init
    self.popupWebView = [[UIWebView alloc] initWithFrame:
                         CGRectMake(0, NavbarHeight, ScreenWidth, ScreenHeight - NavbarHeight)];
    self.popupWebView.backgroundColor = [UIColor whiteColor];
    self.popupWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                          UIViewAutoresizingFlexibleHeight);
    self.popupWebView.delegate = self;
    self.popupWebView.hidden = YES;
    self.popupWebView.tag = wvtPopup;
    [self.view addSubview:self.popupWebView];

    
    // Navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:
                               CGRectMake(0, 0, ScreenWidth, NavbarHeight)];
    navbar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Connect Your Fitness Tracker";
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                    target:self
                                    action:@selector(onClickCancel)];
    navItem.rightBarButtonItem = doneButton;
    navbar.items = @[ navItem ];
    [self.view addSubview:navbar];
    
    // keyboard hide handler
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    self.keyboardFixer = 1.0;
}

/** Before view appears */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self closePopup];
}

/** Cancel click handler */
- (void)onClickCancel
{
    [self fireConnectFailureWithError:@"cancelled by user"];
    [self dismiss];
}

/** Disable entire UI */
- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

/** Close popup view */
- (void)closePopup
{
    self.webView.hidden = NO;
    self.popupWebView.hidden = YES;
    [self.popupWebView loadHTMLString:@"" baseURL:nil];
}

/** Keyboard hide handler */
- (void)keyboardDidHide:(NSNotification*)aNotification
{
    NSLog(@"keyboard did hide, fixing webview ...");
    // Fix for iOS7
    // TODO Make sure it's not required in iOS8 and surround w/ "if (iOS <= 7)"
    [self.webView setFrame:CGRectMake(0, NavbarHeight,
                                      self.webView.frame.size.width + self.keyboardFixer,
                                      self.webView.frame.size.height)];
    self.keyboardFixer = self.keyboardFixer * -1;
}

/** UIWebView request handler, used for catching specific URLs */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *reqStr = request.URL.absoluteString;
    NSLog(@"req = %@ : %d", reqStr, navigationType);
    if ([reqStr hasPrefix:@"https://connect-token"]) {
        [self processConnectTokenFrom:request.URL];
        return NO;
    } else if ([reqStr hasPrefix:@"https://connect-closed"]) {
        [self fireConnectFailureWithError:@"closed by user"];
        [self dismiss];
        return NO;
    }
    
    // Popup handling
    NSString *url = reqStr;
    if ([url hasPrefix:@"https://close-popup-with-message"]) {
        NSLog(@"closing popup with message ...");
        [self closePopup];
        [self postMessageFromUrl:url];
        return NO;
    } else if ([url hasPrefix:@"https://close-popup"]) {
        NSLog(@"closing popup ...");
        [self closePopup];
        return NO;
    } else if ([url rangeOfString:@"popup=1"].location != NSNotFound) {
        NSLog(@"got popup request ...");
        if (webView.tag == wvtPopup) {
            return YES; // already created
        }
        NSLog(@"opening popup window ...");
        self.webView.hidden = YES;
        self.popupWebView.hidden = NO;
        [self.popupWebView loadRequest:request];
        return NO;
    }
    return YES;
}

/** Post message from URL to main view.
    URL format: https://close-popup-with-message?[message] */
- (void)postMessageFromUrl:(NSString *)url
{
    NSArray *parts = [url componentsSeparatedByString:@"?"];
    if ([parts count] > 1) {
        NSString *message = parts[1];
        NSLog(@"parsed message = %@", message);
        NSString *js = [NSString stringWithFormat:@""
                        "window.postMessage(decodeURIComponent('%@'), '*');", message];
        __unused NSString *jsOverrides = [self.webView
                                          stringByEvaluatingJavaScriptFromString:js];
    } else {
        NSLog(@"error with message parsing!");
    }
}

/** Processing after page load */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag == wvtPopup) {
        // popup: overwrite the 'window.close' to be a 'close-popup' URL
        NSLog(@"overwriting window.close ...");
        NSString *jsClose = @""
        "window.close = function () { \n"
        "   window.location.assign('https://close-popup'); \n"
        "};";
        __unused NSString *jsOverrides = [webView
                                          stringByEvaluatingJavaScriptFromString:jsClose];
    }
}

/**
 * Connect flow entry point for new `userId`
 */
- (void)startConnectFlowForNewUser:(NSString *)userId
{
    [self startConnectFlow:[NSString stringWithFormat:
                            @"clientId:     '%@', \n"
                            " clientUserId: '%@', \n", self.clientID, userId]];
}

- (void)startConnectFlowFor:(NSString *)userId andPublicToken:(NSString *)publicToken
{
    [self startConnectFlow:[NSString stringWithFormat:
                            @"clientUserId: '%@', \n"
                            " publicToken:  '%@', \n", userId, publicToken]];
}

/** Connect flow entry point implementation */
- (void)startConnectFlow:(NSString *)params
{
    self.flowType = FlowTypeConnect;
    //NSString *baseURL = @"http://localhost:4000";
    NSString *baseURL = @"https://connect.humanapi.co";
    NSString *html = [NSString stringWithFormat:@"<html> \n"
                      "<body onload=\" \n"
                      "HumanConnect.open({ \n"
                      //"    iframe: true, \n"
                      "    language: 'en', \n"
                      "%@" // params here
                      "    _baseURL: '%@', \n"
                      "    finish: function(err, obj) { \n"
                      "        window.location = 'https://connect-token?' + \n"
                      "            'sessionToken=' + obj.sessionToken + \n"
                      "            '&humanId=' + obj.humanId; \n"
                      "    }, \n"
                      "    close: function() { \n"
                      "        window.location = 'https://connect-closed'; \n"
                      "    } \n"
                      "}); \n"
                      "\"> \n"
                      "<script src='%@/connect.js'></script> \n"
                      "</body></html>", params, baseURL, baseURL];
    [self.webView loadHTMLString:html baseURL:nil];
}

/** Process data returned from JS on connect flow */
- (void)processConnectTokenFrom:(NSURL *)url
{
    NSDictionary *params = [self parseQueryString:[url query]];
    NSString *humanId = [params objectForKey:@"humanId"];
    if (humanId == nil || [humanId length] == 0) {
        NSLog(@"ERROR: `humanId` not found in request");
        [self dismiss];
        [self fireConnectFailureWithError:@"`humanId` not found in request"];
        return;
    }
    NSString *sessionToken = [params objectForKey:@"sessionToken"];
    if (sessionToken == nil || [sessionToken length] == 0) {
        NSLog(@"ERROR: `sessionToken` not found in request");
        [self dismiss];
        [self fireConnectFailureWithError:@"`sessionToken` not found in request"];
        return;
    }
    NSLog(@"found humanId=%@, sessionToken=%@", humanId, sessionToken);
    

    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager a];
    NSDictionary *postData = @{@"clientId": self.clientID,
                               @"clientSecret": self.clientSecret,
                               @"humanId": humanId,
                               @"sessionToken": sessionToken};
    [manager POST:HumanAPIConnectTokensURL parameters:postData
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"JSON: %@", responseObject);
              NSDictionary *res = (NSDictionary *)responseObject;
              NSLog(@"accessToken = %@", res[@"accessToken"]);
              [self dismiss];
              [self fireConnectSuccessWithData:res];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self dismiss];
              [self fireConnectFailureWithError:@"error while requesting connect `accessToken`"];
          }];*/
}

/** Calls connect success method in delegate */
- (void)fireConnectSuccessWithData:(NSDictionary *)data
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onConnectSuccess:accessToken:publicToken:)]) {
        [delegate onConnectSuccess:data[@"humanId"] accessToken:data[@"accessToken"]
                       publicToken:data[@"publicToken"]];
    }
}

/** Calls connect failure method in delegate */
- (void)fireConnectFailureWithError:(NSString *)error
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onConnectFailure:)]) {
        [delegate onConnectFailure:error];
    }
}

/** Extract parameters from the `query` string */
- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
	//	Only allow rotation to portrait
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	//	Force to portrait
	return UIInterfaceOrientationPortrait;
}

@end
