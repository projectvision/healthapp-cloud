//
//  HumanAPIManager.h
//  Health
//
//  Created by Alex Volchek on 5/5/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HumanAPIViewController.h"
#import "HumanAPIClient.h"
#import <Parse/Parse.h>


@protocol HumanAPIManagerDelegate <NSObject>

-(void)humanAPIDidFailWithError:(NSString*)error;
-(void)humanAPIDidSuccess;

@end


@interface HumanAPIManager : NSObject <HumanAPINotifications>
{
    HumanAPIClient *_client;
    HumanAPIViewController *_controller;
}

@property (nonatomic) id<HumanAPIManagerDelegate> delegate;
//@property (nonatomic) PFObject *humanAPIData;

+(instancetype)sharedManager;

-(void)connectHumanAPIFromViewController:(id<HumanAPIManagerDelegate>)vc;

-(void)fetchHumanAPIDataWithCompletion:(void (^)(id result, NSError *error))completion;

//-(void)humanWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
