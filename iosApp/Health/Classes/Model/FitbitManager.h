//
//  FitbitManager.h
//  Health
//
//  Created by Alex Volchek on 3/24/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OAUthiOS/OAuthiOS.h>
#import <Parse/Parse.h>


@protocol FitbitManagerDelegate <NSObject>

-(void)fitbitDidFailWithError:(NSError*)error;
-(void)fitbitDidSuccess;

@end


@interface FitbitManager : NSObject <OAuthIODelegate>
{
    OAuthIOModal *_oauthioModal;
    NSDictionary *_credentials;
    NSOperationQueue *_operationQueue;
    NSDateFormatter* _dateFormatter;
    NSDate *_lastSendingDate;
}

@property (nonatomic) id<FitbitManagerDelegate> delegate;
//@property () PFObject *fitbitData;

+(instancetype)sharedManager;

-(void)showLoginModal;
-(void)logoutWithCompletion:(void(^)(BOOL succeeded, NSError *error))completion;
-(void)isLoggedInWithCompletion:(void(^)(BOOL isLoggedIn))completion;


//-(void)profileInfoWithCompletion:(void (^)(NSDictionary *json))completion;
//-(void)heartRateForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *heartRate))completion;
//-(void)activitiesForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *activities))completion;
//-(void)sleepForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *sleep))completion;


-(void)sendFitbitOAuth;

-(void)fetchFitbitDataWithCompletion:(void (^)(id result, NSError *error))completion;


//+ (NSURLRequest *)preparedRequestForPath:(NSString *)path
//                              HTTPmethod:(NSString *)HTTPmethod
//                              oauthToken:(NSString *)oauth_token
//                             oauthSecret:(NSString *)oauth_token_secret;

@end
