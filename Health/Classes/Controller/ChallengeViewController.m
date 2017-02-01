//
//  ChallengeViewController.m
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "HealthAppDelegate.h"
#import "ChallengeViewController.h"
#import "SharedData.h"
#import "Common.h"
#import "Focus.h"
#import "UINavigationBar+FlatUI.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "SVProgressHUD.h"
#import "NSDate+MTDates.h"
#import "SessionManager.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

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
    
    self.title = @"TODAY'S CHALLENGES";
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];

    acceptButton.buttonColor = [UIColor colorWithRed:59.0f/255.0f green:175.0f/255.0f blue:218.0f/255.0f alpha:1.0];
    acceptButton.highlightedColor = [UIColor colorWithRed:39.0f/255.0f green:155.0f/255.0f blue:198.0f/255.0f alpha:1.0];
    acceptButton.shadowColor = [UIColor colorWithRed:46.0f/255.0f green:159.0f/255.0f blue:208.0f/255.0f alpha:1.0];
    acceptButton.shadowHeight = 1;
    [acceptButton setCornerRadius:3.0f];
    
    [self initData];
    [self initNotification];
    [self initBarButtonItem];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkExistTodayChallenge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - User Definition method

- (void) initData
{
    randomChallengeDic = [[NSMutableDictionary alloc] init];
    selectedIndexDic = [[NSMutableDictionary alloc] init];
    
    SharedData *sharedData = [SharedData sharedData];
    
    randomChallengeDic = [sharedData randomSortedChallenges];
}

- (void) refreshChallenge : (NSNotification *) notification
{
    SharedData *sharedData = [SharedData sharedData];
    
    [selectedIndexDic removeAllObjects];
    
    randomChallengeDic = [sharedData randomSortedChallenges];
    
    [challengeTableView reloadData];
    [acceptTableView reloadData];
    
    [self checkExistTodayChallenge];
}

- (void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChallenge:) name:kNotificationRefreshTodayChallenge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChallenge:) name:kNotificationRefreshChallenge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChallenge:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) initBarButtonItem
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_threelines.png"]];
    
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_setting.png"]];
    
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
}

- (void) checkExistTodayChallenge
{
    SharedData *sharedData = [SharedData sharedData];
    
    if ( [sharedData.todayChallengeList count] == 0 )
    {
        [self showAcceptedTableView:NO];
    }
    else
    {
        [self showAcceptedTableView:[sharedData areTodayChallengesValid]];
    }
}

- (void) showAcceptedTableView : (BOOL) show
{
    acceptTableView.hidden = !show;
    challengeTableView.hidden = show;
    acceptButton.hidden = show;
    
    [self updateLeftLabelAndShow:show];
}

-(void)updateLeftLabelAndShow:(BOOL)show
{
    _leftLabel.hidden = !show;
    
    if (show)
    {
       NSDate *now = [NSDate date];
       NSDate *fireTime = [PFUser currentUser][@"fireDate"];
       // NSDate *fireTime=now;
        
        NSDate *tomorrow = [now oneDayNext];
        
        NSDate *todayFireDate = [NSDate dateFromYear:[now year] month:[now monthOfYear] day:[now dayOfMonth] hour:[fireTime hourOfDay] minute:[fireTime minuteOfHour]];
        NSTimeInterval timeLeft = [todayFireDate timeIntervalSinceDate:now];
        
        if (timeLeft < 0)
        {
            NSDate *tomorrowFireDate = [NSDate dateFromYear:[tomorrow year] month:[tomorrow monthOfYear] day:[tomorrow dayOfMonth] hour:[fireTime hourOfDay] minute:[fireTime minuteOfHour]];
            timeLeft = [tomorrowFireDate timeIntervalSinceDate:now];
        }
    
        timeLeft /= 3600;
        
        _leftLabel.text = [NSString stringWithFormat:@"~%d hours left before new challenges", (int)ceil(timeLeft)];
    }
}



#pragma mark - UITableView Cell delegate method

