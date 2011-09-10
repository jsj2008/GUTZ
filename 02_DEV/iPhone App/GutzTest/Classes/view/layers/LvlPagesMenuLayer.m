#import "LvlPagesMenuLayer.h"
#import "LevelSelectScreenLayer.h"

@implementation LvlPagesMenuLayer

@synthesize padding;
@synthesize menuOrigin;
@synthesize touchOrigin;
@synthesize touchStop;
@synthesize bMoving;
@synthesize bSwipeOnlyOnMenu;
@synthesize	fMoveDelta;
@synthesize fMoveDeadZone;
@synthesize iItemsPerPage;
@synthesize iColsPerPage;
@synthesize iRowsPerPage;

@synthesize iPageCount;
@synthesize iCurrentPage;
@synthesize bVerticalPaging;
@synthesize fAnimSpeed;


+(id) menuWithArray:(NSMutableArray *)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad {
    NSLog(@"-/> %@.%@() </-", [self class], @"menuWithArray");
    
	return [[[self alloc] initWithArray:items cols:cols rows:rows position:pos padding:pad] autorelease];
}



-(id) initWithArray:(NSMutableArray *)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad {
    NSLog(@"-/> %@.%@() </-", [self class], @"initWithArray");
    
	if ((self = [super init])) {
		self.isTouchEnabled = YES;
        
        itemHolderSprite = [CCSprite node];
		
		int z = 1;
		for (id item in items) {
            [itemHolderSprite addChild:item z:z tag:z];
			++z;
		}
		
        
        [self addChild:itemHolderSprite];
        
		iColsPerPage = cols;
		iRowsPerPage = rows;
		
		padding = pad;
		iItemsPerPage = cols * rows;
		iCurrentPage = 0;
		bMoving = false;
		bSwipeOnlyOnMenu = false;
		menuOrigin = pos;
		fMoveDeadZone = 10;
		//bVerticalPaging = vertical;
		fAnimSpeed = 1;
		
		
		[self buildGrid:cols rows:rows];
		//(bVerticalPaging) ? [self buildGridVertical:cols rows:rows] : [self buildGrid:cols rows:rows];
		[self addPageLEDs];
        
        itemHolderSprite.position = menuOrigin;
		
		
		float delayTime = 0.1f;
		int action_cnt = 0;
		
		for (CCMenuItem *itm in [itemHolderSprite children]) {
			itm.scaleX = 0.0f;
			itm.scaleY = 0.0f;
			
			CCAction *action = [CCSequence actions: 
				[CCDelayTime actionWithDuration: delayTime], 
				[CCScaleTo actionWithDuration:0.25f scale:1.0], 
				nil];
			
			[itm runAction: action];
			
			action_cnt++;
			
			if (action_cnt == iItemsPerPage) {
				action_cnt = 0;
				delayTime = 0.1f;
			
			} else
				delayTime += 0.1f;
		}
	}
	
	return self;
}

-(void) dealloc {
	[super dealloc];
}

-(void) buildGrid:(int)cols rows:(int)rows {
    NSLog(@"-/> %@.%@(cols:%d rows:%d) </-", [self class], @"buildGrid", cols, rows);
	
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	int col = 0, row = 0;
    for (CCMenuItem* item in itemHolderSprite.children) {
        
		// Calculate the position of our menu item. 
		item.position = CGPointMake(self.position.x + col * padding.x + (iPageCount * winSize.width), self.position.y - row * padding.y);
		
		// Increment our positions for the next item(s).
		++col;
		if (col == cols) {
			col = 0;
			++row;
			
			if (row == rows) {
				iPageCount++;
				col = 0;
				row = 0;
			}
		}
	}
}

-(void) addPageLEDs {
    
    int xPos = -17 * (iPageCount / 2);
    
    pagesSprite = [CCSprite node];
    [pagesSprite setPosition:CGPointMake(157, 30)];
    
    ledFillSprite = [CCSprite spriteWithFile:@"paginationActive.png"];
    [ledFillSprite setPosition:CGPointMake(xPos, 0)];
    
    
    for (int i=0; i<iPageCount; i++) {
        CCSprite *ledBaseSprite = [CCSprite spriteWithFile:@"pagination_nonActive.png"];
        [ledBaseSprite setPosition:CGPointMake(xPos, 0)];
        
        [pagesSprite addChild:ledBaseSprite];
        xPos += 17;
    }
    
    [pagesSprite addChild:ledFillSprite];
    [self addChild:pagesSprite];
}

-(void) addChild:(CCMenuItem*)child z:(int)z tag:(int)aTag {
	return [super addChild:child z:z tag:aTag];
}

