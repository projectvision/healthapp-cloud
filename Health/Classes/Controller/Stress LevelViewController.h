//
//  Stress LevelViewController.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import <Parse/Parse.h>

@class TableViewWithBlock;

@interface Stress_LevelViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *_contentWidthConstraint;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *combo1Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo2Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo3Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo4Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo5Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo6Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo7Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo8Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo9Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo10Btn;

///////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UITextField *combo1Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo2Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo3Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo4Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo5Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo6Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo7Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo8Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo9Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo10Txt;

////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo1Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo2Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo3Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo4Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo5Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo6Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo7Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo8Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo9Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo10Table;
@property (weak, nonatomic) IBOutlet FUIButton *saveButton;
@property(strong) NSDictionary *stressLevel;

@end
