//
//  DashboardViewController.m
//  Health
//
//  Created by Administrator on 8/29/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Parse/Parse.h>
#import "HealthAppDelegate.h"
#import "DashboardViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "ChallengeCell.h"
#import "SummaryCell.h"
#import "DailyPointsCell.h"
#import "UIViewController+MMDrawerController.h"
#import "SharedData.h"

#import "UINavigationBar+FlatUI.h"
#import "NSDate+MTDates.h"
#import "Common.h"
#import "SVProgressHUD.h"

#import "EHRManager.h"
#import "EHRViewController.h"
#import "GPSManager.h"
#import "MotionManager.h"
#import "SessionManager.h"

static CGFloat const kHeaderHeight = 30.0f;


@interface DashboardViewController () <ChallengeCellDelegate>

@property (nonatomic, nullable, strong) NSDictionary *userTable;
@property (nonatomic, nullable, strong) NSDictionary *dashboardData;
@property (nonatomic, nullable, weak) IBOutlet UITableView *dashboardTableView;

- (SummaryCell *)tableView:(UITableView *)tableView cellForChallengesCompletionRateAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)nextChallengesUpdate;
- (NSString *)last2WeeksProgress;
- (NSString *)current2WeeksProgress;
- (void)loadChallengesCompletionRates;
- (void)registerCellsForTableView;
- (NSString *)convertProgress:(NSNumber *)progress;

@end


@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];

   [self initNotification];
    [self initUI];
    
    SharedData *sharedData = [SharedData sharedData];
    
    if ([sharedData areTodayChallengesValid] == NO)
    {
        [self loadDashboard];
    }
    
   /* [[EHRManager sharedManager] isConnectedWithCompletion:^(BOOL isConnected)
    {
        if (!isConnected)
        {
            __weak typeof(self) weakSelf = self;
            [[EHRManager sharedManager] MRNExistsWithCompletion:^(PFObject *object)
             {
                 if (object)
                 {
                     EHRViewController *ehrViewController = [[EHRViewController alloc] init];
                     ehrViewController.HL7Import = object;
                     
                     __strong typeof(weakSelf) self = weakSelf;
                     [self presentViewController:ehrViewController animated:YES completion:nil];
                 }
             }];
        }
    }];*/
    
    //start locationtracking
   // [[GPSManager sharedManager] init];
    [[GPSManager sharedManager] startUpdatingLocation];
    
    [self registerCellsForTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadHealthData];
    [self loadFocus];
}
- (void) loadFocus
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadFocus];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - User definition methhod

- (void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:kNotificationRefreshChallenge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:kNotificationRefreshTodayChallenge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initUI
{
    [self initBarButtonItem];
    [self updateDashboard];
}

- (void)loadDashboard
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadChallengesWithCompletion:nil];
    [sharedData loadTodayChallenges:YES];
}

- (void)initBarButtonItem
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                     action:@selector(leftDrawerButtonClicked)
                                                                                      image:[UIImage imageNamed:@"ico_menu_threelines.png"]];
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                      action:@selector(rightDrawerButtonClicked)
                                                                                       image:[UIImage imageNamed:@"ico_menu_setting.png"]];
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
}

- (void) updateDashboard
{
    NSDate *date = [NSDate date];
    
    NSInteger weekDayOfWeek = [date weekDayOfWeek];
    weekDayOfWeek --;
    
    NSString *title = [NSString stringWithFormat:@"Today, %@ %@ %lu", [[NSDate weekdaySymbols] objectAtIndex:weekDayOfWeek], [[NSDate monthlySymbols] objectAtIndex:([date monthOfYear] - 1)], (unsigned long)[date dayOfMonth]];
    dateNavigationBar.topItem.title = title;
    
    self.title = @"DASHBOARD";
}

- (void)refreshUI:(NSNotification*)notification
{
    [_dashboardTableView reloadData];
    NSLog(@"DASHBOARD refreshUI reload %@", notification);
}

-(void)didBecomeActive:(NSNotification*)notification
{
    [[SharedData sharedData] loadTodayChallenges:YES];
    
//    [dashboardTableView reloadData];
    NSLog(@"DASHBOARD didBecomeActive reload");
    
    [self updateDashboard];
}

