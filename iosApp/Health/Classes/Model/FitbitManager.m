//
//  FitbitManager.m
//  Health
//
//  Created by Alex Volchek on 3/24/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "FitbitManager.h"
#include "hmac.h"
#include "Base64Transcoder.h"
#import <AFNetworking/AFNetworking.h>


#define OAUTH_KEY           @"X0EEQSf4tn-VkmATNEu8LaxvEqA"
#define CONSUMER_KEY        @"3beb033bbff6465c890585faab187acd"
#define CONSUMER_SECRET     @"637d5f8e4e85425682cc7f04954b96fe"
#define API_URL             @"https://api.fitbit.com"


static NSString * const kLastSendingDate = @"lastSendingDate";
static NSString * const kFitbitProvider = @"fitbit";


static NSString * CHPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kCHCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kCHCharactersToLeaveUnescaped = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kCHCharactersToLeaveUnescaped, (__bridge CFStringRef)kCHCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}



@implementation NSString (URLEncoding)

- (NSString *)utf8AndURLEncode
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

@end



@interface CHQueryStringPair : NSObject

@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end



@implementation CHQueryStringPair

@synthesize field = _field;
@synthesize value = _value;

- (id)initWithField:(id)field value:(id)value
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding
{
    if (!self.value || [self.value isEqual:[NSNull null]])
    {
        return CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding);
    }
    else
    {
        return [NSString stringWithFormat:@"%@=%@", CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding),
                                                    CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.value description], stringEncoding)];
    }
}

@end



@implementation FitbitManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static FitbitManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[FitbitManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _oauthioModal = [[OAuthIOModal alloc] initWithKey:OAUTH_KEY delegate:self];
        _operationQueue = [[NSOperationQueue alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _lastSendingDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSendingDate];
    }
    return self;
}



#pragma mark
#pragma mark fitbit

-(void)showLoginModal
{
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:@"true" forKey:@"cache"];
    [_oauthioModal showWithProvider:kFitbitProvider options:options];
}

-(void)logoutWithCompletion:(void(^)(BOOL succeeded, NSError *error))completion
{
    [_oauthioModal clearCacheForProvider:kFitbitProvider];
//    _fitbitData = nil;
    
    if ([PFUser currentUser])
    {
        PFQuery *query = [PFQuery queryWithClassName:@"OAuthFitbit"];
        [query whereKey:@"oauth_type" equalTo:@"fitbit"];
        [query whereKey:@"user_owner" equalTo:[PFUser currentUser]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            if (object)
            {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                {
                    if (completion)
                    {
                        if (succeeded)
                        {
                            completion(YES, nil);
                        }
                        else if (error)
                        {
                            completion(NO, error);
                        }
                    }
                }];
            }
        }];
    }
}

-(void)isLoggedInWithCompletion:(void(^)(BOOL isLoggedIn))completion
{
    if ([PFUser currentUser])
    {
        PFQuery *query = [PFQuery queryWithClassName:@"OAuthFitbit"];
        [query whereKey:@"oauth_type" equalTo:@"fitbit"];
        [query whereKey:@"user_owner" equalTo:[PFUser currentUser]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            object ? completion(YES) : completion(NO);
        }];
    }
}

-(void)sendFitbitOAuth
{
    [self isLoggedInWithCompletion:^(BOOL isLoggedIn)
    {
        if (isLoggedIn)
        {
            [self showLoginModal];
        }
    }];
}


-(void)fetchFitbitDataWithCompletion:(void (^)(id result, NSError *error))completion
{
//    if(_fitbitData && completion)
//    {
//        completion(_fitbitData, nil);
//    }
//    else
//    {
        [self isLoggedInWithCompletion:^(BOOL isLoggedIn)
        {
            if (isLoggedIn)
            {
//                __weak typeof(self) weakSelf = self;
                [PFCloud callFunctionInBackground:@"getFitbitData"
                                    withParameters:@{}
                                             block:^(id result, NSError *error)
                {
                    if (result)
                    {
//                        __strong typeof(weakSelf) self = weakSelf;
//                        self->_fitbitData = result;
                        
                        if (completion)
                        {
                            completion(result, nil);
                        }
                    }
                    else
                    {
                        [_oauthioModal clearCacheForProvider:kFitbitProvider];
//                        _fitbitData = nil;
                        
                        NSLog(@"%@",error);
                        if (completion)
                        {
                            error ? completion(nil, error) : completion(nil, nil);
                        }
                    }
                }];
            }
            else
            {
                if (completion)
                {
                    completion(nil, nil);
                }
            }
        }];
//    }
}


