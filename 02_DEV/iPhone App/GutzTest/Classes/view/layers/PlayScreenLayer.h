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
#import "StartTarget.h"
#import "CheckTarget.h"
#import "PointTarget.h"
#import "StarGoalTarget.h"
#import "GoalTarget.h"
#import "RangedTrap.h"
#import "DartEmitter.h"
#import "Pinwheel.h"
#import "HealthTarget.h"
#import "BaseWall.h"
#import "SpikedWall.h"
#import "ConveyorBelt.h"


#import "AlgebraUtils.h"
#import "GameConfig.h"

#import "ScreenManager.h"
#import "BaseScreenLayer.h"

#import "PlayStatsModel.h"

#import "CCParticleSystem.h"

#import "LevelDataPlistParser.h"


#define PHYSICS_STEP_INC 2
#define PI 3.1415926536


#define BLOB_RADIUS 32
#define BLOB_SEGS 32

#define BLOB_X 250
#define BLOB_Y 415





@interface PlayScreenLayer : BaseScreenLayer {
	
	CGPoint *lastTouch;
	CGPoint _ptViewOffset;
	
	ChipmunkSpace *_space;
	ChipmunkMultiGrab *_multiGrab;
	JellyBlob *_blob;
	
	StartTarget *_startTarget;
	GoalTarget *_goalTarget;
	NSMutableArray *arrCheckTargets;
	
	CCSprite *hudStarsSprite;
	CCSprite *scoreDisplaySprite;
	CCSprite *timeDisplaySprite;
	
	cpVect gibPos;
	cpVect vHitCoords;
	cpVect vHitForce;
	
	CCParticleSystemPoint *particles;
	NSMutableArray *arrGibsShape;
	NSMutableArray *arrHealths;
	NSMutableArray *arrPickups;
	NSMutableArray *arrGibsSprite;
	NSMutableArray *arrTouchedEdge;
	NSMutableArray *arrTraps;
	NSMutableArray *arrDartEmitters;
	NSMutableArray *arrDarts;
	NSMutableArray *arrPinwheels;
	NSMutableArray *arrConveyors;
	
	NSMutableArray *_arrGibs;
	
	NSMutableArray *_arrDrawPts;
	
	CCSprite *axisSprite;
	cpBody *axisBody;
	
	CCSprite *anchorSprite;
	cpBody *anchorBody;
	
	CCMenuItemToggle *btnPlayPauseToggle;
    
	CCMenuItemImage *btnPauseToggle;
    
	int score_amt;
	BOOL _isCleared;
	BOOL _isBonus;
	BOOL _isWallSFX;
	BOOL _isDrawing;
	BOOL _isPanning;
	
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
-(void)toggleCollisions:(BOOL)isEnabled;
-(void) chipmunkSetup;
-(void) scaffoldHUD;
-(void) debuggingSetup;
-(void) onResetArea:(id)sender;

-(void)resetWallSFX:(id)sender;

- (void)setupSFX;
-(void) buildLvlObjs;



-(BOOL)beginDartCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateDartCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

-(BOOL)beginTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

-(BOOL)beginSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

-(BOOL)beginCheckGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateCheckGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

-(BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;


-(BOOL)beginWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(BOOL)preSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
-(void)postSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace* )space;
-(void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

-(void)physProvoker:(id)sender;
-(void) mobWiggler:(id)sender;
-(void)clearArena:(id)sender;
-(void)restartArena:(id)sender;
-(void)addGib:(id)sender;
-(void)onGibsExpiry:(id)sender;
-(void)flashBG;

@end
