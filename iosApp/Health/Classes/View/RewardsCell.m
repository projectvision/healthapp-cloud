//
//  RewardsCell.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "RewardsCell.h"

@implementation RewardsCell
@synthesize titleLabel;
@synthesize indicatorView;
@synthesize cellIndex;
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRewardsCellInfo : (PFObject *) reward
{
    titleLabel.text = reward[@"name"];
    
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%ld", [reward[@"point"] integerValue]] forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 10, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
    
    selectButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    selectButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    
    [selectButton setCornerRadius:5.0f];
}

- (IBAction) selectButtonClicked : (id) sender
{
    if ( self.delegate != nil ) {
        [self.delegate didSelectRewardCell:self.cellIndex];
    }
}

@end