#pragma mark - UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    switch (sectionIndex)
    {
        //challenges
        case 0:
        {
            SharedData *sharedData = [SharedData sharedData];
            NSInteger count = sharedData.todayChallengeList.count;
            return count ? count : 1;
        }
            
        //activities
        case 1:
            return 2;
            
        //completion rate
        case 2:
            return 2;
            
        //healthrisk
        case 3:
            return 2;
            
        default:
            break;
    }

    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kHeaderHeight)];
    view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, kHeaderHeight)];
    
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    label.textColor = [UIColor darkGrayColor];

    [view addSubview:label];
    
    switch (section)
    {
            //challenges
        case 0:
        {
        
            label.text=[self.dashboardData valueForKey:@"userName"];
            break;
        }
            
            //activities
        case 1:
        {
            NSDate *date = _humanAPIData[@"Date"];
            NSString *string = date ? [NSString stringWithFormat:@"Today's Activity: %@", [NSDateFormatter localizedStringFromDate:date
                                                                                                                            dateStyle:NSDateFormatterShortStyle
                                                                                                                        timeStyle:NSDateFormatterNoStyle]] : @"Today's Activity:";
            label.text = string;
            break;
        }
            
        //completion rate
        case 2:
        {
            label.text = @"Challenge Stats:";
            break;
        }
            
        //healthrisk
        case 3:
        {
            label.text = @"Your Health Risk Based on Body Makeup:";
            break;
        }
            
        default:
            break;
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0)
    {
        SharedData *sharedData = [SharedData sharedData];

        if (sharedData.todayChallengeList.count)
        {
            Challenge *challenge = [sharedData.todayChallengeList objectAtIndex:indexPath.row];
            [[[UIAlertView alloc] initWithTitle:@"" message:challenge.challenge delegate:nil
                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Accept new challenges?"
                                                                delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alertView.tag = 1;
            [alertView show];
        }
    }
    else if (indexPath.section == 1)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"Activity data will be periodically updated by HealthKit "
                                                            delegate:nil cancelButtonTitle:@"Thanks!"                 otherButtonTitles:nil, nil
                                   ];
        alertView.tag = 2;
        [alertView show];
    }
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        NSString *healthRisk=@"";
        if(self.dashboardData==nil){
            healthRisk=@"";
        }
        
        else if ([[self.dashboardData valueForKey:@"healthRisk"] isEqualToString:@"IMMEDIATE_ACTION"])
        {
            healthRisk=@"Needs Immediate Action";
            
        }
        else if ([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"HIGH_RISK"])
        {
            healthRisk=@"High risk";
        }
        else if ([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"LOW_RISK"])
        {
            healthRisk=@"Low risk";
        }
        else if([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"VERY_LOW_RISK"] )
        {
            healthRisk=@"Very low risk";
        }
        
        UIAlertView * alertView = [[UIAlertView alloc]          initWithTitle:@"Your Health Risk"
                                                             message:[NSString stringWithFormat:@"\n%@",healthRisk]
                                                            delegate:nil cancelButtonTitle:@"Thanks!"                 otherButtonTitles:nil, nil
                                   ];
        alertView.tag = 3;
        [alertView show];
    }
}

#pragma mark - UITableView Data Source

