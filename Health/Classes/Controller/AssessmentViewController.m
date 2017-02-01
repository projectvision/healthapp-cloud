//
//  AssessmentViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "AssessmentViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "MMDrawerBarButtonItem.h"
#import "HealthAppDelegate.h"
#import "NSDate+MTDates.h"
#import "AssessmentCell.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "Stress LevelViewController.h"
#import "DemographicsViewController.h"
#import "DietViewController.h"
#import "LifestyleViewController.h"
#import "Health BeliefsViewController.h"
#import "SVProgressHUD.h"
#import "SharedData.h"
#import "Common.h"
#import "SessionManager.h"
#import "BackgroundApiCall.h"
#import "GSHealthKitManager.h"

@interface AssessmentViewController ()
{
   
    int percent;
}

@end

@implementation AssessmentViewController
@synthesize submitButton;
@synthesize assessmentPercent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];
    
    [self initUI];
    submitButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    submitButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    
    [submitButton setCornerRadius:5.0f];
    [[GSHealthKitManager sharedManager] requestAuthorization];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadFocus];
    [self loaddata];
    [self checkFirstTime];
   
   [self startBackgroundTask];
    
    if (percent < 100)
    {
        if (self.mm_drawerController.leftDrawerViewController)
        {
            _leftDrawerController = self.mm_drawerController.leftDrawerViewController;
            [self.mm_drawerController setLeftDrawerViewController:nil];
        }
    }
}
-(void) startBackgroundTask
{
    float timeInterval;
    NSString *frequency = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frequency"];
    if([frequency isEqualToString:@"Once a Day"])
    {
        timeInterval=24*60*60;
        
    }
    else if([frequency isEqualToString:@"Twice a Day"])
    {
        timeInterval=12*60*60;
    }
    else if([frequency isEqualToString:@"Every Hour"])
    {
        timeInterval=1*60*60;
    }
    else if([frequency isEqualToString:@"Every Minute"])
    {
        timeInterval=1*1*60;
    }
    NSTimer *timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                             target:self
                                           selector:@selector(performAction:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)performAction:(NSTimer*)theTimer
{
    [[GSHealthKitManager sharedManager] readStepCount];
    [[GSHealthKitManager sharedManager] readEnergyBurned];
    [[GSHealthKitManager sharedManager] queryHealthDataHeart];
}



- (void) loadFocus
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadFocus];
}

-(void)setCompletionPercent:(int)p
{
    percent = p;
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%d%%", percent] forState:UIControlStateNormal];
    
    if (percent>=98)
    {
        self.submitButton.enabled = YES;
        
        if (!self.mm_drawerController.leftDrawerViewController)
        {
            [self.mm_drawerController setLeftDrawerViewController:_leftDrawerController];
        }
    }
    else
    {
        self.submitButton.enabled = NO;
    }
}

-(void)checkFirstTime
{
    
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"first"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"first"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[UIAlertView alloc] initWithTitle:@"Assessment" message:@"Complete the health assessment to get your individualized weight loss plan." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    
}


-(void)loaddata
{
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/healthAssessmentOverallPercentage" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
         [SVProgressHUD popActivity];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        self.assessmentPercent = (NSDictionary *)responseObject;
        if([self.assessmentPercent count]>0)
        {
           [tb reloadData];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];

    
 
}

- (void) initUI
{
    [self initBarButtonItem];
    [self initDashboard];
    [self initBadgeButton];
}

- (void) initBarButtonItem
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_threelines.png"]];
    
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_setting.png"]];
    
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
}

