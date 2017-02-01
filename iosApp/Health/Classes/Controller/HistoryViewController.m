//
//  HistoryViewController.m
//  Health
//
//  Created by Administrator on 9/12/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "HealthAppDelegate.h"
#import "HistoryViewController.h"
#import "RewardDetailViewController.h"
#import "ChallengeCell.h"
#import "HistoryHeaderView.h"
#import "Common.h"
#import "SharedData.h"
#import "UINavigationBar+FlatUI.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "ChallengeHistoryCell.h"
#import "BackgroundApiCall.h"
#import <Parse/Parse.h>


@interface HistoryViewController ()

@end

@implementation HistoryViewController

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
    
    self.title = @"HISTORY";
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];
    [self initBarButtonItem];

    [self initNotification];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadCompletedChallenges];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [_historyTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHistory:) name:kNotificationRefreshCompletedChallenge object:nil];
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRewardList:) name:kNotificationRefreshSelectedRewardList object:nil];
}


- (void) initBarButtonItem
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_threelines.png"]];
    
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_setting.png"]];
    
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
}

- (void) loadCompletedChallenges
{
    SharedData *sharedData = [SharedData sharedData];
    
    [sharedData loadCompletedChallengeList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HistoryHeaderView *headerView;

    headerView = [[[NSBundle mainBundle] loadNibNamed:@"HistoryHeaderView" owner:self options:nil] objectAtIndex:0];
        
    headerView.challengeLabel.text = @"Completed Challenges";
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    SharedData *sharedData = [SharedData sharedData];

    return [sharedData.completedChallengeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChallengeHistoryCell";

    ChallengeHistoryCell *challengeCell = (ChallengeHistoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (challengeCell == nil) {
        challengeCell = (ChallengeHistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"ChallengeHistoryCell" owner:self options:nil] objectAtIndex:0];
    }
    
    SharedData *sharedData = [SharedData sharedData];
    
    Challenge *challenge = [sharedData.completedChallengeList objectAtIndex:indexPath.row];
    
    [challengeCell setHistoryCellInfo:challenge];
    
    return challengeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SharedData *sharedData = [SharedData sharedData];
    
    Challenge *challenge = [sharedData.completedChallengeList objectAtIndex:indexPath.row];
    
    [[[UIAlertView alloc] initWithTitle:challenge.challenge message:@"" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void) refreshHistory : (NSNotification *) notification
{
    [_historyTableView reloadData];
}

#pragma mark - Selector

- (void) leftDrawerButtonClicked
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) rightDrawerButtonClicked
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.mm_drawerController setCenterViewController:appDelegate.settingViewController withCloseAnimation:NO completion:nil];
}

- (IBAction)updateWeightButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Update weight" message:@"Please enter your current weight" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 0;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}

- (IBAction)updateWaistSizeButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Update waist size" message:@"Please enter your current waist size" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *stringText = textField.text;
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([stringText rangeOfCharacterFromSet:notDigits].location != NSNotFound)
        {
            NSString *message = alertView.tag ? @"Incorrect waist size entered" : @"Incorrect weight entered";
            [[[UIAlertView alloc] initWithTitle:@"Try again" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            int weight=[stringText integerValue];
            if(stringText.length>3)
            {
                
                [[[UIAlertView alloc] initWithTitle:@"Try again" message:@"Enter value upto 3 digits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                return;
            }
            NSString *col = alertView.tag ? @"Waist_Circumference" : @"WEIGHT";
            if([col isEqualToString:@"WEIGHT"])
            [BackgroundApiCall postPatientWeight:weight] ;
            else if([col isEqualToString:@"Waist_Circumference"])
             [BackgroundApiCall postPatientWaist:weight] ;
        }
    }
}


@end
