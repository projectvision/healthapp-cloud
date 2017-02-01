//
//  SplashViewController.h
//  Health
//
//  Created by Administrator on 9/9/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HealthKit;
@interface SplashViewController : UIViewController
@property (nonatomic) HKHealthStore *healthStore;
-(BOOL)checkAssessment;
@end
