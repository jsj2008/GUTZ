//
//  StorySlidesLayer.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StorySlidesLayer.h"
#import "StorySlideSprite.h"
#import "ScreenManager.h"

#import "SimpleAudioEngine.h"

@implementation StorySlidesLayer

-(id)initWithStoryIndex:(int)ind slideCount:(int)cnt nextLvl:(int)lvl {
	
	if ((self = [super initWithBackround:@"bg_menu.png"])) {
		NSLog(@"%@.initWithStoryIndex(%d, %d, %d)", [self class], ind, cnt, lvl);
		
		self.isTouchEnabled = YES;
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		CGPoint ptCtr = CGPointMake((int)(wins.width * 0.5), (int)(wins.height * 0.5));

		_indSlide = 0;
		_indStory = ind;
		_totSlides = cnt;
		_isMoving = NO;
		_nextLvl = lvl;
		
		_ptSlideOrg = ptCtr;
		
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.875f];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"fpo_ffvi_cursor2.mp3"];
		
		_holderSprite = [CCSprite node];
		[_holderSprite setPosition:_ptSlideOrg];
		[self addChild:_holderSprite];
		
		
		NSMutableArray *arrSlides = [[NSMutableArray alloc] initWithCapacity:_totSlides];
		
		for (int i=0; i<_totSlides; i++) {
			//NSLog(@" --MAKE SLIDE--> [%d][%d] (%@)", _indStory, i, [NSString stringWithFormat:@"fpo_slide_%02d-%02d.jpg", _indStory, i]);
			
			StorySlideSprite *slideSprite = [[StorySlideSprite alloc] initWithFile:[NSString stringWithFormat:@"fpo_slide_%02d-%02d.jpg", _indStory, i]];
			[slideSprite setPosition:ccp(i * wins.width, 0)];
			
			[arrSlides addObject:slideSprite];
			[_holderSprite addChild:slideSprite z:i tag:i];
		}
	}
	
	return (self);
}


-(void)slidesComplete {
	NSLog(@"-/> %@.slidesComplete() </-", [self class]);
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	CGPoint ptCtr = CGPointMake((int)(wins.width * 0.5), (int)(wins.height * 0.5));
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"debug_healmag.wav"];
	
	CCMenuItemImage *btnClose = [CCMenuItemImage itemFromNormalImage:@"btn_replay.png" selectedImage:@"btn_replayActive.png" target:self selector:@selector(onCloseSlides:)];
	[btnClose setScale:0.0f];
	
	CCMenu *menu = [CCMenu menuWithItems:btnClose, nil];
	[menu setPosition:ccp(ptCtr.x, 64.0f)];
	[self addChild:menu];
	
	id action = [CCScaleTo actionWithDuration:0.125f scale:1.0f];
	[btnClose runAction:action];
}


-(void)onCloseSlides:(id)sender {
	//NSLog(@"-/> %@.onCloseSlides() </-", [self class]);
	
	if (_indStory > 1)
		[ScreenManager goLevelSelect:_nextLvl];
	
	else
		[ScreenManager goPlay:_nextLvl];
}


-(void)registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:NO];
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	_ptTouchStart = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	if (_state != kCCMenuStateWaiting)
		return (NO);
	
	_state = kCCMenuStateTrackingTouch;
	return (YES);
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	
	if (_isMoving) {
		_isMoving = NO;
		
		if (_totSlides > 1 && (kTransThreshold < abs(_distOffset))) {
			//bool isForward = (_distOffset < 0);// ? true : false;
			
			if ((_distOffset < 0) && (_totSlides > _indSlide + 1))
				_indSlide++;
			
			//else if (!isForward && (_indSlide > 0))
			//	_indSlide--;
		}
		
		[self moveToCurrentPage];
	}
	
	_state = kCCMenuStateWaiting;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	_ptTouchStop = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	_distOffset = _ptTouchStop.x - _ptTouchStart.x;
	
	if (_distOffset < 0) {
		[_holderSprite setPosition:[self calcSlidePos:_distOffset]];
		_isMoving = YES;
	}
}


-(void)moveToCurrentPage {
	//NSLog(@"-/> %@.%moveToCurrentPage(%d/%d) </-", [self class], _indSlide, _totSlides);
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"fpo_ffvi_cursor2.mp3"];
	
	id action = [CCMoveTo actionWithDuration:(kSpdAnimation * 0.5f) position:[self calcSlidePos]];
	[_holderSprite runAction:action];
	
	
	if (_indSlide == _totSlides - 1)
		[self slidesComplete];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	_state = kCCMenuStateWaiting;
}



-(CGPoint)calcSlidePos {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return (CGPointMake((_ptSlideOrg.x - (_indSlide * winSize.width)), _ptSlideOrg.y));
}

-(CGPoint)calcSlidePos:(float)offset {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return (CGPointMake((_ptSlideOrg.x - (_indSlide * winSize.width) + offset), _ptSlideOrg.y));
}


/*
-(float)getSwipeDeadZone {
	return fMoveDeadZone;
}

-(void)setSwipeDeadZone:(float)fValue {
	fMoveDeadZone = fValue;
}
*/

-(void)dealloc {
	[super dealloc];
}


@end
