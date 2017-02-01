//
//  ChallengeView.m
//  Health
//
//  Created by Administrator on 9/8/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "AcceptedChallengeView.h"
#import "Challenge.h"
#import "SharedData.h"
#import "Focus.h"

@implementation AcceptedChallengeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) initChallengeView : (Challenge *) challenge
{
    backButton.buttonColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    backButton.highlightedColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7];
    
    SharedData *sharedData = [SharedData sharedData];
    
    
    for ( int i = 0; i < [sharedData.focusList count]; i ++ ) {
        
        Focus *focus = [sharedData.focusList objectAtIndex:i];
        
        if ( focus.focusId == challenge.focusId ) {
            focusLabel.text = [NSString stringWithFormat:@"Focus: %@", focus.focus];
            
            if ( [focus.focus isEqualToString:@"Fitness"] ) {
                
                if ( challenge.level == 3 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_fitness_lv1.png"];
                } else if ( challenge.level == 2 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_fitness_lv2.png"];
                } else if ( challenge.level == 1 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_fitness_lv3.png"];
                }

            } else if ( [focus.focus isEqualToString:@"Diet"] ) {

                if ( challenge.level == 3 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_diet_lv1.png"];
                } else if ( challenge.level == 2 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_diet_lv2.png"];
                } else if ( challenge.level == 1 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_diet_lv3.png"];
                }
                
            } else if ( [focus.focus isEqualToString:@"Mind"] ) {
                
                if ( challenge.level == 3 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_social_lv1.png"];
                } else if ( challenge.level == 2 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_social_lv2.png"];
                } else if ( challenge.level == 1 ) {
                    challengeImageView.image = [UIImage imageNamed:@"ico_back_challenge_social_lv3.png"];
                }
            }
            
            break;
        }
    }
    
    if ( challenge != nil ) {
        
        challengeLabel.text = challenge.challenge;
        [challengeLabel sizeToFit];
        
        pointLabel.text = [NSString stringWithFormat:@"%ld points", (long)challenge.point];
     
        if ( challenge.accepted == YES )
            acceptedImageView.hidden = NO;
        else
            acceptedImageView.hidden = YES;
    }
}

@end