-(CCMenuItem*) GetItemWithinTouch:(UITouch*)touch {
	// Get the location of touch.
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
	
	// Parse our menu items and see if our touch exists within one.
    for (CCMenuItem* item in [itemHolderSprite children]) {
        
		
		CGPoint local = [item convertToNodeSpace:touchLocation];
		CGRect r = [item rect];
		r.origin = CGPointZero;
		
		// If the touch was within this item. Return the item.
		if (CGRectContainsPoint(r, local)) {
			return item;
		}
	}
	
	// Didn't touch an item.
	return nil;
}

-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	// Convert and store the location the touch began at.
	touchOrigin = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	// If we weren't in "waiting" state bail out.
	if (state != kCCMenuStateWaiting) {
		return NO;
	}
	
	// Activate the menu item if we are touching one.
	selectedItem = [self GetItemWithinTouch:touch];
    //selectedItem = [itemHolderSprite GetItemWithinTouch:touch];
	[selectedItem selected];
	
	// Only track touch if we are either in our menu system or dont care if they are outside of the menu grid.
	if (!bSwipeOnlyOnMenu || (bSwipeOnlyOnMenu && selectedItem)) {
		state = kCCMenuStateTrackingTouch;
		return YES;
	}
	
	return NO;
}

// Touch has ended. Process sliding of menu or press of menu item.
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	// User has been sliding the menu.
	
    if(bMoving) {
		bMoving = false;
		
		// Do we have multiple pages?
		if (iPageCount > 1 && (fMoveDeadZone < abs(fMoveDelta))) {
			// Are we going forward or backward?
			bool bForward = (fMoveDelta < 0) ? true : false;
			
			// Do we have a page available?
			if (bForward && (iPageCount>iCurrentPage+1)) {
				// Increment currently active page.
				iCurrentPage++;
			} else if (!bForward && (iCurrentPage > 0)) {
				// Decrement currently active page.
				iCurrentPage--;
			}
		}
        

		// Start sliding towards the current page.
		[self moveToCurrentPage];			
		
	}
	// User wasn't sliding menu and simply tapped the screen. Activate the menu item.
	else {
		[selectedItem unselected];
		[selectedItem activate];
	}

	// Back to waiting state.
	state = kCCMenuStateWaiting;
}

// Run the action necessary to slide the menu grid to the current page.
- (void) moveToCurrentPage {
    NSLog(@"-/> %@.%@() </-", [self class], @"moveToCurrentPage");
	
	// Perform the action
	id action = [CCMoveTo actionWithDuration:(fAnimSpeed*0.5) position:[self GetPositionOfCurrentPage]];
    [itemHolderSprite runAction:action];
    
    int xPos = (-17 * (iPageCount / 2)) + (iCurrentPage * 17);
    [ledFillSprite setPosition:CGPointMake(xPos, 0)];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	[selectedItem unselected];
	
	state = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	// Calculate the current touch point during the move.
	touchStop = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

	// Distance between the origin of the touch and current touch point.
	fMoveDelta = (bVerticalPaging) ? (touchStop.y - touchOrigin.y) : (touchStop.x - touchOrigin.x);

	// Set our position.
    [itemHolderSprite setPosition:[self GetPositionOfCurrentPageWithOffset:fMoveDelta]];
	bMoving = true;
}

- (CGPoint) GetPositionOfCurrentPage {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return (bVerticalPaging) ?
		CGPointMake(menuOrigin.x,menuOrigin.y-(iCurrentPage*winSize.height))
		: CGPointMake((menuOrigin.x-(iCurrentPage*winSize.width)),menuOrigin.y);
}

- (CGPoint) GetPositionOfCurrentPageWithOffset:(float)offset {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return (bVerticalPaging) ?
	CGPointMake(menuOrigin.x,menuOrigin.y-(iCurrentPage*winSize.height)+offset)
	: CGPointMake((menuOrigin.x-(iCurrentPage*winSize.width)+offset),menuOrigin.y);
}



// Returns whether or not we should only allow swiping on the actual grid.
- (bool) IsSwipingOnMenuOnlyEnabled {
	return bSwipeOnlyOnMenu;
}

// Sets the ability to swipe only on the menu or utilize entire screen for swiping.
- (void) SetSwipingOnMenuOnly:(bool)bValue {
	bSwipeOnlyOnMenu = bValue;
}

// Returns the swiping dead zone. 
- (float) GetSwipeDeadZone {
	return fMoveDeadZone;
}

- (void) SetSwipeDeadZone:(float)fValue {
	fMoveDeadZone = fValue;
}


@end