#pragma mark - UITableViewDelegate + UITableViewDataSource methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == challengeTableView ) {
    
        
        ChallengeView *cell = [tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
        
        if (!cell)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChallengeView" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            cell.delegate = self;
        }
        
        SharedData *sharedData = [SharedData sharedData];
        Focus *focus = [sharedData.focusList objectAtIndex:indexPath.row];
        
        NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
        
        NSMutableArray *challengeListByFocus = [randomChallengeDic objectForKey:key];
        if(challengeListByFocus ==nil)
        {
       if( [[randomChallengeDic allKeys] count]==1)
        {
            Focus *focus = [sharedData.focusList objectAtIndex:indexPath.row+1];
            
            NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
            
          challengeListByFocus = [randomChallengeDic objectForKey:key];
           
        }
           else if( [[randomChallengeDic allKeys] count]==2)
            {
                Focus *focus = [sharedData.focusList objectAtIndex:indexPath.row+1];
                
                NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
                
                challengeListByFocus = [randomChallengeDic objectForKey:key];
                if(challengeListByFocus ==nil)
                {
                    Focus *focus = [sharedData.focusList objectAtIndex:indexPath.row+2];
                    
                    NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
                    
                    challengeListByFocus = [randomChallengeDic objectForKey:key];
                }
                
            }
        
        }
        
        NSInteger selectedIndex = 0;
        
        if ( [selectedIndexDic valueForKey:key] != nil)
        {
            selectedIndex = [selectedIndexDic[key] integerValue];
        }
        
        if (challengeListByFocus.count > selectedIndex)
        {
            Challenge *challenge = [challengeListByFocus objectAtIndex:selectedIndex];
            challenge.accepted = [sharedData checkExistInTodayChallengeList:challenge];
            
            [cell initChallengeView:challenge];
        }
        
        return cell;
    }
    
    AcceptedChallengeView *cell = [tableView dequeueReusableCellWithIdentifier:@"AcceptedChallengeView"];
    
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AcceptedChallengeView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Challenge *challenge = [[SharedData sharedData].todayChallengeList objectAtIndex:indexPath.row];
    challenge.accepted = YES;
    
    [cell initChallengeView:challenge];
    
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	JZSwipeCell *cell = (JZSwipeCell*)[tableView cellForRowAtIndexPath:indexPath];
	[cell triggerSwipeWithType:JZSwipeTypeLongLeft];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == challengeTableView )
    {
        return [[randomChallengeDic allKeys] count];
    }
    
   return [[SharedData sharedData].todayChallengeList count];

   
   
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
}

#pragma mark - JZSwipeCellDelegate methods

- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
{
	if (swipeType != JZSwipeTypeNone)
	{
		NSIndexPath *indexPath = [challengeTableView indexPathForCell:cell];

		if (indexPath)
		{
            SharedData *sharedData = [SharedData sharedData];
            Focus *focus = [sharedData.focusList objectAtIndex:indexPath.row];
            
            NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
            
            NSMutableArray *challengeListByFocus = [randomChallengeDic objectForKey:key];
            
            NSInteger selectedIndex = 0;
            
            if ( [selectedIndexDic valueForKey:key] != nil)
            {
                selectedIndex = [selectedIndexDic[key] integerValue];
            }
            
            if ( swipeType == JZSwipeTypeLongLeft || swipeType == JZSwipeTypeShortLeft )
            {
                if ( selectedIndex < [challengeListByFocus count] - 1 )
                {
                    selectedIndex ++;
                    
                    [selectedIndexDic setObject:[NSNumber numberWithInteger:selectedIndex] forKey:key];
                }
                
            }
            else if ( swipeType == JZSwipeTypeLongRight || swipeType == JZSwipeTypeShortRight )
            {
                if ( selectedIndex > 0 )
                {
                    selectedIndex --;
                    
                    [selectedIndexDic setObject:[NSNumber numberWithInteger:selectedIndex] forKey:key];
                }
            }

            [challengeTableView beginUpdates];
            [challengeTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [challengeTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [challengeTableView endUpdates];
		}
	}
	
}

- (void)swipeCell:(JZSwipeCell *)cell swipeTypeChangedFrom:(JZSwipeType)from to:(JZSwipeType)to
{
	// perform custom state changes here
	NSLog(@"Swipe Changed From (%d) To (%d)", from, to);
}

#pragma mark - NSNotificatio method

- (void) refreshUI : (NSNotification *) notification
{
    [challengeTableView reloadData];
    
    acceptBackView.hidden = NO;
    challengeTableView.hidden = NO;
}

-(void)didBecomeActive:(NSNotification*)notification
{
    [challengeTableView reloadData];
}


- (void) loadChallenges
{
    challengeTableView.hidden = YES;
    
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadChallengesWithCompletion:nil];
}

- (void) leftDrawerButtonClicked
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) rightDrawerButtonClicked
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.mm_drawerController setCenterViewController:appDelegate.settingViewController withCloseAnimation:NO completion:nil];
}



