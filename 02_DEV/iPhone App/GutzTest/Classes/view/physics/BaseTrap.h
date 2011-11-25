//
//  BaseTrap.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#define BASE_RADIUS 16.0f
#define TRAP_INTERVAL 0.43f

@interface BaseTrap : BasePhysicsSprite <ChipmunkObject> {
	int ind;
	BOOL isCovered;
	BOOL isCleared;
	BOOL _isFrame1;
	
	CCSprite *_frame1Sprite;
	CCSprite *_frame2Sprite;
	
	NSTimer *_frameTimer;
}

-(id)initAtPos:(CGPoint)pos;
-(void)updateCovered:(BOOL)covered;
-(void)onFrameChange:(id)sender;

@property (nonatomic) int ind;
@property (nonatomic) BOOL isCovered;
@property (nonatomic) BOOL isCleared;

@end