- (void) initBadgeButton
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
    [badgeButton setTitle:@"0%" forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

- (void) initDashboard
{
    NSDate *date = [NSDate date];
    
    NSInteger weekDayOfWeek = [date weekDayOfWeek];
    weekDayOfWeek --;
    
    NSString *title =@"Assessment"; //[NSString stringWithFormat:@"Today, %@ %@ %d", [[NSDate weekdaySymbols] objectAtIndex:weekDayOfWeek], [[NSDate monthlySymbols] objectAtIndex:([date monthOfYear] - 1)], [date dayOfMonth]];
    
    self.title = @"HEALTH ASSESSMENT";
    
    dateNavigationBar.topItem.title = title;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector

- (void) leftDrawerButtonClicked
{
    if (percent == 100)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please complete the health assessment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Logout", nil];
        [av show];
    }
    
}

- (void) rightDrawerButtonClicked
{
    if (percent == 100)
    {
        HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
        [self.mm_drawerController setCenterViewController:appDelegate.settingViewController withCloseAnimation:NO completion:nil];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please complete the health assessment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int completionPercent = (int)([[self.assessmentPercent valueForKey:@"overAllPercentage"] intValue]);
    
    [self setCompletionPercent:completionPercent];
    
//    static NSString *cellIdentifier = @"Cell";
    
    AssessmentCell *assessmentCell;
    
    assessmentCell = (AssessmentCell *) [tableView dequeueReusableCellWithIdentifier:@"AssessmentCell"];
    
    if ( assessmentCell == nil )
    {
        assessmentCell = (AssessmentCell *)[[[NSBundle mainBundle] loadNibNamed:@"AssessmentCell" owner:self options:nil] objectAtIndex:0];
        assessmentCell.delegate = self;
    }
    
    assessmentCell.cellIndex = indexPath.row;
    [assessmentCell setAssessmentCellInfo];
    
    switch (indexPath.row)
    {
        case 0:
            if(indexPath.row==0)
            {
                [assessmentCell.badgButton setTitle:[NSString stringWithFormat:@"%@%%",[self.assessmentPercent valueForKey:@"demographicsPercentage"]] forState:UIControlStateNormal];
            }
            break;
            
        case 1:
               if(indexPath.row==1)
               {
                [assessmentCell.badgButton setTitle:[NSString stringWithFormat:@"%@%%",[self.assessmentPercent valueForKey:@"lifeStylePercentage"]] forState:UIControlStateNormal];
               }
            break;
            
        case 2:
            if(indexPath.row==2)
            [assessmentCell.badgButton setTitle:[NSString stringWithFormat:@"%@%%",[self.assessmentPercent valueForKey:@"dietPercentage"]] forState:UIControlStateNormal];
            break;
            
        case 3:
            if(indexPath.row==3)
                [assessmentCell.badgButton setTitle:[NSString stringWithFormat:@"%@%%",[self.assessmentPercent valueForKey:@"stressLevelPercentage"]] forState:UIControlStateNormal];
            break;
        case 4:
            if(indexPath.row==4)
                [assessmentCell.badgButton setTitle:[NSString stringWithFormat:@"%@%%",[self.assessmentPercent valueForKey:@"healthBeliefPercentage"]] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    return assessmentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)didSelectAssessmentCell:(NSInteger)index
{
    if (index==0) {
        DemographicsViewController *detailVc = [[DemographicsViewController alloc]initWithNibName:@"DemographicsViewController" bundle:nil];
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if(index==1){
        LifestyleViewController *detailVc = [[LifestyleViewController alloc]initWithNibName:@"LifestyleViewController" bundle:nil];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else if(index==2){
        DietViewController *detailVc = [[DietViewController alloc]initWithNibName:@"DietViewController" bundle:nil];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else if(index==3){
        Stress_LevelViewController *detailVc = [[Stress_LevelViewController alloc]initWithNibName:@"Stress LevelViewController" bundle:nil];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else if(index==4){
        Health_BeliefsViewController *detailVc = [[Health_BeliefsViewController alloc]initWithNibName:@"Health BeliefsViewController" bundle:nil];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (IBAction)clickedSubmitBtn:(id)sender
{
    [SVProgressHUD showWithStatus:@"Submitting..." maskType:SVProgressHUDMaskTypeBlack];
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager POST:@"v1/markAssessmentComplete" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10.0f * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           [SVProgressHUD showSuccessWithStatus:@"Submitted Successfully!"];
                           
                           [[SharedData sharedData] loadChallengesWithCompletion:^(NSDictionary *challenges)
                            {
                                if (challenges)
                                {
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                                   {
                                                       HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
                                                       [self.mm_drawerController setCenterViewController:appDelegate.challengeViewController withCloseAnimation:NO completion:nil];
                                                   });
                                }
                                else
                                {
                                    [SVProgressHUD showErrorWithStatus:@"No challenges received, try again."];
                                }
                            }];

                       });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Problem submitting assessment,please submit again!"];
        [SVProgressHUD dismiss];
        
    }];
    //[SVProgressHUD dismiss];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
               [self logoutUser];
        
            }
}
-(void)logoutUser
{
    NSArray *viewControlles = [self.mm_drawerController.navigationController viewControllers];
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    SharedData *sharedData = [SharedData sharedData];


        [SVProgressHUD showWithStatus:@"Logging out..." maskType:SVProgressHUDMaskTypeBlack];
        SessionManager *manager = [SessionManager sharedManager];
        NSDictionary *parameters = @{};
        
        [manager POST:@"v1/logout" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [sharedData logoutUser];
            [appDelegate resetUI:0];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] isEqualToString:@"autoLogin"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.mm_drawerController.navigationController pushViewController:appDelegate.loginViewController animated:YES];
            }
            else
            {
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[LoginViewController class]])
                    {
                        [self.mm_drawerController.navigationController popToViewController:appDelegate.loginViewController animated:YES];
                    }
                    
                }
            }

            
            
            
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@" Error.."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        [SVProgressHUD dismiss];
}

@end
