//
//  HumanAPIManager.m
//  Health
//
//  Created by Alex Volchek on 5/5/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "HumanAPIManager.h"


#define CLIENT_ID @"8bd05347b07da05ffbfc878ed3ff0d445fff0343"
#define CLIENT_SECRET @"76a573a612884596519eaf6858e5e891c02fa3cd"


@implementation HumanAPIManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static HumanAPIManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[HumanAPIManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _client = [HumanAPIClient sharedHumanAPIClient];
        
        _controller = [[HumanAPIViewController alloc] initWithClientID:CLIENT_ID andClientSecret:CLIENT_SECRET];
        _controller.delegate = self;
    }
    return self;
}

- (void)connectHumanAPIFromViewController:(id<HumanAPIManagerDelegate>)vc
{
    self.delegate = vc;

    PFQuery *query = [PFQuery queryWithClassName:@"OAuthFitbit"];
    //[query whereKey:@"user_owner" equalTo:[PFUser currentUser]];
    [query whereKey:@"oauth_type" equalTo:@"humanapi"];
    
    __weak typeof(self) weakSelf = self;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        __strong typeof(self) self = weakSelf;
        [(UIViewController*)vc presentViewController:self->_controller animated:YES completion:nil];
        
        if (object && object[@"Public_Token"])
        {
            [self->_controller startConnectFlowFor:[PFUser currentUser].objectId andPublicToken:object[@"Public_Token"]];
        }
        else
        {
            [self->_controller startConnectFlowForNewUser:[PFUser currentUser].objectId];
        }
    }];
}


-(void)fetchHumanAPIDataWithCompletion:(void (^)(id result, NSError *error))completion
{
    if ([PFUser currentUser])
    {
//        if (_humanAPIData && completion)
//        {
//            completion(_humanAPIData, nil);
//        }
//        else
//        {
//            __weak typeof(self) weakSelf = self;
        
            [PFCloud callFunctionInBackground:@"getHumanApiData"
                               withParameters:@{}
                                        block:^(id result, NSError *error)
             {
                 if (result)
                 {
//                     __strong typeof(self) self = weakSelf;
//                     self->_humanAPIData = result;
                     
                     if (completion)
                     {
                        completion(result, nil);
                     }
                 }
                 else
                 {
                     if (error && completion)
                     {
                         completion(nil, error);
                     }
                 }
             }];
//        }
    }
}


- (void)onConnectSuccess:(NSString *)humanId accessToken:(NSString *)accessToken publicToken:(NSString *)publicToken
{
    NSLog(@"Connect success: humanId=%@", humanId);
    NSLog(@"..accessToken=%@", accessToken);
    NSLog(@"..publicToken=%@", publicToken);
    
    _client.accessToken = accessToken;
    
	if ([PFUser currentUser])
	{
        [PFCloud callFunctionInBackground:@"saveHumanApiOAuthData"
                           withParameters:@{@"oauth_token":accessToken, @"public_token":publicToken}
                                    block:^(id result, NSError *error)
        {
            NSLog(@"humanAPI OAuthdata saved");
        }];
	}
	
    [_delegate humanAPIDidSuccess];
}

- (void)onConnectFailure:(NSString *)error
{
    NSLog(@"Connect failure: %@", error);
    
    [_delegate humanAPIDidFailWithError:error];
}


@end
