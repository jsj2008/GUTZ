//
//  StorySlidesLayer.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseScreenLayer.h"
#import "cocos2d.h"

#define kSpdAnimation 0.5f
#define kTransThreshold 10

@interface StorySlidesLayer : BaseScreenLayer {
	
	int _nextLvl;
	int _indStory;
	int _indSlide;
	int _totSlides;
	
	CCSprite *_holderSprite;
	
	float _distOffset;
	tCCMenuState _state;
	BOOL _isMoving;
	
	CGPoint _ptSlideOrg;
	CGPoint _ptTouchStart;
	CGPoint _ptTouchStop;
}

-(id)initWithStoryIndex:(int)ind slideCount:(int)cnt nextLvl:(int)lvl;

-(void)moveToCurrentPage;
-(void)slidesComplete;
-(void)onCloseSlides:(id)sender;

//-(CGPoint)calcSlidePosWithOffset:(float)offset;
-(CGPoint)calcSlidePos;
-(CGPoint)calcSlidePos:(float)offset;

//-(float)getSwipeDeadZone;
//-(void)setSwipeDeadZone:(float)fValue;


/*
@property (nonatomic, readwrite) CGPoint ptSlideOrg;
@property (nonatomic, readwrite) CGPoint ptTouchStart;
@property (nonatomic, readwrite) CGPoint ptTouchStop;

@property (nonatomic, readwrite) BOOL isMoving;
@property (nonatomic, readwrite) float fMoveDelta;
@property (nonatomic, readwrite) float fMoveDeadZone;
@property (nonatomic, readwrite) float fAnimSpeed;
*/

@end
