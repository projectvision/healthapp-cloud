//
//  EHRViewController.m
//  Health
//
//  Created by Alex Volchek on 4/17/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "EHRViewController.h"
#import "EHRManager.h"

@interface EHRViewController ()

@end

@implementation EHRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"EHR";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    for (UITextField *textField in _textFields)
    {
        textField.delegate = self;
    }
}

-(void)tap:(UIGestureRecognizer*)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4 || textField.tag == 3)
    {
        float y = textField.tag == 4 ? 108 : 54;
        [UIView animateWithDuration:0.25f animations:^
        {
            CGRect frame = self.view.frame;
            frame.origin.y -= y;
            self.view.frame = frame;
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 4 || textField.tag == 3)
    {
        float y = textField.tag == 4 ? 108 : 54;
        [UIView animateWithDuration:0.25f animations:^
         {
             CGRect frame = self.view.frame;
             frame.origin.y += y;
             self.view.frame = frame;
         }];
    }
}

- (IBAction)checkButtonTapped:(UIButton *)sender
{
    NSString *firstName, *lastName, *addressLine1, *addressLine2, *city;
    for (UITextField* textField in _textFields)
    {
        switch (textField.tag)
        {
            case 0:
                firstName = textField.text;
                break;
            case 1:
                lastName = textField.text;
                break;
            case 2:
                addressLine1 = textField.text;
                break;
            case 3:
                addressLine2 = textField.text.length ? textField.text : @"";
                break;
            case 4:
                city = textField.text;
                break;
                
            default:
                break;
        }
    }
    
    if (!firstName.length || !lastName.length || !addressLine1.length || !city.length)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Input all fields correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        NSDictionary *MRN = @{@"firstName":firstName, @"lastName":lastName, @"addressLine1":addressLine1, @"addressLine2":addressLine2, @"city":city};
        
        __weak typeof(self) weakSelf = self;
        if ([[EHRManager sharedManager] connectMRN:MRN withHL7Import:_HL7Import])
        {
            __strong typeof(weakSelf) self = weakSelf;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"No match" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
