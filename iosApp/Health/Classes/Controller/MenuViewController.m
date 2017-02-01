//
//  MenuViewController.m
//  Health
//
//  Created by Administrator on 8/29/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HealthAppDelegate.h"
#import "MenuCell.h"
#import "SharedData.h"
#import "SessionManager.h"
#import "SVProgressHUD.h"


@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITableView delegate method

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MenuCell *menuCell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( menuCell == nil ) {
        
        menuCell = (MenuCell *)[[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if ( indexPath.row == 0 ) {
        [menuCell setMenuCellInfo:@"Dashboard" :@"ico_menu_user.png"];
    } else if ( indexPath.row == 1 ) {
        [menuCell setMenuCellInfo:@"Challenges" :@"ico_menu_bell.png"];
    } else if ( indexPath.row == 2 ) {
        [menuCell setMenuCellInfo:@"History" :@"ico_menu_message.png"];
    }
    else if ( indexPath.row == 3 ) {
        [menuCell setMenuCellInfo:@"Settings" :@"ico_menu_global.png"];
    } else if ( indexPath.row == 4 ) {
        [menuCell setMenuCellInfo:@"Assessment" :@"assessment.png"];
    } else if  (indexPath.row == 5){
        [menuCell setMenuCellInfo:@"Logout" :@""];
    }
    
    menuCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ( indexPath.row == 0 ) {
        
        [self.mm_drawerController setCenterViewController:appDelegate.dashboardViewController withCloseAnimation:YES completion:nil];
        
    } else if ( indexPath.row == 1 ) {
        
        [self.mm_drawerController setCenterViewController:appDelegate.challengeViewController withCloseAnimation:YES completion:nil];
        
    } else if ( indexPath.row == 2 ) {
        
        [self.mm_drawerController setCenterViewController:appDelegate.historyViewController withCloseAnimation:YES completion:nil];
        
    }
    else if ( indexPath.row == 3 ) {
        
        [self.mm_drawerController setCenterViewController:appDelegate.settingViewController withCloseAnimation:YES completion:nil];

    } else if ( indexPath.row == 4 ) {
        [self.mm_drawerController setCenterViewController:appDelegate.assessmentViewController withCloseAnimation:YES completion:nil];
        
        
    } else if ( indexPath.row == 5 ) {
        
        [[[UIAlertView alloc] initWithTitle:@"Are you sure to log out?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
        
        SharedData *sharedData = [SharedData sharedData];
        [SVProgressHUD showWithStatus:@"Logging out..." maskType:SVProgressHUDMaskTypeBlack];
        SessionManager *manager = [SessionManager sharedManager];
        NSDictionary *parameters = @{};
       
        
        
        [manager POST:@"v1/logout" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *viewControlles = [self.mm_drawerController.navigationController viewControllers];
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
           // [alertView show];
            
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
}

@end
