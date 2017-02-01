//
//  GPSManager.h
//  Health
//
//  Created by Alex Volchek on 5/11/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol GPSManagerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end


@interface GPSManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    BOOL _deferringUpdates;
}


@property (nonatomic, weak) id<GPSManagerDelegate> delegate;


+(instancetype)sharedManager;


-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

-(void)distanceWithCompletion:(void(^)(NSInteger distance))completion;


@end
