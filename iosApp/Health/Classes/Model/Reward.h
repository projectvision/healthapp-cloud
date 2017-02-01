//
//  Reward.h
//  Health
//
//  Created by Administrator on 9/7/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reward : NSObject

@property (nonatomic, assign) NSInteger     rewardId;
@property (nonatomic, assign) NSInteger     challengeId;
@property (nonatomic, assign) NSInteger     level;
@property (nonatomic, retain) NSString      *challnege;
@property (nonatomic, assign) NSInteger     point;


@end
