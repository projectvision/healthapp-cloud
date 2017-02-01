//
//  PullToRefreshTableView.h
//  MySpot
//
//  Created by jin on 5/17/13.
//  Copyright (c) 2013 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol RefreshTableViewDelegate <NSObject>

- (void) refreshTableView;

@end

@interface PullToRefreshTableView : UITableView<EGORefreshTableHeaderDelegate>
{
	EGORefreshTableHeaderView *_refreshHeaderView;
    
	BOOL _reloading;
}

@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic, assign) id<RefreshTableViewDelegate> tableDelegate;

- (void)initPullToRefreshTableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)changeColorTableHeaderView : (UIColor *) color;
- (void) changeStatusLabelFont : (UIFont *) font;
- (void) changeLastUpdatedLabelFont : (UIFont *) font;

@end
