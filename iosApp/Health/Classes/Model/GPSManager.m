//
//  GPSManager.m
//  Health
//
//  Created by Alex Volchek on 5/11/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "GPSManager.h"
#import <Parse/Parse.h>
#import "NSDate+MTDates.h"
#import "SessionManager.h"

@implementation GPSManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static GPSManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[GPSManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
       //locationManager.distanceFilter =10;
        
        [_locationManager setDistanceFilter:10];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       // _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates=YES;
      _locationManager.activityType = CLActivityTypeFitness;
        
        
        if ( [CLLocationManager locationServicesEnabled] )
        {
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestAlwaysAuthorization];
            }
            
        }
       // [_locationManager startUpdatingLocation];
    }
    return self;
}

-(void)startUpdatingLocation
{
    if ( [CLLocationManager locationServicesEnabled] )
    {
        [_locationManager startUpdatingLocation];
    }
}

-(void)stopUpdatingLocation
{
   [_locationManager stopUpdatingLocation];
    
}



#pragma mark
#pragma mark cllocationdelegate

-(void)distanceWithCompletion:(void(^)(NSInteger distance))completion
{
    NSDate *startOfYesterday = [[NSDate date] startOfPreviousDay];
    NSDate *endOfYesterday = [[NSDate date] endOfPreviousDay];
    
    PFQuery *query = [PFQuery queryWithClassName:@"GPSData"];
   // [query whereKey:@"User" equalTo:[PFUser currentUser]];
    [query whereKey:@"Timestamp" greaterThanOrEqualTo:startOfYesterday];
    [query whereKey:@"Timestamp" lessThanOrEqualTo:endOfYesterday];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (objects && objects.count)
         {
             //calculate distance
             //check if sort needed ??
             
             CLLocationCoordinate2D lastCoordinate = {0, 0};
             NSInteger distance = 0;
             
             for (PFObject *locationObject in objects)
             {
                 
                 PFGeoPoint *geoPoint = locationObject[@"Location"];
                 CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
                 
                 if (lastCoordinate.latitude && lastCoordinate.longitude)
                 { 
                     CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
                     CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:lastCoordinate.latitude longitude:lastCoordinate.longitude];
                     
                     CLLocationDistance meters = [newLocation distanceFromLocation:lastLocation];
                     distance = meters;
                 }
                 
                 lastCoordinate = newCoordinate;
             }
             
             if (completion)
             {
                 completion(distance);
             }
         }
         else
         {
             if (completion)
             {
                 completion(0);
             }
         }
     }];
}



#pragma mark
#pragma mark cllocationdelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", error);
}

/*-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     NSLog(@"GPSMANAGER did update location %@", locations);
    CLLocation *newLocation = locations.lastObject;
    double lat = manager.location.coordinate.latitude;
    double longi = manager.location.coordinate.longitude;
    NSTimeInterval difference=0.0;
    NSDate *currenttime =manager.location.timestamp;
    CLLocation *oldLocation;
    if (locations.count > 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"more location"
                                                            message:@"more location"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        oldLocation = locations[locations.count - 2];
        lat=oldLocation.coordinate.latitude;
        longi=oldLocation.coordinate.longitude;
        NSDate *lasttime=oldLocation.timestamp;
        
        NSString *timestamp = [NSString stringWithFormat:@"%f", [currenttime timeIntervalSince1970]];
        NSString *timestamplast = [NSString stringWithFormat:@"%f", [lasttime timeIntervalSince1970]];
        double current = [timestamp doubleValue];
        double last=[timestamplast doubleValue];
         difference = [[NSDate dateWithTimeIntervalSince1970:current] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:last]];
        
        
        NSLog(@"difference: %f", difference);
        long dur=(long)difference;
        if(difference<1200)
        {
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"difference"
                                                                    message:@"more location"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];

            return;
        }
        
        NSNumber *latitude = [[NSNumber alloc] initWithDouble:lat];
        NSNumber *longitude = [[NSNumber alloc] initWithDouble:longi];
        NSNumber *duration = [NSNumber numberWithDouble:dur];
        
        
        
        
        // Needed to filter cached and too old locations
        //NSLog(@"Location updated to = %@", newLocation);
        
        SessionManager *sessionmanager = [SessionManager sharedManager];
        
        NSDictionary *parameters = @{@"latitude":latitude ,@"longitude":longitude,@"duration":duration};
        
        [sessionmanager POST:@"v1/patientGPSData" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
        {
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    }
    

   
  

    
    }*/
-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit*)visit
{
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    NSLog(@"OldLocation: %@", oldLocation);
    [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"kUserGps"];
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        double lat =currentLocation.coordinate.latitude;
        double longi =currentLocation.coordinate.longitude;
        
        NSDictionary
        *lastLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserLastLocation"];
        if(!lastLocation)
        {

        NSNumber *newlat = [NSNumber numberWithDouble:lat];
        NSNumber *newlon = [NSNumber numberWithDouble:longi];
        
        NSDate *currenttime =currentLocation.timestamp;
        NSString *timestamp = [NSString stringWithFormat:@"%f", [currenttime timeIntervalSince1970]];
        NSDictionary *userLocation=@{@"lat":newlat,@"long":newlon,@"timestamp": timestamp};
        
        [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"kUserLastLocation"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
         NSTimeInterval difference=0.0;
   
        NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
       // if (locationAge > 5.0) return;
        /*if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 50 )
            return;*/

        if (oldLocation !=nil) {
            
                NSNumber *latitude=[lastLocation objectForKey:@"lat"];
                NSNumber *longitude=[lastLocation objectForKey:@"long"];
                NSString *timestamp=[lastLocation objectForKey:@"timestamp"];
            
            CLLocation *myLocation = [[CLLocation alloc]  initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
            
            CLLocationDistance distance = [myLocation distanceFromLocation:newLocation];
            
            if(distance < 10.0)
            {
                return;
            }
            else
            {
                
                NSString *currentTimestamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                double current = [currentTimestamp doubleValue];
                double last=[timestamp doubleValue];
                difference = [[NSDate dateWithTimeIntervalSince1970:current] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:last]];
                NSLog(@"difference: %f", difference);
                long dur=(long)difference;
                NSNumber *duration = [NSNumber numberWithDouble:dur];
                
                if(difference<1200)
                {
                    return;
                }
               

                NSNumber *newlat = [NSNumber numberWithDouble:lat];
                NSNumber *newlon = [NSNumber numberWithDouble:longi];
                
                NSDate *currenttime =currentLocation.timestamp;
                NSString *timestamp = [NSString stringWithFormat:@"%f", [currenttime timeIntervalSince1970]];
                NSDictionary *userLocation=@{@"lat":newlat,@"long":newlon,@"timestamp": timestamp};
                
                [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"kUserLastLocation"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            SessionManager *sessionmanager = [SessionManager sharedManager];
            
            NSDictionary *parameters = @{@"latitude":latitude ,@"longitude":longitude,@"duration":duration};
            
            [sessionmanager POST:@"v1/patientGPSData" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
               
                                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                

            }];
            }
        }
    }
    
}

@end
