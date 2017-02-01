//
//  SharedData.m
//  SpellingTeacher
//
//  Created by Chenggong Huang on 5/17/13.
//  Copyright (c) 2013 Chenggong Huang. All rights reserved.
//

#import <Parse/Parse.h>
#import "SharedData.h"
#import "Challenge.h"
#import "Focus.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "NSDate+MTDates.h"

#import "GPSManager.h"
#import "FitbitManager.h"
#import "EHRManager.h"
#import "SessionManager.h"


static SharedData *g_sharedInfo = nil;


@implementation SharedData

- (id) init
{
	if ( self = [super init] )
    {
        _challengeList = [[NSMutableDictionary alloc] init];
        _todayChallengeList = [[NSMutableArray alloc] init];
        _acceptedChallengeList=[[NSMutableDictionary alloc]init];
        _completedChallengeList = [[NSMutableArray alloc] init];
        _focusList = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (SharedData *) sharedData
{
    static dispatch_once_t pred;
    static SharedData *sharedData = nil;
    dispatch_once(&pred, ^{
        sharedData = [[SharedData alloc] init];
    });
    return sharedData;
}


- (void) logoutUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"assesment_status"];
    [defaults synchronize];
    
    [_challengeList removeAllObjects];
    [_todayChallengeList removeAllObjects];
    [_completedChallengeList removeAllObjects];
    
    [[GPSManager sharedManager] stopUpdatingLocation];
   // [[FitbitManager sharedManager] logoutWithCompletion:nil];
    //[[EHRManager sharedManager] disconnect];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}



-(void)loadFocus
{
   [_focusList removeAllObjects];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/allFocusGroups" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *focusArray= (NSArray*)responseObject;
        for ( NSDictionary *focusDict in focusArray)
        {
            Focus *focus = [Focus initFocusWithParseObject:focusDict];
            
            [_focusList addObject:focus];
        }
        
        _loadFocusCompleted = YES;
        
        if (_loadChallengeCompleted == YES)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshChallenge object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}



- (void) loadChallengesWithCompletion:(void (^)(NSDictionary *challenges))completion
{
    [_challengeList removeAllObjects];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [SVProgressHUD showWithStatus:@"Retrieving Challenges..." maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:@"v1/patientChallenges" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];

         NSDictionary *response= (NSDictionary*)responseObject;
        if(response.count>0)
        {
        
        NSArray *challengeArray=[response valueForKey:@"patientChallenges"];
        
        for ( NSDictionary *object in challengeArray)
        {
            Challenge *challenge = [Challenge initChallengeWithParseObject:object];
            NSString *focusId = [NSString stringWithFormat:@"%ld", (long)challenge.focusId];
            
            if (!self->_challengeList[focusId])
            {
                NSMutableArray *subChallengeList = [[NSMutableArray alloc] init];
                [subChallengeList addObject:challenge];
                
                [self->_challengeList setObject:subChallengeList forKey:focusId];
            }
            else
            {
                [self->_challengeList[focusId] addObject:challenge];
            }

        }
        
        for ( NSString *key in [self->_challengeList allKeys])
        {
            NSArray *subArray = [self->_challengeList objectForKey:key];
            
            NSArray *sortedArray = [subArray sortedArrayUsingSelector:@selector(compare:)];
            
            [self->_challengeList setObject:sortedArray forKey:key];
        }
        
            
        if (completion)
        {
            completion(self->_challengeList);
        }
        
        self->_loadChallengeCompleted = YES;
        
        if (self->_loadFocusCompleted)
        {
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshChallenge object:nil];
        }
    }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No challenges received, try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];

}


