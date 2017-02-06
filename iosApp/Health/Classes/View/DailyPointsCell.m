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

-(void)setABSI:(CGFloat)absi healthRisk:(NSString*)healthRisk
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
    UIColor *color=[UIColor colorWithRed:(127 + r)/255 green:(127 + g)/255 blue:0.5f alpha:1];
    CGFloat progress=0;
    if([healthRisk  isEqual: @"IMMEDIATE_ACTION"])
    {
        color=[UIColor redColor];
        progress=1;
    }
    else if([healthRisk  isEqual: @"HIGH_RISK"])
    {
        color=[UIColor orangeColor];
        progress=0.75;
    }
    else if([healthRisk  isEqual: @"LOW_RISK"])
    {
        color=[UIColor yellowColor];
        progress=0.50;
    }
    else if([healthRisk  isEqual: @"VERY_LOW_RISK"])
    {
        color=[UIColor greenColor];
        progress=0.25;
    }
    [progressView setProgressTintColor:color];
    
    [progressView setProgress:progress animated:YES];
}

@end
