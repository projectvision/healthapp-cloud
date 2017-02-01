//
//  Common.h
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#ifndef Health_Common_h
#define Health_Common_h

#define PARSE_API_KEY                           @"vNmHb7Gvkgji498TMTEARjDB2oRJhgDZb04I3hNW"
#define PARSE_CLIENT_KEY                        @"Y8KywE5OXxrRUVTk9I5LS22f4HES3iwERQMjbCBi"

#define kNotificationRefreshChallenge           @"kNotificationRefreshChallenge"
#define kNotificationRefreshTodayChallenge      @"kNotificationRefreshTodayChallenge"
#define kNotificationRefreshCompletedChallenge  @"kNotificationRefreshCompletedChallenge"
#define kNotificationRefreshSelectedRewardList  @"kNotificationRefreshSelectedRewardList"

//DEVELOPMENT
//#define kBaseURL                                @"https://app-2736.on-aptible.com/mainlayer"

//PRODUCTION
#define kBaseURL                                @"https://app.yabbit.io/mainlayer"

#define DB_PATH_FREE                            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Health.sqlite"]
#define DP_PATH_IN_BUNDLE_FREE                  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Health.sqlite"]

#define Sql_Create_Challenge                    @"CREATE TABLE IF NOT EXISTS tbl_challenges ( id INTEGER PRIMARY KEY, challengeId INTEGER, issueId INTEGER, focusId INTEGER, level INTEGER, challenge TEXT, points INTEGER, completed INTEGER, timestamp DOUBLE);"

#define Sql_Insert_Challenge                    @"INSERT INTO tbl_challenges (challengeId, issueId, focusId, level, challenge, points, timestamp ) VALUES ( %d, %d, %d, %d, '%@', %d, %f)"

#define Sql_Update_Challenge                    @"UPDATE tbl_challenges set challengeId = %d, issueId = %d, focusId = %d, level = %d, challenge = '%@', points = %d, completed = %d, timestamp = %f where id = %d"

#endif
