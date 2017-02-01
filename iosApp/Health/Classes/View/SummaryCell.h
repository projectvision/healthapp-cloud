//
//  SummaryCell.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell
{
    IBOutlet UILabel        *titleLabel;
    IBOutlet UILabel        *summaryLabel;
}

-(void)setSummaryCell:(NSString *)title :(NSString *)summary;
-(void)setTitleCell:(NSString *)title :(NSString *)summary;
-(void)setTimeCellWithTitle:(NSString*)title time:(NSInteger)minutes;

@end
