//
//  SessionManager.m
//  Yabbit
//
//  Created by Apple on 06/04/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import "SessionManager.h"
#import "Common.h"

@implementation SessionManager

- (id)init {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    self = [super initWithBaseURL:baseURL sessionConfiguration:sessionConfiguration];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];
    [self setSecurityPolicy:policy];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    if(!self)
        return nil;
    else
    return self;
}

+ (id)sharedManager {
    static SessionManager *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}
- (BOOL)connected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end