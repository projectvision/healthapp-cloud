//
//  LifestyleViewController.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FUIButton.h"

@class TableViewWithBlock;

@interface LifestyleViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *_contentWidthConstraint;
    
    IBOutlet NSLayoutConstraint *_quizHeightConstraint5;
    IBOutlet NSLayoutConstraint *_quizHeightConstraint4;
    IBOutlet NSLayoutConstraint *_quizHeightConstraint3;
    IBOutlet NSLayoutConstraint *_quizHeightConstraint2;
    IBOutlet NSLayoutConstraint *_quizHeightConstraint1;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *comboBtn1;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotalbe1;
@property (weak, nonatomic) IBOutlet UITextField *comboText1;

@property (weak, nonatomic) IBOutlet UIButton *comboBtn2;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotalbe2;
@property (weak, nonatomic) IBOutlet UITextField *comboText2;

@property (weak, nonatomic) IBOutlet UIButton *comboBtn3;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotalbe3;
@property (weak, nonatomic) IBOutlet UITextField *comboText3;

@property (weak, nonatomic) IBOutlet UIButton *comboBtn4;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotalbe4;
@property (weak, nonatomic) IBOutlet UITextField *comboText4;

@property (weak, nonatomic) IBOutlet UIButton *comboBtn5;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotalbe5;
@property (weak, nonatomic) IBOutlet UITextField *comboText5;
@property (weak, nonatomic) IBOutlet UIView *quiz1View;
@property (weak, nonatomic) IBOutlet UIView *quiz2View;
@property (weak, nonatomic) IBOutlet UIView *quiz3View;
@property (weak, nonatomic) IBOutlet UIView *quiz4View;
@property (weak, nonatomic) IBOutlet UIView *quiz5View;
@property (weak, nonatomic) IBOutlet FUIButton *saveButton;
@property(strong) NSDictionary *lifestyle;
@end