- (void)registerCellsForTableView {
    [_dashboardTableView registerNib:[UINib nibWithNibName:@"ChallengeCell" bundle:nil] forCellReuseIdentifier:@"ChallengeCell"];
    [_dashboardTableView registerNib:[UINib nibWithNibName:@"SummaryCell" bundle:nil] forCellReuseIdentifier:@"SummaryCell"];
    [_dashboardTableView registerNib:[UINib nibWithNibName:@"DailyPointsCell" bundle:nil] forCellReuseIdentifier:@"DailyPointsCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        //challenges
        case 0:
        {
            SharedData *sharedData = [SharedData sharedData];
            
            if (sharedData.todayChallengeList.count)
            {
                ChallengeCell *challengeCell = (ChallengeCell *)[tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
                
                if (!challengeCell)
                {
                    challengeCell = (ChallengeCell *)[[[NSBundle mainBundle] loadNibNamed:@"ChallengeCell" owner:self options:nil] objectAtIndex:0];
                }
                
                Challenge *challenge = [sharedData.todayChallengeList objectAtIndex:indexPath.row];
                
                [challengeCell setChallengeCellInfo:challenge];
                challengeCell.delegate = self;
                
                return challengeCell;
            }
            else
            {
                SummaryCell *summaryCell = (SummaryCell *)[[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
                [summaryCell setSummaryCell:@"Challenges expired!" :@"Tap to accept new"];

                return summaryCell;
            }
        }
            
        //activities
        case 1:
        {
            SummaryCell *summaryCell = (SummaryCell *)[[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
 
//            if (indexPath.row == 0)
//            {
//                if (_fitbitData)
//                {
//                    NSString *resultString = nil;
//                    
//                    if (_fitbitData[@"data"])
//                    {
//                        NSString *hr = _fitbitData[@"data"][@"RestingHR"] ? _fitbitData[@"data"][@"RestingHR"] : @"0";
//                        resultString = [NSString stringWithFormat:@"%@ BPM", hr];
//                    }
//                    else
//                    {
//                        resultString = @"No Fitbit";
//                    }
//                    
//                    [summaryCell setSummaryCell:@"Heart Rate:" :resultString];
//                }
//                else
//                {
//                    [summaryCell setSummaryCell:@"Heart Rate:" :@"0"];
//
//                   if(self.dashboardData==nil)
//                        [summaryCell setSummaryCell:@"Heart Rate:" :@"0"];
//                    else
//                        [summaryCell setSummaryCell:@"Heart Rate:" :[[self.dashboardData valueForKey:@"heartRate"] stringValue]];
//                }
//            }
//            else if (indexPath.row == 1)
//            {
//                if (_humanAPIData)
//                {
//                    if (_humanAPIData[@"data"])
//                    {
//                        NSString *sleep = _humanAPIData[@"data"][@"TotalSleepMinutes"] ? _humanAPIData[@"data"][@"TotalSleepMinutes"] : @"0";
//                        [summaryCell setTimeCellWithTitle:@"Sleep:" time:[sleep integerValue]];
//                    }
//                    else
//                    {
//                        if (_fitbitData)
//                        {
//                            if (_fitbitData[@"data"])
//                            {
//                                NSString *sleep = _fitbitData[@"data"][@"TotalSleepMinutes"] ? _fitbitData[@"data"][@"TotalSleepMinutes"] : @"0";
//                                [summaryCell setTimeCellWithTitle:@"Sleep:" time:[sleep integerValue]];
//                            }
//                            else
//                            {
//                                [summaryCell setSummaryCell:@"Sleep:" :@"No Fitbit"];
//                            }
//                        }
//                        else
//                        {
//                            [summaryCell setSummaryCell:@"Sleep:" :@"loading..."];
//                        }
//                    }
//                }
//                else
//                {
//                    [summaryCell setSummaryCell:@"Sleep:" :@"loading..."];
//                    [summaryCell setTimeCellWithTitle:@"Sleep:" time:[[self.dashboardData valueForKey:@"sleep" ]integerValue]];
//                  
//                }
//            }
            if (indexPath.row == 0)
            {
                if(self.dashboardData==nil)
                [summaryCell setSummaryCell:@"Step Count:" :@"0"];
                else
                [summaryCell setSummaryCell:@"Step Count:" :[[self.dashboardData valueForKey:@"stepCount"] stringValue]];
                          }
            else if (indexPath.row == 1)
            {
                [summaryCell setSummaryCell:@"Distance Travelled:" :@"loading.."];
                if(self.dashboardData==nil)
                {
                    [summaryCell setSummaryCell:@"Distance Travelled:" :@"0"];
                }
                else
                {
                    NSMutableString *dist=[[self.dashboardData valueForKey:@"distance"] stringValue];
                    
                    NSInteger distanceInInteger = [dist integerValue];
                    NSString *units;
                    if (distanceInInteger > 5280) {
                        
                        units = @"miles";
                    }
                    else
                    {
                        units = @"feet";
                    }
                    if(dist.length>6)
                        dist=[dist substringToIndex:6];
                    
                    
                    dist = [dist stringByAppendingString:[NSString stringWithFormat:@" %@",units]];
                    [summaryCell setSummaryCell:@"Distance Travelled:" :dist];

                }
            }
            else
            {
                return nil;
            }
            
            return summaryCell;
        }
            
        //completion rate
        case 2:
        {
            return [self tableView:tableView cellForChallengesCompletionRateAtIndexPath:indexPath];
        }
            
        //healthrisk
        case 3:
        {
            if (indexPath.row == 1)
            {
                SummaryCell *summaryCell = (SummaryCell *)[[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
                
               
                NSNumber *ideal = @0;;
                if (!ideal) {
                    //?
                    ideal = @0;
                }
                if(self.dashboardData==nil)
                {
                    NSString *string = [NSString stringWithFormat:@"Ideal waist size: %@ inch", [ideal stringValue]];
                    [summaryCell setSummaryCell:@"Your waist size:" :string];
                    
                    NSString *yourWC = @"0";
                    [summaryCell setSummaryCell:[NSString stringWithFormat:@"Your waist size: %@ inch", yourWC] :string];
                }
                
                else
                {
                NSString *string = [NSString stringWithFormat:@"Ideal waist size: %@ inch", [self.dashboardData valueForKey:@"idealWaistSize"]];
              
                    NSString *wc = [NSString stringWithFormat:@"Your waist size: %@ inch", [[self.dashboardData valueForKey:@"waistSize"] stringValue]];
                   
                    [summaryCell setSummaryCell:wc:string];
                }
                return summaryCell;
            }
            else if (indexPath.row == 0)
            {
                DailyPointsCell *pointCell = (DailyPointsCell *)[tableView dequeueReusableCellWithIdentifier:@"DailyPointsCell"];
                
                if (!pointCell)
                {
                    pointCell = (DailyPointsCell *)[[[NSBundle mainBundle] loadNibNamed:@"DailyPointsCell" owner:self options:nil] objectAtIndex:0];
                }
                CGFloat absi=0.0;
                if(self.dashboardData==nil){
                     absi=0.0;
                    }
                
                else if ([[self.dashboardData valueForKey:@"healthRisk"] isEqualToString:@"IMMEDIATE_ACTION"])
                {
                   absi=2.0;
                   
                }
                else if ([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"HIGH_RISK"])
                {
                        
                    absi=1.0;
                }
                else if ([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"LOW_RISK"])
                {
                        absi=-1.0;
                       
                }
                else if([[self.dashboardData valueForKey:@"healthRisk"]isEqualToString:@"VERY_LOW_RISK"] )
                {
                        absi=-2.0;
                        
                }
               
                [pointCell setABSI:absi healthRisk:(self.dashboardData==nil)? @"" : [self.dashboardData valueForKey:@"healthRisk"]];
                
                return pointCell;
            }
        }
            
        default:
            break;
    }
    
    return nil;
}



#pragma mark
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex)
        {
            HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
            [self.mm_drawerController setCenterViewController:appDelegate.challengeViewController withCloseAnimation:NO completion:nil];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex)
        {
            _humanAPIData = nil;
            _fitbitData = nil;
            [_dashboardTableView reloadData];
            
            [self loadHealthData];
        }
    }
}



#pragma mark - Selector

- (void)leftDrawerButtonClicked
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) rightDrawerButtonClicked
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.mm_drawerController setCenterViewController:appDelegate.settingViewController withCloseAnimation:NO completion:nil];
}

#pragma mark - Challenges Completion Rate Summary Cell Descriptions

- (SummaryCell *)tableView:(UITableView *)tableView cellForChallengesCompletionRateAtIndexPath:(NSIndexPath *)indexPath
{
    SummaryCell *summaryCell = (SummaryCell *)[[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
    if (indexPath.row == 0) {
        [summaryCell setSummaryCell:@"Success Rate: " :[self current2WeeksProgress]];
    } //else {
      //  [summaryCell setSummaryCell:@"For last 2 weeks: " :[self last2WeeksProgress]];
   // }

   

    return summaryCell;
}

- (NSString *)nextChallengesUpdate
{
    NSDate *now = [NSDate date];
    NSDate *tomorrow = [now oneDayNext];
    NSDate *jobDate = [NSDate dateFromYear:[tomorrow year] month:[tomorrow monthOfYear] day:[tomorrow dayOfMonth] hour:8 minute:00];

    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: jobDate];
    NSDate *timeZoneDate = [NSDate dateWithTimeInterval: seconds sinceDate: jobDate];

    NSTimeInterval timeLeft = [timeZoneDate timeIntervalSinceDate:now];
    timeLeft /= 3600;

    return [NSString stringWithFormat:@"~%d hours", (int)ceil(timeLeft)];

}

- (NSString *)convertProgress:(NSNumber *)progress {
    NSString *result = @"0";
    double percentnumber = [progress doubleValue];
    if (progress) {
        result = [NSString stringWithFormat:@"%.0f",percentnumber];
    }

    return result;
}

- (NSString *)current2WeeksProgress
{
    NSString *diet = [self convertProgress:@"0"];
    NSString *fitness = [self convertProgress:@"0"];
    NSString *stress = [self convertProgress:@"0"];
   if(self.dashboardData!=nil)
   {
       NSDictionary *last2WeeksCompletion=(NSDictionary*)[self.dashboardData objectForKey:@"challengeCompletionRate2Weeks"];
       if(last2WeeksCompletion!=(id)[NSNull null])
       {
       diet = [self convertProgress:[last2WeeksCompletion valueForKey:@"stress"]];
       fitness = [self convertProgress:[last2WeeksCompletion valueForKey:@"fitness"]];
       stress = [self convertProgress:[last2WeeksCompletion valueForKey:@"diet"]];
       }
   }
    
    return [NSString stringWithFormat:@"Diet:%@ Fitness:%@ Stress:%@", diet, fitness, stress];
}

- (NSString *)last2WeeksProgress
{
    NSString *diet = [self convertProgress:@"0"];
    NSString *fitness = [self convertProgress:@"0"];
    NSString *stress = [self convertProgress:@"0"];
    if(self.dashboardData!=nil)
    {
        NSDictionary *last2WeeksCompletion=(NSDictionary*)[self.dashboardData objectForKey:@"challengeCompletionRateLast2Weeks"];
        if(last2WeeksCompletion!=(id)[NSNull null])
        {
        diet = [self convertProgress:[last2WeeksCompletion valueForKey:@"stress"]];
        fitness = [self convertProgress:[last2WeeksCompletion valueForKey:@"fitness"]];
        stress = [self convertProgress:[last2WeeksCompletion valueForKey:@"diet"]];
        }
    }
    
    return [NSString stringWithFormat:@"Diet:%@ Fitness:%@ Stress:%@", diet, fitness, stress];
}



#pragma mark - Data Loading



-(void)loadHealthData
{
   /* [[HumanAPIManager sharedManager] fetchHumanAPIDataWithCompletion:^(id result, NSError *error)
    {
        _humanAPIData = result ? [NSDictionary dictionaryWithObject:result forKey:@"data"] : [NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"];
        
        [[FitbitManager sharedManager] fetchFitbitDataWithCompletion:^(id result, NSError *error)
         {
             _fitbitData = result ? [NSDictionary dictionaryWithObject:result forKey:@"data"] : [NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"];
             [_dashboardTableView reloadData];
         }];
    }];*/
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/patientIosDashboardData" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.dashboardData=(NSDictionary*)responseObject;
        [_dashboardTableView reloadData];
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}



#pragma mark - steps
-(NSNumber*)steps
{
   // NSNumber *steps = nil;
    NSNumber *steps = @0;
    
    if (_humanAPIData)
    {
        if (_humanAPIData[@"data"])
        {
            steps = _humanAPIData[@"data"][@"Steps"] ? _humanAPIData[@"data"][@"Steps"] : @0;
        }
    }
    
    if (!steps)
    {
        if (_fitbitData)
        {
            if (_fitbitData[@"data"])
            {
                steps = _fitbitData[@"data"][@"Steps"] ? _fitbitData[@"data"][@"Steps"] : @0;
            }
        }
    }
    
    return steps;
}


#pragma mark - Challenge cell delegate

- (void)completeChallenge:(nonnull Challenge *)challenge {
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    
    SessionManager *manager = [SessionManager sharedManager];
   
    NSDictionary *parameters = @{@"challengeId" : @(challenge.challengeId)};
    __weak __typeof(self) weakSelf = self;
    [manager POST:@"v1/markChallengeCompleted" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        challenge.completed = YES;
        [weakSelf.dashboardTableView reloadData];
              
            }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
                       }];
    [SVProgressHUD dismiss];


}

@end