//-(void)sendFitbitForDate:(NSDate*)date
//{
//    PFObject *activitiesImport = [PFObject objectWithClassName:@"ActivitiesImport"];
//    activitiesImport[@"user"] = [PFUser currentUser];
//    
//    [self activitiesForDate:date withCompletion:^(NSDictionary *activities)
//     {
//         activitiesImport[@"Calories"] = activities[@"Calories"];
//         activitiesImport[@"Steps"] = activities[@"Steps"];
//         
//         [self heartRateForDate:date withCompletion:^(NSDictionary *heartRate)
//          {
//              activitiesImport[@"ExertiveHR"] = heartRate[@"Exertive"];
//              activitiesImport[@"NormalHR"] = heartRate[@"Normal"];
//              activitiesImport[@"RestingHR"] = heartRate[@"Resting"];
//              
//              [self sleepForDate:date withCompletion:^(NSDictionary *sleep)
//               {
//                   activitiesImport[@"TotalSleepMinutes"] = sleep[@"totalMinutesAsleep"];
//                   activitiesImport[@"TotalSleepRecords"] = sleep[@"totalSleepRecords"];
//                   activitiesImport[@"TotalTimeInBed"] = sleep[@"totalTimeInBed"];
//                   
//                   activitiesImport[@"Date"] = date;
//                   
//                   [activitiesImport saveEventually];
//               }];
//          }];
//     }];
//}



#pragma mark
#pragma mark utilities

-(NSString*)stringFromDate:(NSDate*)date
{
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [_dateFormatter stringFromDate:date];
    return dateString;
}

-(BOOL)isTodayDate:(NSDate*)date
{
    BOOL result = NO;
    
    if (date)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *today = [cal dateFromComponents:components];
        components = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
        NSDate *otherDate = [cal dateFromComponents:components];
        
        result = [today isEqualToDate:otherDate];
    }
    else
    {
        result = NO;
    }
    
    return result;
}



#pragma mark
#pragma mark obtaining fitbit resources

//-(void)heartRateForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *json))completion
//{
//    NSString *dateString = [self stringFromDate:date];
//    
//    NSString *path = [NSString stringWithFormat:@"/1/user/-/heart/date/%@.json", dateString];
//
//    [self sendRequestWithPath:path method:@"GET" withCompletion:^(NSDictionary *json)
//    {
//        //create dict for parse
//        NSMutableDictionary *result = [NSMutableDictionary dictionary];
//        NSArray *array = json[@"average"];
//        
//        for (NSDictionary *dict in array)
//        {
//            if ([dict[@"tracker"] isEqualToString:@"Resting Heart Rate"])
//            {
//                [result setObject:dict[@"heartRate"] forKey:@"Resting"];
//            }
//            else if ([dict[@"tracker"] isEqualToString:@"Normal Heart Rate"])
//            {
//                [result setObject:dict[@"heartRate"] forKey:@"Normal"];
//            }
//            else if ([dict[@"tracker"] isEqualToString:@"Exertive Heart Rate"])
//            {
//                [result setObject:dict[@"heartRate"] forKey:@"Exertive"];
//            }
//        }
//
//        completion(result);
//    }];
//}

//-(void)activitiesForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *json))completion
//{
//    NSString *dateString = [self stringFromDate:date];
//    
//    NSString *path = [NSString stringWithFormat:@"/1/user/-/activities/date/%@.json", dateString];
//
//    [self sendRequestWithPath:path method:@"GET" withCompletion:^(NSDictionary *json)
//    {
//        NSDictionary *dict = json[@"summary"];
//        NSDictionary *result = @{@"Calories":dict[@"caloriesOut"], @"Steps":dict[@"steps"]};
//        completion(result);
//    }];
//}

//-(void)sleepForDate:(NSDate*)date withCompletion:(void (^)(NSDictionary *json))completion
//{
//    NSString *dateString = [self stringFromDate:date];
//    
//    NSString *path = [NSString stringWithFormat:@"/1/user/-/sleep/date/%@.json", dateString];
//
//    [self sendRequestWithPath:path method:@"GET" withCompletion:^(NSDictionary *json)
//    {
//        completion(json[@"summary"]);
//    }];
//}

//-(void)profileInfoWithCompletion:(void (^)(NSDictionary *json))completion
//{
//    NSString *path = @"/1/user/-/profile.json";
//    
//    [self sendRequestWithPath:path method:@"GET" withCompletion:^(NSDictionary *json)
//    {
//        completion(json);
//    }];
//}



