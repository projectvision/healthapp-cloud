//
//  EHRViewController.h
//  Health
//
//  Created by Alex Volchek on 4/17/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EHRViewController : UIViewController <UITextFieldDelegate>
{
    IBOutletCollection(UITextField) NSArray *_textFields;
}

@property (nonatomic)  PFObject* HL7Import;

@end
