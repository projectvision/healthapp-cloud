//
//  ChooseIssueViewController.m
//  Health
//
//  Created by Administrator on 9/15/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "ChooseIssueViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "HealthAppDelegate.h"
#import "SharedData.h"
#import "Common.h"

@interface ChooseIssueViewController ()

@end

@implementation ChooseIssueViewController

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
    
    issueList = [[NSMutableArray alloc] init];
    
    [self initUI];
    [self loadIssueList];
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    
}
-(void)checkFirstTime
{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Assessment" message:@"Complete the health assessment to get your individualized weight loss plan." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadchallengeFinish:) name:kNotificationRefreshChallenge object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    chooseButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    chooseButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    chooseButton.shadowHeight = 1;
    chooseButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [chooseButton setCornerRadius:3.0f];
}

- (void) loadIssueList
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Issue"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [issueList removeAllObjects];
        
        if ( error == nil ) {
            [issueList addObjectsFromArray:objects];
        }
        
        [issuePickerView reloadAllComponents];
        
        [SVProgressHUD dismiss];
        
    }];
    
}

- (void) loadChallengeData : (NSInteger) issueId
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadChallenge:issueId];
}

- (void) loadchallengeFinish : (NSNotification *) notification
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController pushViewController:appDelegate.rootViewController animated:YES];
}

#pragma mark - UIPickerView delegate method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [issueList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PFObject *object = [issueList objectAtIndex:row];
    
    return object[@"healthIssue"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    PFObject *object = [issueList objectAtIndex:row];
//    
}

- (IBAction) chooseButtonClicked : (id) sender
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    PFObject *issueObject = [issueList objectAtIndex:[issuePickerView selectedRowInComponent:0]];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"usedIssueId"] = issueObject[@"issueId"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [SharedData saveIssueText:issueObject[@"healthIssue"]];
       
        if ( succeeded == YES ) {
            [self loadChallengeData:[issueObject[@"issueId"] integerValue]];
//            [self checkFirstTime];
        } else {
            [SVProgressHUD dismiss];
        }

    }];
}

@end
