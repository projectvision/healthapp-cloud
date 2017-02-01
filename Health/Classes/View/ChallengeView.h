//
//  ChallengeView.h
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"
#import "FUIButton.h"
#import "JZSwipeCell.h"

@interface ChallengeView : JZSwipeCell
{
    IBOutlet UILabel        *challengeLabel;
    IBOutlet UILabel        *focusLabel;
    IBOutlet UILabel        *pointLabel;
    IBOutlet UIImageView    *challengeImageView;
    IBOutlet FUIButton      *backButton;
    IBOutlet UIImageView    *acceptedImageView;
}

- (void) initChallengeView : (Challenge *) challenge;


@end
