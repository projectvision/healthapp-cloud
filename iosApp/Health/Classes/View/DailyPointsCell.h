//
//  DailyPointsCell.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyPointsCell : UITableViewCell
{
    IBOutlet UIProgressView     *progressView;
}

-(void)setABSI:(CGFloat)absi healthRisk:(NSString*)healthRisk;

@end
