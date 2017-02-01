//
//  UINavigationBar+FlatUI.m
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "UINavigationBar+FlatUI.h"
#import "UIImage+FlatUI.h"

@implementation UINavigationBar (FlatUI)

- (void) configureFlatNavigationBarWithColor:(UIColor *)color {

    [self setBackgroundImage:[UIImage imageNamed:@"ico_navigationbar_background.png"]
               forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
    
    NSMutableDictionary *titleTextAttributes = [[self titleTextAttributes] mutableCopy];
    if (!titleTextAttributes) {
        titleTextAttributes = [NSMutableDictionary dictionary];
    }
    
    if (&NSShadowAttributeName != NULL) {
        // iOS6 methods
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowOffset:CGSizeZero];
        [shadow setShadowColor:[UIColor clearColor]];
        [titleTextAttributes setObject:shadow forKey:NSShadowAttributeName];
    } else {
        // Pre-iOS6 methods
        [titleTextAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
        [titleTextAttributes setValue:[NSValue valueWithUIOffset:UIOffsetZero] forKey:UITextAttributeTextShadowOffset];
    }
    
    [self setTitleTextAttributes:titleTextAttributes];
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        [self setShadowImage:[UIImage new]];
    }
    
    [self removeDarkBarInNavigation];
}

- (void) removeDarkBarInNavigation
{
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        [self setShadowImage:[UIImage new]];
    }
    
    /*
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 2)];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [overlayView setBackgroundColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];
    [self addSubview:overlayView];
     */
}

@end
