//
//  RewardsViewController.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "RewardsViewController.h"
#import "RewardDetailViewController.h"
#import "RewardsCell.h"
#import "UINavigationBar+FlatUI.h"
#import "MMDrawerBarButtonItem.h"
#import "HealthAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "SharedData.h"
#import "Common.h"

@interface RewardsViewController ()

@end

@implementation RewardsViewController
@synthesize rewardList;

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
    
    [self initData];
    [self initUI];
//    [self loadReward];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshEarnedPoint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    self.title = @"REWARDS STORE";
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];
        
    [self initBarButtonItem];
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
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%d", 165] forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 10, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

- (void) initData
{
    rewardList = [[NSMutableArray alloc] init];
}

- (void) initTitleView
{
    
}

- (void) refreshEarnedPoint
{
    PFUser *user = [PFUser currentUser];
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%d", [user[@"earnedPoint"] integerValue]] forState:UIControlStateNormal];
}

- (void) loadReward
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reward"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        [rewardList removeAllObjects];
        
        if ( objects != nil ) {
            [rewardList addObjectsFromArray:objects];
        }
        
        [rewardsTableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
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
    SharedData *sharedData = [SharedData sharedData];
    
    return [sharedData.rewardList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    RewardsCell *rewardCell;
    
    rewardCell = (RewardsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( rewardCell == nil ) {
        
        rewardCell = (RewardsCell *)[[[NSBundle mainBundle] loadNibNamed:@"RewardsCell" owner:self options:nil] objectAtIndex:0];
        rewardCell.delegate = self;
    }
    
    SharedData *sharedData = [SharedData sharedData];
    
    rewardCell.cellIndex = indexPath.row;
    
    PFObject *reward = [sharedData.rewardList objectAtIndex:indexPath.row];
    
    [rewardCell setRewardsCellInfo:reward];
    
    return rewardCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SharedData *sharedData = [SharedData sharedData];
    
    PFObject *reward = [sharedData.rewardList objectAtIndex:indexPath.row];
    
    RewardDetailViewController *detailVc = [[RewardDetailViewController alloc] initWithNibName:@"RewardDetailViewController" bundle:nil];
    
    detailVc.reward = reward;
    
    [self.navigationController pushViewController:detailVc animated:YES];
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

#pragma mark - Rewards Cell Delegate method

- (void) didSelectRewardCell : (NSInteger) index
{
    SharedData *sharedData = [SharedData sharedData];
    
    selectedIndex = index;
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *reward = [sharedData.rewardList objectAtIndex:index];
    
    if ( [reward[@"point"] integerValue] > [currentUser[@"earnedPoint"] integerValue] ) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You haven't enough points to select this item." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure to use this item?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        
    } else if ( buttonIndex == 1 ) {
        
        [SVProgressHUD showWithStatus:@"Selecting..."];
        
        PFUser *currentUser = [PFUser currentUser];
        
        SharedData *sharedData = [SharedData sharedData];
        
        PFObject *reward = [sharedData.rewardList objectAtIndex:selectedIndex];
        
        PFObject *object = [PFObject objectWithClassName:@"UserRewards"];
        object[@"user"] = currentUser;
        object[@"rewardId"] = reward.objectId;

        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if ( succeeded == YES ) {
                
                NSInteger earnedPoint = [currentUser[@"earnedPoint"] integerValue];
                earnedPoint -= [reward[@"point"] integerValue];
                
                currentUser[@"earnedPoint"] = [NSNumber numberWithInteger:earnedPoint];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                   
                    if ( succeeded == YES ) {
                        
                        [self refreshEarnedPoint];

                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshSelectedRewardList object:nil];
                    }
                    
                    [SVProgressHUD dismiss];
                    
                }];
                
            } else {
                
                [SVProgressHUD dismiss];
                
            }
            
        }];
    }
}

@end
