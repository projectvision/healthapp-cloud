//
//  Utility.h
//  Yabbit
//
//  Created by Apple on 11/03/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (instancetype)sharedInstance ;

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress ;
+ (BOOL)isValidPassword:(NSString *)password;
+ (BOOL)isValidName:(NSString *)name;

@end