//
//  Focus.m
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "Focus.h"

@implementation Focus
@synthesize focusId;
@synthesize focus;

- (id) init {
    
    if ( self = [super init] ) {
        
    }
    
    return self;
}

+ (Focus *) initFocusWithParseObject : (NSDictionary*) object
{
    Focus *focus = [[Focus alloc] init];
    
    focus.focusId = [object[@"focusId"] integerValue];
    focus.focus = object[@"focus"];
    
    return focus;
}

@end