- (void) loadChallengestoday:(void (^)(NSDictionary *challenges))completion
{
    [_acceptedChallengeList removeAllObjects];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/todaysAcceptedChallenges" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
            NSArray *challengeArray=(NSArray*)responseObject;
            
            for ( NSDictionary *object in challengeArray)
            {
                Challenge *challenge = [Challenge initChallengeWithParseObject:object];
                NSString *focusId = [NSString stringWithFormat:@"%ld", (long)challenge.focusId];
                
                if (!self->_acceptedChallengeList[focusId])
                {
                    NSMutableArray *subChallengeList = [[NSMutableArray alloc] init];
                    [subChallengeList addObject:challenge];
                    
                    [self->_acceptedChallengeList setObject:subChallengeList forKey:focusId];
                }
                else
                {
                    [self->_acceptedChallengeList[focusId] addObject:challenge];
                }
                
            }
            
            for ( NSString *key in [self->_acceptedChallengeList allKeys])
            {
                NSArray *subArray = [self->_acceptedChallengeList objectForKey:key];
                
                NSArray *sortedArray = [subArray sortedArrayUsingSelector:@selector(compare:)];
                
                [self->_acceptedChallengeList setObject:sortedArray forKey:key];
            }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


- (void) loadTodayChallenges : (BOOL) showLoading
{
    if ( showLoading == YES )
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    }
    [_acceptedChallengeList removeAllObjects];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/todaysAcceptedChallenges" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self->_todayChallengeList removeAllObjects];

        NSArray *challengeArray=(NSArray*)responseObject;
        
        
        for ( NSDictionary *object in challengeArray)
        {
            Challenge *challenge = [Challenge initChallengeWithTodayChallengeObject:object];
            
            [self->_todayChallengeList addObject:challenge];
            
        }
        NSArray *sortedArray = [self->_todayChallengeList sortedArrayUsingSelector:@selector(compareByFocus:)];
        
        [self->_todayChallengeList removeAllObjects];
        [self->_todayChallengeList addObjectsFromArray:sortedArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshTodayChallenge object:nil];
        
        [SVProgressHUD dismiss];
               
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}


- (void)loadCompletedChallengeList
{
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/getAllCompletedChallenges" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *challengeArray=(NSArray*)responseObject;
        NSDate *now = [NSDate date];
        [self->_completedChallengeList removeAllObjects];

        for ( NSDictionary *object in challengeArray)
        {
            Challenge *challenge = [Challenge initChallengeWithTodayChallengeObject:object];
           // Challenge *challenge = [Challenge initChallengeWithParseObject:object];

            NSString *focusId = [NSString stringWithFormat:@"%ld", (long)challenge.focusId];
            [self->_completedChallengeList addObject:challenge];
            
        }
        
        [self checkLevelUpAndUpdate:self->_completedChallengeList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshCompletedChallenge object:nil];
        
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void) checkLevelUpAndUpdate : (NSArray *) challenges
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSInteger challengeLevel = 0;
    
    for (Challenge *challenge in challenges)
    {
        if (challengeLevel < challenge.level)
        {
            challengeLevel = challenge.level;
        }
    }
    
    NSInteger completedCount = 0;
    
    for ( Challenge *challenge in challenges )
    {
        if ( challenge.level != challengeLevel )
        {
            continue;
        }
        
        NSString *key = [NSString stringWithFormat:@"%ld", (long)challenge.focusId];
        
        if ( [dic valueForKey:key] == nil ) {
            
            completedCount ++;
            
            [dic setObject:[NSNumber numberWithInteger:completedCount] forKey:key];
            
        } else {
            
            completedCount = [[dic objectForKey:key] integerValue];
            
            completedCount ++;
            
            [dic setObject:[NSNumber numberWithInteger:completedCount] forKey:key];
        }
    }
    
    SharedData *sharedData = [SharedData sharedData];
    
    BOOL levelUp = YES;
    
    for ( int i = 0; i < [sharedData.focusList count]; i ++ ) {
        
        Focus *focus = [sharedData.focusList objectAtIndex:i];
        
        NSInteger count = [[dic objectForKey:[NSString stringWithFormat:@"%ld", (long)focus.focusId]] integerValue];
        
        if ( count < 2 ) {
            levelUp = NO;
            break;
        }
    }
    
    if ( levelUp == YES && challengeLevel < 3 ) {
        
        PFUser *currentUser = [PFUser currentUser];
        currentUser[@"level"] = [NSNumber numberWithInteger:challengeLevel + 1];
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           
            if ( succeeded == YES ) {
                
            }
            
        }];
    }
}


