//
//  MenuCell.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
{
    IBOutlet UIImageView    *iconImageView;
    IBOutlet UILabel        *titleLabel;
}

- (void) setMenuCellInfo : (NSString *) title : (NSString *) icon;

@end