#pragma mark - IBAction

- (IBAction) acceptButtonClicked : (id) sender
{
    int totalpoint = 0;
    
    SharedData *sharedData = [SharedData sharedData];
    
    for ( int i = 0; i < [sharedData.focusList count]; i ++ ) {
        
        Focus *focus = [sharedData.focusList objectAtIndex:i];
        
        NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
        
        NSMutableArray *challengeListByFocus = [randomChallengeDic objectForKey:key];
        
        NSInteger selectedIndex = 0;
        
        if ( [selectedIndexDic valueForKey:key] != nil) {
            selectedIndex = [selectedIndexDic[key] integerValue];
        }
        
        if (challengeListByFocus.count > selectedIndex)
        {
            Challenge *challenge = [challengeListByFocus objectAtIndex:selectedIndex];
            
            totalpoint += challenge.point;
        }
    }

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you accept these challenges, worth %d points?", totalpoint] message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        
    } else if ( buttonIndex == 1 ) {
        
        PFUser *currentUser = [PFUser currentUser];
        
        SharedData *sharedData = [SharedData sharedData];
        
        NSMutableArray *objectArray = [[NSMutableArray alloc] init];
        
        for ( int i = 0; i < [sharedData.focusList count]; i ++ )
        {
            Focus *focus = [sharedData.focusList objectAtIndex:i];
            
            NSString *key = [NSString stringWithFormat:@"%ld", (long)focus.focusId];
            
            NSMutableArray *challengeListByFocus = [randomChallengeDic objectForKey:key];
            
            NSInteger selectedIndex = 0;
            
            if ( [selectedIndexDic valueForKey:key] != nil)
            {
                selectedIndex = [selectedIndexDic[key] integerValue];
            }
            
            if (challengeListByFocus.count > selectedIndex)
            {
                Challenge *challenge = [challengeListByFocus objectAtIndex:selectedIndex];
                NSDate *today = [NSDate date];
                
               /* PFObject *object = [PFObject objectWithClassName:@"UserChallenges"];
                object[@"challengeId"] = [NSNumber numberWithInteger:challenge.challengeId];
                object[@"user"] = currentUser;
                object[@"acceptedAt"] = today;*/
                
                NSDate *fireDate = currentUser[@"fireDate"];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *addDay = [[NSDateComponents alloc] init];
                [addDay setDay:1];
                
                NSDate *tommorow = [calendar dateByAddingComponents:addDay toDate:today options:0];

                NSDate *expiredAtDate = [NSDate dateFromYear:[tommorow year] month:[tommorow monthOfYear] day:[tommorow dayOfMonth] hour:[fireDate hourOfDay] minute:[fireDate minuteOfHour]];
               /* object[@"expiredAt"] = expiredAtDate;*/
                
                [objectArray addObject:[NSNumber numberWithInteger:challenge.challengeId]];
            }
        }
               [SVProgressHUD showWithStatus:@"Accepting..." maskType:SVProgressHUDMaskTypeBlack];
        
        SessionManager *manager = [SessionManager sharedManager];
        
        NSMutableDictionary *parameters = @{@"challengeIds[]":[NSSet setWithArray:objectArray]};
       
       [manager POST:@"v1/markChallengesAccepted" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
           
            [sharedData loadTodayChallenges:NO];
            
            HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
            [self.mm_drawerController setCenterViewController:appDelegate.dashboardViewController withCloseAnimation:NO completion:nil];
        }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  [sharedData loadTodayChallenges:NO];
                  
                  HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
                  [self.mm_drawerController setCenterViewController:appDelegate.dashboardViewController withCloseAnimation:NO completion:nil];
                             
        }];
        
        [SVProgressHUD dismiss];

        acceptButton.hidden = YES;
        
        [challengeTableView reloadData];
    }
}


@end
