//
//  PlayScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"
#import "GoalTarget.h"

#import "AlgebraUtils.h"
#import "GameConfig.h"

#import "ScreenManager.h"
#import "BaseScreenLayer.h"

#import "PlayStatsModel.h"

#import "CCParticleSystem.h"

#import "LevelDataPlistParser.h"


#define PHYSICS_STEP_INC 2
#define PI 3.1415926536


#define BLOB_RADIUS 48
#define BLOB_SEGS 24

#define BLOB_X 192
#define BLOB_Y 200





@interface PlayScreenLayer : BaseScreenLayer {
	
	CGPoint *lastTouch;
	
	ChipmunkSpace *_space;
	ChipmunkMultiGrab *_multiGrab;
	JellyBlob *_blob;
	
	GoalTarget *goalTarget1;
	GoalTarget *goalTarget2;
	GoalTarget *goalTarget3;
	
	
	CCSprite *hudStarsSprite;
	CCSprite *scoreDisplaySprite;
	CCSprite *timeDisplaySprite;
	
	
	CCSprite *eyeSprite;
	CCSprite *mouthSprite;
	
	CCSprite *creatureSprite;
	
	CGPoint gibPos;
	
	CCParticleSystemPoint *particles;
	NSMutableArray *arrTargets;
	NSMutableArray *arrGibsShape;
	NSMutableArray *arrGibsSprite;
	NSMutableArray *arrTouchedEdge;
	
	CCSprite *axisSprite;
	cpBody *axisBody;
	
	CCSprite *anchorSprite;
	cpBody *anchorBody;
	
	CCMenuItemToggle *btnPlayPauseToggle;
    
	CCMenuItemImage *btnPauseToggle;
    
	int score_amt;
	BOOL _isCleared;
	
	cpFloat _edgeRad;
	int _cntTargets;
	
	cpBody *_rootBody;
	NSArray *_edgeBodies;
	
	//cpSimpleMotor *_motor;
	//cpSimpleMotor *_motor;
	//cpFloat _rate, _torq;
	//cpFloat _ctrl;
	
	//NSSet *_cpObjs;
	
	CCAction *splatExploAction;
	CCAction *splatDripsAction;
	
	
	int indLvl;
	
	int bg_cnt;
	
	
	LevelDataPlistParser *plistLvlData;

	
}

@property (nonatomic, readwrite) int score_amt;
@property (nonatomic, assign) cpFloat ctrl;
@property (nonatomic, retain) CCAction *splatExploAction;
@property (nonatomic, retain) CCAction *splatDripsAction;


-(id)initWithLevel:(int)lvl;

-(void) onBackMenu:(id)sender;
-(void) onLevelComplete:(id)sender;
-(void) onGameOver:(id)sender;
-(void) onPlayPauseToggle:(id)sender;
-(void) physicsStepper:(ccTime)dt;
-(void) chipmunkSetup;
-(void) scaffoldHUD;
-(void) debuggingSetup;
-(void) onResetArea:(id)sender;

- (void)setupSFX;
-(void) buildLvlObjs;

- (BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (BOOL)preSolveGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
- (void)postSolveGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
- (void)separateGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;


- (BOOL)beginWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (BOOL)preSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
- (void)postSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
- (void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

- (void)physProvoker:(id)sender;
-(void) mobWiggler:(id)sender;
- (void)clearArena:(id)sender;
-(void)addGib:(id)sender;
-(void)flashBG;



@end