#pragma mark
#pragma mark prepare request

//-(void)sendRequestWithPath:(NSString*)path method:(NSString*)method withCompletion:(void (^)(NSDictionary *json))completion
//{
//    NSURLRequest *preparedRequest = [[self class] preparedRequestForPath:path
//                                                               HTTPmethod:method
//                                                               oauthToken:_credentials[@"oauth_token"]
//                                                              oauthSecret:_credentials[@"oauth_token_secret"]];
//    
//    [NSURLConnection sendAsynchronousRequest:preparedRequest
//                                       queue:_operationQueue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//     {
//         NSError* errorJson;
//         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
//                                                              options:kNilOptions
//                                                                error:&errorJson];
//         completion(json);
//     }];
//}

//+ (NSURLRequest *)preparedRequestForPath:(NSString *)path
//                              HTTPmethod:(NSString *)HTTPmethod
//                              oauthToken:(NSString *)oauth_token
//                             oauthSecret:(NSString *)oauth_token_secret
//{
//    if (!HTTPmethod || !oauth_token) return nil;
//    
//    NSMutableDictionary *allParameters = [self standardOauthParameters];
//    allParameters[@"oauth_token"] = oauth_token;
//    
//    NSString *parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
//    
//    NSString *request_url = API_URL;
//    if (path) request_url = [request_url stringByAppendingString:path];
//    
//    NSString *oauth_consumer_secret = CONSUMER_SECRET;
//    NSString *baseString = [HTTPmethod stringByAppendingFormat:@"&%@&%@", request_url.utf8AndURLEncode, parametersString.utf8AndURLEncode];
//    NSString *secretString = [oauth_consumer_secret.utf8AndURLEncode stringByAppendingFormat:@"&%@", oauth_token_secret.utf8AndURLEncode];
//    NSString *oauth_signature = [self.class signClearText:baseString withSecret:secretString];
//    allParameters[@"oauth_signature"] = oauth_signature;
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_url]];
//    request.HTTPMethod = HTTPmethod;
//    
//    NSMutableArray *parameterPairs = [NSMutableArray array];
//    
//    for (NSString *name in allParameters)
//    {
//        NSString *aPair = [name stringByAppendingFormat:@"=\"%@\"", [allParameters[name] utf8AndURLEncode]];
//        [parameterPairs addObject:aPair];
//    }
//    
//    NSString *oAuthHeader = [@"OAuth " stringByAppendingFormat:@"%@", [parameterPairs componentsJoinedByString:@", "]];
//    
//    [request setValue:oAuthHeader forHTTPHeaderField:@"Authorization"];
//    
//    return request;
//}



#pragma mark
#pragma mark oauth

//+ (NSString *)getNonceWithLength: (int) len
//{
//    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//
//    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
//    
//    for (int i = 0; i < len; i++)
//    {
//        [randomString appendFormat: @"%C", [letters characterAtIndex: (arc4random_uniform((int)letters.length))]];
//    }
//        
//    return randomString;
//}

//+ (NSMutableDictionary *)standardOauthParameters
//{
//    NSString *oauth_timestamp = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate.date timeIntervalSince1970]];
//    NSString *oauth_nonce = [[self class] getNonceWithLength:10];
//    NSString *oauth_consumer_key = CONSUMER_KEY;
//    NSString *oauth_signature_method = @"HMAC-SHA1";
//    NSString *oauth_version = @"1.0";
//    
//    NSMutableDictionary *standardParameters = [NSMutableDictionary dictionary];
//    [standardParameters setValue:oauth_consumer_key     forKey:@"oauth_consumer_key"];
//    [standardParameters setValue:oauth_nonce            forKey:@"oauth_nonce"];
//    [standardParameters setValue:oauth_signature_method forKey:@"oauth_signature_method"];
//    [standardParameters setValue:oauth_timestamp        forKey:@"oauth_timestamp"];
//    [standardParameters setValue:oauth_version          forKey:@"oauth_version"];
//    
//    return standardParameters;
//}

//NSString * CHQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding)
//{
//    NSMutableArray *mutablePairs = [NSMutableArray array];
//    for (CHQueryStringPair *pair in CHQueryStringPairsFromDictionary(parameters))
//    {
//        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
//    }
//    
//    return [mutablePairs componentsJoinedByString:@"&"];
//}

//NSArray * CHQueryStringPairsFromDictionary(NSDictionary *dictionary)
//{
//    return CHQueryStringPairsFromKeyAndValue(nil, dictionary);
//}

