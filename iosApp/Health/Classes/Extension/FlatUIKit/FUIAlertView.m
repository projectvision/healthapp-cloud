//
//  FUIAlertView.m
//  FlatUI
//
//  Created by Jack Flintermann on 5/7/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "FUIAlertView.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"

@interface FUIAlertView()

@property(nonatomic, weak) UIView *alertContentContainer;

@end

@implementation FUIAlertView

+ (void)initialize {
    if (self == [FUIAlertView class]) {
        FUIAlertView *appearance = [self appearance];
        [appearance setButtonSpacing:10.0f];
        [appearance setAnimationDuration:0.2f];
    }
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<FUIAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;

        // This mask is set to force lay out of subviews when superview's bounds change
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *backgroundOverlay = [[UIView alloc] init];
        backgroundOverlay.backgroundColor = [UIColor blueColor];
        [self addSubview:backgroundOverlay];
        backgroundOverlay.alpha = 0;
        _backgroundOverlay = backgroundOverlay;
        
        UIView *alertContainer = [[UIView alloc] init];
        alertContainer.backgroundColor = [UIColor yellowColor];
        [self addSubview:alertContainer];
        [self bringSubviewToFront:alertContainer];
        _alertContainer = alertContainer;
        
        UIView *alertContentContainer = [[UIView alloc] init];
        alertContentContainer.backgroundColor = [UIColor clearColor];
        [self.alertContainer addSubview:alertContentContainer];
        [self.alertContainer bringSubviewToFront:alertContentContainer];
        _alertContentContainer = alertContentContainer;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font = [UIFont boldFlatFontOfSize:15.0f];
        titleLabel.text = self.title;
        [alertContentContainer addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont flatFontOfSize:14.0f];
        messageLabel.text = self.message;
        [alertContentContainer addSubview:messageLabel];
        _messageLabel = messageLabel;
        
        backgroundOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6];
        titleLabel.textColor = [UIColor darkGrayColor];
//        titleLabel.font = [UIFont boldFlatFontOfSize:15.0];
        messageLabel.textColor = [UIColor darkGrayColor];
//        messageLabel.font = [UIFont flatFontOfSize:14.0];


        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            [self setHasCancelButton:YES];
        }
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg];
        }
        va_end(args);
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (CGAffineTransformIsIdentity(self.alertContainer.transform)) {
        self.backgroundOverlay.frame = self.bounds;
        CGFloat padding = 15;
        CGRect contentContainerFrame = CGRectMake(padding, padding, 0, 0);
        contentContainerFrame.size = [self calculateSize];
        self.alertContentContainer.frame = contentContainerFrame;
        CGRect alertContainerFrame = CGRectInset(contentContainerFrame, -padding, -padding);
        alertContainerFrame.origin = CGPointMake(floorf((self.frame.size.width - alertContainerFrame.size.width) / 2),
                                                 floorf((self.frame.size.height - alertContainerFrame.size.height) / 2));
        alertContainerFrame.origin.y = MAX(30, alertContainerFrame.origin.y - 30);
        self.alertContainer.frame = alertContainerFrame;
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.size.width = self.alertContentContainer.frame.size.width;
        self.titleLabel.frame = titleFrame;
        [self.titleLabel sizeToFit];
        titleFrame = self.titleLabel.frame;
        CGPoint titleOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.titleLabel.frame.size.width)/2), 0);
        titleFrame.origin = titleOrigin;
        self.titleLabel.frame = titleFrame;
        CGRect messageFrame = self.messageLabel.frame;
        messageFrame.size.width = self.alertContentContainer.frame.size.width;
        self.messageLabel.frame = messageFrame;
        [self.messageLabel sizeToFit];
        messageFrame = self.messageLabel.frame;
        CGPoint messageOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.messageLabel.frame.size.width)/2), CGRectGetMaxY(titleFrame) + 10);
        messageFrame.origin = messageOrigin;
        self.messageLabel.frame = messageFrame;

        __block CGFloat startingButtonY = self.alertContentContainer.frame.size.height - [self totalButtonHeight];
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            if (self.hasCancelButton && idx == 0) {
                CGFloat lastButtonY = self.alertContentContainer.frame.size.height - button.frame.size.height;
                
                [self setButton:obj atHeight:lastButtonY];
            } else {
                [self setButton:obj atHeight:startingButtonY];
                startingButtonY += (button.frame.size.height + self.buttonSpacing);
            }
        }];
        if(self.messageLabel.superview&&![self.messageLabel.superview isEqual:self.alertContentContainer]) {
            [self.messageLabel removeFromSuperview];
            [self.alertContentContainer addSubview:self.messageLabel];
        }
        if(self.maxHeight) {
            CGSize originalSize = messageFrame.size;
            messageFrame.size.height = self.alertContentContainer.frame.size.height-self.titleLabel.frame.size.height-[self totalButtonHeight]-20;
            if(messageFrame.size.height<originalSize.height) {
                UIScrollView *messageScrollView = [[UIScrollView alloc] initWithFrame:messageFrame];
                messageFrame.origin = CGPointZero;
                messageFrame.size = originalSize;
                self.messageLabel.frame = messageFrame;
                [messageScrollView setContentSize:originalSize];
                [messageScrollView addSubview:self.messageLabel];
                [self.alertContentContainer addSubview:messageScrollView];
            }
        }
    }
}

