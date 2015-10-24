## Setup & Install

To setup test environment run

```
npm install
```

## Deploy

Install parse commandline

```
curl -s https://www.parse.com/downloads/cloud_code/installer.sh | sudo /bin/bash
```

To deploy code to parse.com run

```
parse deploy
```

## Styleguide

- Commit: https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-guidelines
- CodeStyle: https://github.com/rwaldron/idiomatic.js


# Folder structure

TBD

# Testing

TBD

# High-level design

put link here

# Data structure

## Entities

### Points

By completing challenge user receive certain amount of points.

We do point calculation, but do not really use it anywhere.

### Levels

By completing 2 challenges in a row of the same FocusGroup and level user receives level up.

We do level calculation, but do not really use it.

### Challenge

User is provided with a challenges on a daily basis using ChallengeAlgorithm.  

Challenge has following most important attributes:

- Challenge text
- Focus group
- Challenge group
- Level 
- Points


### Challenge Group

Challenges are grouped into several groups. Each group belong to specific focus group.


### Focus Group

There are 3 major focus groups:

- Fitness
- Diet 
- Stress



## Data Tables

### User


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
 username                            |  S   | User's login                                
 password                            |  S   | Password                                    
 authData                            |  S   | Not used                                    
 emailVerified                       |  S   | Not used                                    
 assessment                          |  B   | Holds true if user has completed assessment 
 earnedPoint                         |  N   | Amount of points earned by this user        
 email                               |  S   |             
 Final_Date                          |  D   |             
 level                               |  N   | User's level            
 ABSI_zscore                         |  N   | ABSI Z-Score. Filled by value from ChallengeAlgorithm            
 Waist_Circumference_Ideal           |  N   | Ideal WC. Filled by value from ChallengeAlgorithm            
 Focus1_GroupID                      |  R   | Fitness group            
 Focus2_GroupID                      |  R   | Diet group            
 Focus3_GroupID                      |  R   | Mind group            


### ActivitiesImport


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
 Calories                            |  N   | Number of calories user spent                                
 Date                                |  D   | Activity date                                    
 user                                |  P   | Pointer to user                                    
 ExertiveHR                          |  N   |                                     
 NormalHR                            |  N   |  
 RestingHR                           |  N   |         
 Steps                               |  N   |             
 TotalSleepMinutese                  |  N   |             
 TotalSleepRecords                   |  N   |             
 TotalTimeInBed                      |  N   |             
 source                              |  S   | Might be 'fitbit', 'humanapi' or other            


### ChallengeGroup


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
 GroupID                             |  N   |                   
 GroupName                           |  S   |                  
 FocusID                             |  P   | Pointer to Focus


### Challenges


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
challenge                            |  S   | Description
challengeId                          |  N   | Unique challenge identificator
focusId                              |  N   | Reference to Focus
level                                |  N   | 
points                               |  N   | Challenge completion award in points user gained
GroupID                              |  P   | Pointer to ChallengeGroup

### Demographics

Filled during assessment.

ETHNCITY:

1. Asian/Pacific Islander
2. Black
3. White
4. Hispanic(white)
5. Hispanic(non-white)
6. Not disclosing

GENDER:

1. male
2. female
3. other


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
COMPLETIONRATE                       |  S   | Each filled record increase rate by 10%  
DOB                                  |  S   | Date of Birth
ETHNCITY                             |  N   | Values 1, 2, 3, 4, 5, 6 or undefined
GENDER                               |  N   | Values 1, 2, 3 or undefined
HEIGHT                               |  S   | Height
MRN                                  |  S   | Medical Record Number
SOMATOTYPE                           |  N   | Values 1, 2, 3 or undefined
UserId                               |  P   | Pointer to user
WEIGHT                               |  S   | Weight
username                             |  S   | Username
Waist_Circumference                  |  S   | Inches
Name                                 |  S   | First name
Surname                              |  S   | Last name
MRNMatched                           |  B   | 


### Diet

Filled during assessment.

Combo:

1. Usually/Often (3 points)
2. Sometimes (2 points)
3. Rarely/Never (1 point)
4. empty (0 points)


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
ACTIVITY_LEVEL                       |  N   | Value from ACTIVITY_LEVEL field of the Lifestyle table for current user by username if existed or zero.
CALCIUM                              |  N   | combo6 points
COMPLETIONRATE                       |  S   | Each filled combo field increase rate by 7%. If rate equal to 91 completion rate set to 100%.
FRUITS_VEG                           |  N   | Sum of combo4 and combo5 points
GRAIN                                |  N   | combo3 points
HABITS                               |  N   | Sum of combo1 and combo2 points
MEATS                                |  N   | Sum of combo7 and combo8 points
SAT_FAT                              |  N   | Saturated fat. Sum of combo9, combo10 and combo11 points
SUGAR                                |  N   | Sum of combo12 and combo13
UserID                               |  P   | Pointer to user
combo1                               |  S   |
combo2                               |  S   |
combo3                               |  S   |
combo4                               |  S   |
combo5                               |  S   |
combo6                               |  S   |
combo7                               |  S   |
combo8                               |  S   |
combo9                               |  S   |
combo10                              |  S   |
combo11                              |  S   |
combo12                              |  S   |
combo13                              |  S   |
username                             |  S   | 

### Focus


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
focus                                |  S   |
focusId                              |  S   |


### GPSData


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
Location                             |  GP  | Geo point
Timestamp                            |  D   | Geo point timestamp
User                                 |  P   | Pointer to user


### Health_Beliefs

Filled during assessment.

Combo:

