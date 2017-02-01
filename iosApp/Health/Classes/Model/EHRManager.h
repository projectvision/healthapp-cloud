//
//  EHRManager.h
//  Health
//
//  Created by Alex Volchek on 4/17/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface EHRManager : NSObject
{

}

@property (nonatomic) BOOL connected;

+(instancetype)sharedManager;

-(void)MRNExistsWithCompletion:(void (^)(PFObject *object))completion;
-(BOOL)connectMRN:(NSDictionary *)MRN withHL7Import:(PFObject*)HL7Import;

-(void)isConnectedWithCompletion:(void (^)(BOOL isConnected))completion;

-(void)disconnect;

@end