//NSArray * CHQueryStringPairsFromKeyAndValue(NSString *key, id value)
//{
//    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
//    
//    if([value isKindOfClass:[NSDictionary class]])
//    {
//        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
//        [[[value allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] enumerateObjectsUsingBlock:^(id nestedKey, NSUInteger idx, BOOL *stop) {
//            id nestedValue = [value objectForKey:nestedKey];
//            if (nestedValue) {
//                [mutableQueryStringComponents addObjectsFromArray:CHQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
//            }
//        }];
//    } else if([value isKindOfClass:[NSArray class]]) {
//        [value enumerateObjectsUsingBlock:^(id nestedValue, NSUInteger idx, BOOL *stop) {
//            [mutableQueryStringComponents addObjectsFromArray:CHQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
//        }];
//    } else {
//        [mutableQueryStringComponents addObject:[[CHQueryStringPair alloc] initWithField:key value:value]];
//    }
//    
//    return mutableQueryStringComponents;
//}


//+ (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret
//{
//    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[20];
//    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
//    
//    char base64Result[32];
//    size_t theResultLength = 32;
//    Base64EncodeData(result, 20, base64Result, &theResultLength);
//    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
//    
//    return [NSString.alloc initWithData:theData encoding:NSUTF8StringEncoding];
//}



#pragma mark
#pragma mark OAuth delegate

-(void)didAuthenticateServerSide:(NSString *)body andResponse:(NSURLResponse *)response
{
    NSLog(@"didAuthenticateServerSide: %@; response: %@", body, response);
}

-(void)didFailAuthenticationServerSide:(NSString *)body andResponse:(NSURLResponse *)response andError:(NSError *)error
{
    NSLog(@"didFailAuthenticationServerSide: %@; response: %@; error: %@", body, response, error);
}

-(void)didReceiveOAuthIOCode:(NSString *)code
{
    NSLog(@"didReceiveOAuthIOCode: %@;", code);
}

- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request
{
    _credentials = [request getCredentials];
    
    NSLog(@"fitbit didReceiveOAuthIOResponse: %@;", _credentials);
    
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"saveFitBitOAuthData"
                       withParameters:@{@"consumer_key":CONSUMER_KEY,
                                        @"oauth_token":_credentials[@"oauth_token"],
                                        @"oauth_secret_token":_credentials[@"oauth_token_secret"]}
                                block:^(id result, NSError *error)
     {
         if (result)
         {
             NSLog(@"saveFitBitOAuthData success");
             
             __strong typeof(weakSelf) self = weakSelf;
            [self.delegate fitbitDidSuccess];
         }
         else
         {
             if (error)
             {
                 NSLog(@"saveFitBitOAuthData failure: %@", error);
             }
         }
     }];
    
    //send info to parse
//    if (![self isTodayDate:_lastSendingDate])
//    {
//        if (_lastSendingDate)
//        {
//            NSCalendar *calendar = [NSCalendar currentCalendar];
//            NSDateComponents *subtractDay = [[NSDateComponents alloc] init];
//            [subtractDay setDay:-1];
//            NSDateComponents *oneDay = [[NSDateComponents alloc] init];
//            [oneDay setDay:1];
//            
//            int i = 0;
//            for (NSDate *date = [calendar dateByAddingComponents:subtractDay toDate:[NSDate date] options:0]; [date compare:[calendar dateByAddingComponents:oneDay toDate:_lastSendingDate options:0]] >= 0; date = [calendar dateByAddingComponents:subtractDay toDate:date options:0])
//            {
//                [self sendFitbitForDate:date];
//                if (i >= 30)
//                {
//                    break;
//                }
//                else
//                {
//                    ++i;
//                }
//            }
//        }
//        else
//        {
//            NSCalendar *calendar = [NSCalendar currentCalendar];
//            NSDateComponents *subtractDay = [[NSDateComponents alloc] init];
//            [subtractDay setDay:-1];
//            [self sendFitbitForDate:[calendar dateByAddingComponents:subtractDay toDate:[NSDate date] options:0]];
//        }
//    
//        //update last date
//        _lastSendingDate = [NSDate date];
//        [[NSUserDefaults standardUserDefaults] setObject:_lastSendingDate forKey:kLastSendingDate];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

- (void)didFailWithOAuthIOError:(NSError *)error
{
    NSLog(@"fitbit didFailWithOAuthIOError: %@;", error);
    
    [self.delegate fitbitDidFailWithError:error];
}

@end
