//
//  SessionManager.h
//  Yabbit
//
//  Created by Apple on 06/04/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface SessionManager : AFHTTPSessionManager

+ (id)sharedManager;

@end