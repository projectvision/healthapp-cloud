//
//  SummaryCell.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSummaryCell:(NSString *)title :(NSString *)summary
{
    titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    summaryLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    
    titleLabel.text = title;
    summaryLabel.text = summary;
}

-(void)setTitleCell:(NSString *)title :(NSString *)summary
{
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    titleLabel.text = title;
    summaryLabel.text = summary;
}

-(void)setTimeCellWithTitle:(NSString*)title time:(NSInteger)minutes
{
    titleLabel.text = title;
    
    NSInteger hours = minutes / 60;
    minutes = minutes % 60;
    
    NSString *minuteTitle = minutes == 1 ? @"Minute" : @"Minutes";
    
    if (hours)
    {
        NSString *hourTitle = hours > 1 ? @"Hours" : @"Hour";
        summaryLabel.text = [NSString stringWithFormat:@"%ld %@ %ld %@", hours, hourTitle, minutes, minuteTitle];
    }
    else
    {
        summaryLabel.text = [NSString stringWithFormat:@"%ld %@", minutes, minuteTitle];

    }
}

@end
