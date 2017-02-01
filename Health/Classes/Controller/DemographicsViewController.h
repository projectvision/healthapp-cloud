//
//  DemographicsViewController.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "FUIButton.h"
#import <Parse/Parse.h>

@class TableViewWithBlock;

@interface DemographicsViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>
{
    IBOutlet UITextField    *_nameTextField;
    IBOutlet UITextField    *_surnameTextField;
    
    IBOutlet UITextField    *bornTextField;
    IBOutlet UIDatePicker   *pickerView;
    BOOL                    isOpenedCalendarView;
    IBOutlet UIView         *calendarView;
    
    IBOutletCollection(UIButton) NSArray *_bodyShapeButtons;
    
    IBOutlet NSLayoutConstraint *_contentWidthConstraint;
    IBOutlet NSLayoutConstraint *_calendarViewConstraint;
}

@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotable1;
@property (weak, nonatomic) IBOutlet UIButton *comboBtn1;
@property (weak, nonatomic) IBOutlet UITextField *comboText1;
@property (weak, nonatomic) IBOutlet UIButton *comboBtn2;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotable2;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *comboText2;
@property (weak, nonatomic) IBOutlet UIButton *comboBtn3;
@property (weak, nonatomic) IBOutlet UITextField *comboText3;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *combotable3;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet FUIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *mrnTextField;
@property (weak, nonatomic) IBOutlet UITextField *waistTextField;
@property(strong) NSDictionary *demographics;
@end