- (void)setButton:(UIButton *)button atHeight:(CGFloat)height {
    CGRect buttonFrame = button.frame;
    buttonFrame.origin = CGPointMake(0, height);
    buttonFrame.size.width = self.alertContentContainer.frame.size.width;
    button.frame = buttonFrame;
}

- (CGFloat) totalButtonHeight {
    __block CGFloat buttonHeight = 0;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        buttonHeight += (button.frame.size.height + self.buttonSpacing);
    }];
    buttonHeight -= self.buttonSpacing;
    return buttonHeight;
}

- (CGSize) calculateSize {
    CGFloat contentWidth = 250;
    
    CGFloat titleHeight;
    CGFloat messageHeight;
    
    if ([self.titleLabel.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // iOS7 methods
        CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:self.titleLabel.font}
                                                              context:nil];
        CGRect messageRect = [self.messageLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:self.messageLabel.font}
                                                                  context:nil];
        titleHeight = titleRect.size.height;
        messageHeight = messageRect.size.height;
    } else {
        // Pre-iOS7 methods
        titleHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
        messageHeight = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    }
    
    CGFloat buttonHeight = [self totalButtonHeight];
    CGFloat contentHeight = titleHeight + 10 + messageHeight + 10 + buttonHeight;
    if(self.maxHeight && contentHeight>self.maxHeight)
        return CGSizeMake(contentWidth, MAX(titleHeight + 10 + buttonHeight, self.maxHeight));
    else
        return CGSizeMake(contentWidth, contentHeight);
}

- (NSInteger) numberOfButtons {
    return (NSInteger)self.buttons.count;
}

- (void)setButtonShadow:(CGFloat) height {
    
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FUIButton *button = obj;
        
        button.shadowHeight = height;
        
    }];
}

- (void)setAlertCancelButtonColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor
{
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *button = obj;
        
        if (self.hasCancelButton && idx == 0) {

            FUIButton *cancelButton = (FUIButton *) button;
            
            cancelButton.buttonColor = normalColor;
            cancelButton.highlightedColor = highlightedColor;
            
        } else {

        }
    }];
}

- (void)show {
    self.alertContainer.alpha = 0;
    self.alertContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController && !topController.presentedViewController.isBeingDismissed) {
        topController = topController.presentedViewController;
    }
    UIView *rootView = topController.view;
    self.frame = rootView.bounds;
    
    [rootView addSubview:self];
    [rootView bringSubviewToFront:self];
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 1;
        self.alertContainer.alpha = 1;
        self.alertContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished0) {
        _visible = YES;
        if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [self.delegate didPresentAlertView:self];
        }
    }];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 0 || buttonIndex > (NSInteger)self.buttons.count) {
        return nil;
    }
    return [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] titleForState:UIControlStateNormal];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    //todo delegate
    
    _dismissButtonIndex = buttonIndex;
    
    self.alertContainer.transform = CGAffineTransformIdentity;
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if (self.onDismissAction) {
        self.onDismissAction();
    }
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 0;
        self.alertContainer.alpha = 0;
        self.alertContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _visible = NO;
        if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
            [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
        }
    }];
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    if (!title) return -1;
    if (!self.buttons) {
        self.buttons = [NSMutableArray array];
    }
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    button.cornerRadius = 3;

#warning Pls check again
    
    /*
    button.buttonColor = Color_Green_NavigationBar;
    button.shadowColor = Color_DarkGreen_NavigationBar;
    button.highlightedColor = Color_DarkGreen_NavigationBar;
    
    [button.titleLabel setFont:[UIFont flatFontOfSize:Font_Size_Normal]];
    */
    
//    button.shadowHeight = 2;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContentContainer addSubview:button];
    [self.buttons addObject:button];
    return (NSInteger)self.buttons.count-1;
}

- (void) buttonPressed:(FUIButton *)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:(NSInteger)index];
    }
    
    if (index == self.cancelButtonIndex && self.onCancelAction) {
        self.onCancelAction();
    } else if (index != self.cancelButtonIndex && self.onOkAction) {
        self.onOkAction();
    }
    
    [self dismissWithClickedButtonIndex:(NSInteger)index animated:YES];
}

- (void)clickButtonAtIndex:(NSInteger)buttonIndex {
    [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) setDefaultButtonFont:(UIFont *)defaultButtonFont {
    _defaultButtonFont = defaultButtonFont;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.titleLabel.font = defaultButtonFont;
    }];
}

- (void) setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        [button setTitleColor:defaultButtonTitleColor forState:UIControlStateNormal & UIControlStateHighlighted];
    }];
}

- (void) setDefaultButtonColor:(UIColor *)defaultButtonColor {
    _defaultButtonColor = defaultButtonColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.buttonColor = defaultButtonColor;
    }];
}

- (void) setDefaultButtonShadowColor:(UIColor *)defaultButtonShadowColor {
    _defaultButtonShadowColor = defaultButtonShadowColor;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowColor = defaultButtonShadowColor;
    }];
}

- (void) setDefaultButtonCornerRadius:(CGFloat)defaultButtonCornerRadius {
    _defaultButtonCornerRadius = defaultButtonCornerRadius;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.cornerRadius = defaultButtonCornerRadius;
    }];
}

- (void) setDefaultButtonShadowHeight:(CGFloat)defaultButtonShadowHeight {
    _defaultButtonShadowHeight = defaultButtonShadowHeight;
    [self.buttons enumerateObjectsUsingBlock:^(FUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowHeight = defaultButtonShadowHeight;
    }];
}

@end
