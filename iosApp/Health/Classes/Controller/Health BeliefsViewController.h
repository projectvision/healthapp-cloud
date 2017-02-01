//
//  Health BeliefsViewController.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import <Parse/Parse.h>
@class TableViewWithBlock;
@interface Health_BeliefsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *combo1Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo2Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo3Btn;
@property (weak, nonatomic) IBOutlet UIButton *combo4Btn;
@property (weak, nonatomic) IBOutlet UITextField *combo1Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo2Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo3Txt;
@property (weak, nonatomic) IBOutlet UITextField *combo4Txt;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo1Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo2Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo3Table;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combo4Table;
@property (weak, nonatomic) IBOutlet FUIButton *saveButton;
@end
