//
//  EHRManager.m
//  Health
//
//  Created by Alex Volchek on 4/17/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "EHRManager.h"
#import "SVProgressHUD.h"

static NSString * const kConnected = @"connected";

@implementation EHRManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static EHRManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[EHRManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)isConnectedWithCompletion:(void (^)(BOOL isVerified))completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Demographics"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
     {
         if (object)
         {
             completion([object[@"MRNMatched"] boolValue]);
         }
         else
         {
             completion(NO);
         }
     }];
}

-(void)MRNExistsWithCompletion:(void (^)(PFObject *object))completion
{
    PFQuery *demoQuery = [PFQuery queryWithClassName:@"Demographics"];
    [demoQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
    [demoQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error)
        {
            if (object)
            {
                NSString *MRN = object[@"MRN"];
                
                PFQuery *HL7Query = [PFQuery queryWithClassName:@"HL7Import"];
                
                [HL7Query whereKey:@"PID_PatientAccountNumber" equalTo:MRN];
                [HL7Query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                 {
                    if (!error)
                    {
                        if (object)
                        {
                            completion(object);
                        }
                    }
                    else
                    {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                        
                        completion(nil);
                    }
                }];
            }
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            completion(nil);
        }
    }];
}

-(BOOL)connectMRN:(NSDictionary *)MRN withHL7Import:(PFObject *)HL7Import
{
    _connected = NO;
    
    if ([HL7Import[@"PID_FirstName"] caseInsensitiveCompare:MRN[@"firstName"]] == NSOrderedSame &&
        [HL7Import[@"PID_LastName"] caseInsensitiveCompare:MRN[@"lastName"]] == NSOrderedSame &&
        [HL7Import[@"PID_AddressLine1"] caseInsensitiveCompare:MRN[@"addressLine1"]] == NSOrderedSame &&
        [HL7Import[@"PID_City"] caseInsensitiveCompare:MRN[@"city"]] == NSOrderedSame)
    {
        //if empty (assuming only addressline2 can be empty)
        if(!((NSString*)HL7Import[@"PID_AddressLine2"]).length)
        {
            if (!((NSString*)MRN[@"addressLine2"]).length)
            {
                _connected = YES;
            }
        }
        else
        {
            if ([HL7Import[@"PID_City"] caseInsensitiveCompare:MRN[@"city"]] == NSOrderedSame)
            {
                _connected = YES;
            }
        }
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Demographics"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    
    __weak typeof(self) weakSelf = self;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (object)
        {
            __strong typeof(weakSelf) self = weakSelf;
            object[@"MRNMatched"] = [NSNumber numberWithBool:self->_connected];
            [object saveInBackground];
        }
    }];
    
    return _connected;
}

-(void)disconnect
{
    _connected = NO;
}

@end
