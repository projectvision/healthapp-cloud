//
//  Focus.h
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Focus : NSObject

@property (nonatomic, assign) NSInteger     focusId;
@property (nonatomic, retain) NSString      *focus;

+ (Focus *) initFocusWithParseObject : (NSDictionary*) object;

@end
