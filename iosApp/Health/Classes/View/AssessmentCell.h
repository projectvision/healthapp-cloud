//
//  AssessmentCell.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
@protocol AssessmentCellDelegate <NSObject>

- (void) didSelectAssessmentCell : (NSInteger) index;

@end
@interface AssessmentCell : UITableViewCell
{
    IBOutlet UILabel                    *titleLabel;
    IBOutlet UIButton                   *badgeButton;
    IBOutlet FUIButton                  *selectButton;
    
}
@property (nonatomic, assign) id<AssessmentCellDelegate>    delegate;
@property (weak, nonatomic) IBOutlet UIButton *badgButton;
@property (nonatomic, retain) IBOutlet UILabel                  *titleLabel;
@property (nonatomic, assign) NSInteger     cellIndex;
- (void) setAssessmentCellInfo;
@end
