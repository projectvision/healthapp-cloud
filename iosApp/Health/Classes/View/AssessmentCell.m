//
//  AssessmentCell.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "AssessmentCell.h"

@implementation AssessmentCell
@synthesize delegate;
@synthesize titleLabel;
@synthesize cellIndex;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self cellUIInit];

    // Configure the view for the selected state
}
-(void)cellUIInit
{
    switch (cellIndex) {
        case 0:
            titleLabel.text = @"Demographics";
            break;
        case 1:
            titleLabel.text = @"Lifestyle";
            break;
        case 2:
            titleLabel.text = @"Diet";
            break;
        case 3:
            titleLabel.text = @"Stress Level";
            break;
        case 4:
           
            titleLabel.text = @"Health Beliefs";
            break;
            
        default:
            break;
    }
}
- (void) setAssessmentCellInfo
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
     [badgeButton setTitle:@"0%" forState:UIControlStateNormal];
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
    
    selectButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    selectButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    
    [selectButton setCornerRadius:5.0f];
}

- (IBAction)selectButtonClick:(id)sender {
    [delegate didSelectAssessmentCell:cellIndex];
}

@end