- (BOOL) areTodayChallengesValid
{
    BOOL valid = NO;
    
    for ( Challenge *challenge in _todayChallengeList)
    {
        valid = YES;
       /* if (challenge.expiredAt < [[NSDate date] timeIntervalSince1970])
        {
            valid = NO;
        }
        else
        {
            valid = YES;
        }*/
    }
    
    return valid;
}


- (BOOL) checkExistInTodayChallengeList : (Challenge *) challenge
{
    for ( Challenge *todayChallenge in _todayChallengeList )
    {
        if ( todayChallenge.challengeId == challenge.challengeId )
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)updateAcceptedChallengedWithExpirationTime:(NSDate *)fireDate
{
    for (Challenge *challenge in _todayChallengeList)
    {
        NSDate *previous = [NSDate dateWithTimeIntervalSince1970:challenge.expiredAt];
        NSDate *expirationDate = [NSDate dateFromYear:[previous year] month:[previous monthOfYear] day:[previous dayOfMonth] hour:[fireDate hourOfDay] minute:[fireDate minuteOfHour]];
        
        challenge.expiredAt = [expirationDate timeIntervalSince1970];
    }
}


- (NSMutableDictionary *) randomSortedChallenges
{
    PFUser *currentUser = [PFUser currentUser];
  //  NSInteger currentLevel = [currentUser[@"level"] integerValue];
    NSInteger currentLevel =1;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  
    for ( NSString *key in [_challengeList allKeys] )
    {
        NSArray *subChallengeList = [_challengeList objectForKey:key];
        subChallengeList = [self challengesForLevel:currentLevel from:subChallengeList];
        subChallengeList = [subChallengeList sortedArrayUsingSelector:@selector(compare:)];

        [dic setObject:subChallengeList forKey:key];
    }

    return dic;
}

-(NSArray*)challengesForLevel:(NSInteger)level from:(NSArray*)challenges
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Challenge *challenge in challenges)
    {
        if (challenge.level == level)
        {
            [result addObject:challenge];
        }
        
    }
    
    if (!result.count)
    {
        result = [NSMutableArray arrayWithArray:[self challengesForLevel:level - 1 from:challenges]];
    }
    
    return result;
}


- (NSArray*) acceptedChallengeList
{
    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 0; i < [self.focusList count]; i ++ )
    {
        Focus *focus = [self.focusList objectAtIndex:i];
        
        NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
        
        NSMutableArray *challengeListByFocus = [self.challengeList objectForKey:key];
        
        for ( Challenge *challenge in challengeListByFocus )
        {
            if ( [self checkExistInTodayChallengeList:challenge] )
            {
                [array addObject:challenge];
            }
        }
    }
    
    return array;
}


- (void) scheduleNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    PFUser *currentUser = [PFUser currentUser];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if ( localNotif == nil )
    {
        return;
    }
    
    NSDate *today = [NSDate date];
    NSDate *fireDate = currentUser[@"fireDate"];
    //NSDate *fireDate=today;
    NSDate *date = [NSDate dateFromYear:[[today oneDayNext] year] month:[[today oneDayNext] monthOfYear] day:[[today oneDayNext] dayOfMonth] hour:[fireDate hourOfDay] minute:[[fireDate oneMinuteNext] minuteOfHour]];
    
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"It's time to accept new challenges. The old challenges will be expired.";
    localNotif.alertAction = @"View";
    localNotif.repeatInterval = NSCalendarUnitDay;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = nil;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


@end
