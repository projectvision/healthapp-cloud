//
//  ChallengeViewController.h
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "ChallengeView.h"
#import "AcceptedChallengeView.h"
#import "JZSwipeCell.h"

@interface ChallengeViewController : UIViewController<JZSwipeCellDelegate>
{
    IBOutlet FUIButton      *acceptButton;
    IBOutlet UIView         *acceptBackView;
    IBOutlet UITableView    *challengeTableView;
    IBOutlet UITableView    *acceptTableView;
    
    NSMutableDictionary     *randomChallengeDic;
    NSMutableDictionary     *selectedIndexDic;
    
    
    IBOutlet UILabel *_leftLabel;
}

@end