1. Strongly Disagree (1 point)
2. Disagree (2 points)
3. Neutral (3 points)
4. Agree (4 points)
5. Strongly Agree (5 points)


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
COMPLETIONRATE                       |  S   | Each filled combo increase rate by 25% 
HEALTH_BELIEFS                       |  N   | Sum of all combos points
UserID                               |  P   | Pointer to user
combo1                               |  S   |
combo2                               |  S   |
combo3                               |  S   |
combo4                               |  S   |
username                             |  S   | User`s name


### HL7Import

 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
Date_Joined                          |  S   |
Date_of_Birth                        |  S   | 
EMR_Connection                       |  S   | 
Ethnicity                            |  S   |
Fname                                |  S   | First name
Gender                               |  S   | M for male or F for female
ID                                   |  S   | 
Lname                                |  S   | Last name
MRN                                  |  S   | The medical record number
MRN_Ethnicity                        |  S   | The patient ethncity from MRN
MSH_Component                        |  S   | 
MSH_DateandTimeofMessage             |  S   |
MSH_Escape                           |  S   |
MSH_FieldSeparator                   |  S   |
MSH_HL7Version                       |  S   |
MSH_MessageControlIdentifier         |  S   |
MSH_MessageType                      |  S   |
MSH_ProcessingIdentifier             |  S   |
MSH_ProcessingMode                   |  S   |
MSH_ReceivingApplication             |  S   |
MSH_ReceivingFacility                |  S   |
MSH_Repeat                           |  S   |
MSH_Security                         |  S   |
MSH_SendingApplicationName           |  S   |
MSH_Separator                        |  S   |
MSH_SequenceNumber                   |  S   |
MSH_Subcomponent                     |  S   |
OBR_FillerField1                     |  S   |
OBR_PlacerField1                     |  S   |
OBR_PlacerField2                     |  S   |
OBR_PlacerOrderNumber                |  S   |
OBR_ProcedureCode                    |  S   |
OBR_UniversalServiceID               |  S   |
OBX1                                 |  O   |
OBX2                                 |  O   |
OBX_Abnormal_Flags                   |  S   |
OBX_Nature_Of_Test                   |  S   |
OBX_Obs_Method                       |  S   |
OBX_Obs_Normal_values                |  S   |
OBX_Obs_Value                        |  S   |
OBX_Observ_Result_Status             |  S   |
OBX_Observation_Identifier           |  S   |
OBX_Probability                      |  S   |
OBX_Producers_ID                     |  S   |
OBX_Ref_Range                        |  S   |
OBX_Responsible_Obs                  |  S   |
OBX_SubID                            |  S   |
OBX_Units                            |  S   |
OBX_Value_Type                       |  S   |
OBX_date_Time_Obs                    |  S   |
OBX_setID                            |  S   |
ORC_OrderControl                     |  S   |
ORC_PlacerOrderNumber                |  S   |
PID_AddressLine1                     |  S   |
PID_AddressLine2                     |  S   |
PID_City                             |  S   |
PID_Country                          |  S   |
PID_DOB                              |  S   | 
PID_FirstName                        |  S   | Given name (first name)
PID_LastName                         |  S   | Family name (last name)
PID_MiddleInitial                    |  S   | Middle initial or name
PID_PatientAccountNumber             |  S   | 
PID_PatientID                        |  S   |
PID_PostalCode                       |  S   |
PID_Prefix                           |  S   | Mr, Mrs, Dr and etc
PVI1_AdmissionType                   |  S   |
PVI1_AttendingDoctorFirstName        |  S   |
PVI1_AttendingDoctorLastName         |  S   |
PVI1_AttendingDoctorMiddleInitial    |  S   |
PVI1_ConsultingDoctorFirstName       |  S   |
PVI1_ConsultingDoctorLastName        |  S   |
PVI1_ConsultingDoctorMiddleInitial   |  S   |
PVI1_PatientClass                    |  S   |
PVI1_PreadmitNumber                  |  S   |
PVI1_RefferingDoctorFirstName        |  S   |
PVI1_RefferingDoctorLastName         |  S   |
PVI1_RefferingDoctorMiddleInitial    |  S   |
Username                             |  S   |
data                                 |  A   |


### Lifestyle

Filled during assessment.

Combo1:

1. More than 5 (4 points)
2. between 3 and 5 (3 points)
3. beween 1 and 3 (2 points)
4. I don't exercise at all (1 point)

Combo2 and Combo3:

1. 0-2 (4 points)
2. 2-4 (3 points)
3. 4-6 (2 points)
4. more than 6 (1 point)

Combo4:

1. Never (4 points)
2. Sometimes (3 points)
3. Often (2 points)
4. Always (1 points)

Combo5:

1. YES (1 point)
2. NO (0 points)


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
ActivityLevel                        |  N   | Sum of combos points
COMPLETIONRATE                       |  S   | Each filled combo increase rate by 20% 
UserID                               |  P   | Pointer to user
combo1                               |  S   |
combo2                               |  S   |
combo3                               |  S   |
combo4                               |  S   |
combo5                               |  S   |
username                             |  S   |


### OAuthFitbit


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
Consumer_Key                         |  S   | The client key agreed upon at registration.
OAuth_Token                          |  S   | The token identifier.
OAuth_Secret_Token                   |  S   | The token shared-secret.
user_owner                           |  P   | Pointer to user
oauth_type                           |  S   | fitbit or humanapi
Public_Token                         |  S   | Token received from previous user authentication (only for existing users) HumanAPI.


### Reward


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
address                              |  S   |
name                                 |  S   |
point                                |  N   |
restriction                          |  S   |


### Stress_Level

Filled during assessment.

Combo:

1. never (0 point)
2. almost never (1 point)
3. sometimes (2 points)
4. fairly often (3 points)
5. very often (4 points)


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
COMPLETIONRATE                       |  S   | Calculates during test. Each filled combo increase rate by 10%. Max value is 100.
STRESS_LEVEL                         |  N   | Sum of the filled combos points.
UserID                               |  P   | Pointer to user
combo1                               |  S   | 
combo2                               |  S   |
combo3                               |  S   |
combo4                               |  S   |
combo5                               |  S   |
combo6                               |  S   |
combo7                               |  S   |
combo8                               |  S   |
combo9                               |  S   |
combo10                              |  S   |
username                             |  S   |


### TokenRequest

Not used.

 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------


### TokenStorage

Not used.

 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
accessToken                          |  S   |
githubId                             |  N   |
githubLogin                          |  S   |
user                                 |  P   | Pointer to user


### UserChallenges

Table contains records of challenges accepted by users. 


 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
challengeId                          |  N   | Unique identifier of challenge in Challenge table
completed                            |  N   | Completion idicator. 1 is completed or undefined.
expired                              |  N   | Expiration idicator
completedAt                          |  D   | Completion date
acceptedAt                           |  D   | Acception date
expiredAt                            |  D   | Expiration date
user                                 |  P   | Pointer to user
userId                               |  S   | Unique user identifier


### UserRewards
Not used.

 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
rewardId                             |  S   |
userId                               |  S   |


### UserTable



 Name                                | Type | Description                                 
-------------------------------------|:----:|-----------------------------------------------
DailyHR                              |  N   | Average daily heart rate for current two weeks
DailyHRLast                          |  N   | Average daily heart rate for previous two weeks
DailyKcalBurn                        |  N   | Average daily calories burn rate for current two weeks
DailyKcalBurnLast                    |  N   | Average daily calories burn rate for previous two weeks
DailySleep                           |  N   | Average sleeping time in minutes for current two weeks
DailySleepLast                       |  N   | Average sleeping time in minutes for previous two weeks
DailySteps                           |  N   | Average daily steps made for current two weeks
DailyStepsLast                       |  N   | Average daily steps made for previous two weeks
Date_Joined                          |  S   | 
Date_of_Birth                        |  S   | 
DemoID                               |  P   | Pointer to Demographics
EMR_Connection                       |  B   | Electronic medical record connectivity
Fname                                |  S   | First name
Lname                                |  S   | Last name
MRN                                  |  N   | The medical record number is organization specific. The number is used by the hospital as a systematic documentation of a patient´s medical history and care during each hospital stay.
ORM                                  |  P   | Pointer to HL7Import
PercentDietChallenges                |  N   | Percent of completed diet challenges for current two weeks
PercentDietChallengesLast            |  N   | Percent of completed diet challenges for previous two weeks
PercentFitnessChallenges             |  N   | Percent of completed fitness challenges for current two weeks
PercentFitnessChallengesLast         |  N   | Percent of completed fitness challenges for previous two weeks
PercentMaxPoints                     |  N   | 
PercentMaxPointsLast                 |  N   |
PercentStressChallenges              |  N   | Percent of completed stress challenges for current two weeks
PercentStressChallengesLast          |  N   | Percent of completed stress challenges for previous two weeks
username                             |  P   | Pointer to User
processed                            |  B   |
sent                                 |  B   |


# Cloud hosting

Base url:  http://myhealth.parseapp.com

# Cloud points

**fetchDataFromAlgorithm**
>**Discussion**
> 
>If assessment for current user is complete, then it sends required data to weight loss algorithm.
>
>**Return**
>
> HTTP status code and message.

**getChallenges** 
>**Discussion**
>
>Fetch challenges for current user grouped by focus groups
>
>**Return**
>
>Dictionary with all challenges for each focus group for current user. Groups are fitness, diet and mind.

**completeChallenge**
>**Discussion**
>
>Complete challenge for current user.
>
>**Input**
>
>challengeId -- unique challenge id.
>
>**Return**
>
>Result completion rate on success and error object on fail.

**saveFitBitOAuthData**
>**Discussion**
>
>Save auth fitbit data for user to OAuthFitbit table.
>
>**Input**
>
>consumer_key
>
>oauth_token
>
>oauth\_secret\_token
>
>user -- parse user
>
>**Return**
>
>Result string on success or error object on fail.

**getFitbitData**
>**Discussion**
>
>Get previous day fitbit information for current user from parse.com. Fetch fitbit data from fitbit.com if does not exist in parse.com.
>
>**Input**
>
>Parse user.
>
>**Return**
>
>Fitbit data.

**getHumanApiData**
>**Discussion**
>
>Export user`s data from humanapi server into ActivitiesImport table. Requere to authentificate an user in humanapi service before export. Search user`s auth data in OAuthFitbit table.
>
>**Input**
>
>User
>
>**Return**
>
> Existed ActivitiesImport record for specified user or error object.

**saveHumanApiOAuthData**
>**Discussion**
>
> Save user`s authentication data for the humanapi service. 
>
>**Input**
>
>oauth_token
>public_token
>User

# Cloud jobs

**getDataFromFitbit**
>**Discussion**
>
>Job fetch user data from fitbit.com and save it to OAuthFitbit table in parse.com

**getChallengesCompletionRateOverPeriod**
>**Discussion**
>
>Job calculates challenges completion rate for previous 2 weeks period and last 2 weeks period. Outdated.

**calculateAverageFromFitBit**
>**Discussion**
>
>Job calculates average values from Fitbit data in parse.com for all users.

**getDataFromHumanApiJob**
>**Discussion**
>
>Job exports user`s data from humanapi server into parse ActivitiesImport table for each record in OAuthFitbit table where auth type is humanapi.

# DB ToDo

## Unused tables & columns

- Reward table


## Outdated naming

- OAuthFitbit table should be renamed to AuthTokens

# DB Changelog

## 13-05-2015

- New table GPSData was created

## 31-04-2015

- New table ActivitiesImport was created

## 20-03-2015

- Added user field to UserChallenges table
- Added completedAt field to UserChallenges table
- Deprecated userId field at UserChallenges table
