//
//  PullToRefreshTableView.m
//  MySpot
//
//  Created by jin on 5/17/13.
//  Copyright (c) 2013 wang. All rights reserved.
//

#import "PullToRefreshTableView.h"

@implementation PullToRefreshTableView
@synthesize _refreshHeaderView;
@synthesize tableDelegate;

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

- (void)initPullToRefreshTableView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
		view.delegate = self;
		[self addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) changeColorTableHeaderView : (UIColor *) color
{
    [_refreshHeaderView changeColorTheme:color];
}

- (void) changeStatusLabelFont : (UIFont *) font
{
    [_refreshHeaderView changeStatusLabelFont:font];
}

- (void) changeLastUpdatedLabelFont : (UIFont *) font
{
    [_refreshHeaderView changeLastUpdatedLabelFont:font];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    if ( self.tableDelegate != nil && [self.delegate respondsToSelector:@selector(refreshTableView)] ) {
        [self.tableDelegate performSelector:@selector(refreshTableView)];
    }
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
