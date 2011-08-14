//
//  LvlPagesMenuSprite.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LvlPagesMenuSprite : CCLayer {
    
	tCCMenuState state; // State of our menu grid. (Eg. waiting, tracking touch, cancelled, etc)
	CCMenuItem *selectedItem; // Menu item that was selected/active.
	CCSprite *itemHolderSprite;
    CCSprite *pagesSprite;
    CCSprite *ledFillSprite;
    
	CGPoint padding; // Padding in between menu items. 
	CGPoint menuOrigin; // Origin position of the entire menu grid.
	CGPoint touchOrigin; // Where the touch action began.
	CGPoint touchStop; // Where the touch action stopped.
	
	int iItemsPerPage;
	int iPageCount; // Number of pages in this grid.
	int iCurrentPage; // Current page of menu items being viewed.
	
	int iColsPerPage;
	int iRowsPerPage;
	
	bool bMoving; // Is the grid curr-ently moving?
	bool bSwipeOnlyOnMenu; // Causes swiping functionality to only work when siping on top of the menu items instead of entire screen.
	bool bVerticalPaging; // Disabled by default. Allows for pages to be scrolled vertically instead of horizontal.
	
	float fMoveDelta; // Distance from origin of touch and current frame.
	float fMoveDeadZone; // Amount they need to slide the grid in order to move to a new page.
	float fAnimSpeed; // 0.0-1.0 value determining how slow/fast to animate the paging.
}

+(id) menuWithArray:(NSMutableArray*)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad;
-(id) initWithArray:(NSMutableArray*)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad;


-(void) buildGrid:(int)cols rows:(int)rows;
-(void) moveToCurrentPage;

-(void) addPageLEDs;

-(CCMenuItem *) GetItemWithinTouch:(UITouch*)touch;
-(CGPoint) GetPositionOfCurrentPageWithOffset:(float)offset;
-(CGPoint) GetPositionOfCurrentPage;

-(bool) IsSwipingOnMenuOnlyEnabled;
-(void) SetSwipingOnMenuOnly:(bool)bValue;

-(float) GetSwipeDeadZone;
-(void) SetSwipeDeadZone:(float)fValue;


@property (nonatomic, readwrite) CGPoint padding;
@property (nonatomic, readwrite) CGPoint menuOrigin;
@property (nonatomic, readwrite) CGPoint touchOrigin;
@property (nonatomic, readwrite) CGPoint touchStop;
@property (nonatomic, readwrite) int iItemsPerPage;
@property (nonatomic, readwrite) int iColsPerPage;
@property (nonatomic, readwrite) int iRowsPerPage;
@property (nonatomic, readwrite) int iPageCount;
@property (nonatomic, readwrite) int iCurrentPage;
@property (nonatomic, readwrite) bool bMoving;
@property (nonatomic, readwrite) bool bSwipeOnlyOnMenu;
@property (nonatomic, readwrite) bool bVerticalPaging;
@property (nonatomic, readwrite) float fMoveDelta;
@property (nonatomic, readwrite) float fMoveDeadZone;
@property (nonatomic, readwrite) float fAnimSpeed;

@end
