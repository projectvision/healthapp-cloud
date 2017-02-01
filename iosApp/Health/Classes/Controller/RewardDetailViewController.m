//
//  RewardDetailViewController.m
//  Health
//
//  Created by Administrator on 9/15/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "RewardDetailViewController.h"

@interface RewardDetailViewController ()

@end

@implementation RewardDetailViewController
@synthesize reward;

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
    
    self.title = @"REWARD";
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    nameLabel.text = reward[@"name"];
    locationLabel.text = reward[@"address"];
    restrictionLabel.text = reward[@"restriction"];
    pointLabel.text = [NSString stringWithFormat:@"%d", [reward[@"point"] integerValue]];
}

@end
