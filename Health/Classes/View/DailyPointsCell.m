//
//  DailyPointsCell.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "DailyPointsCell.h"

@implementation DailyPointsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setABSI:(CGFloat)absi
{
    absi = absi < -2.0f ? -2.0f : absi > 2.0f ? 2.0f : absi;
    
    BOOL above;
    above = absi > 0 ? YES : NO;

    absi = fabs(absi);
    
    float r = 0.f, g = 0.f;
    if (above)
    {
        r = 64 * absi;
    }
    else
    {
        g = 64 * absi;
    }
    
    [progressView setProgressTintColor:[UIColor colorWithRed:(127 + r)/255 green:(127 + g)/255 blue:0.5f alpha:1]];
    
    [progressView setProgress:absi * 0.5f animated:YES];
}

@end
