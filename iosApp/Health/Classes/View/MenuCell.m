//
//  MenuCell.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMenuCellInfo : (NSString *) title : (NSString *) icon
{
    titleLabel.text = title;
    iconImageView.image = [UIImage imageNamed:icon];
}

@end
