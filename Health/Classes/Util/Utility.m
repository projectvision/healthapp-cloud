//
//  Utility.m
//  Yabbit
//
//  Created by Apple on 11/03/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

@implementation Utility

#pragma mark - Singleton
+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    
    return [emailTest evaluateWithObject:emailAddress];
}
+ (BOOL)isValidPassword:(NSString *)password {

NSString *regex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&])(?=.*\\d).{8,16}$";

NSPredicate  *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

return [passwordTest evaluateWithObject:password];
}

+ (BOOL)isValidName:(NSString *)name {
NSString *nameRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
return [nameTest evaluateWithObject:name];
}


@end