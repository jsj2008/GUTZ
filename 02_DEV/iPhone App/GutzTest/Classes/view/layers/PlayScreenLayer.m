//
//  PlayScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "GameConsts.h"
#import "CreatureConsts.h"

#import "ChipmunkDebugNode.h"
#import "PlayScreenLayer.h"

#import "LvlStarSprite.h"
#import "ScoreSprite.h"
#import "ElapsedTimeSprite.h"


#import "CreatureNodeVO.h"
#import "VisceraVO.h"

#import "RandUtils.h"
#import "GeomUtils.h"
#import "GoalTarget.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#import "BaseGibs.h"


static NSString *borderType = @"borderType";

@implementation PlayScreenLayer


@synthesize score_amt;
@synthesize ctrl = _ctrl;

@synthesize splatExploAction;
@synthesize splatDripsAction;


#pragma mark INIT

-(id)initWithLevel:(int)lvl {
	NSLog(@"%@.initWithLevel(%d)", [self class], lvl);
	
	indLvl = lvl;
	
	if (indLvl > kLastLvl)
		indLvl = 1;
	
	return ([self init]);
}



-(id) init {
	NSLog(@"%@.init()", [self class]);
	
	//if ((self = [super initWithColor:ccc4(ARENA_BG.r, ARENA_BG.g, ARENA_BG.b, 255)])) {
	if ((self = [super initWithBackround:@"background_4.jpg"])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		[self setupSFX];
		
		
		//[[SimpleAudioEngine sharedEngine] playEffect:@"debug_healmag.wav"];
		
		_isBonus = NO;
		_isCleared = NO;
		_isWallSFX = NO;
		
		arrTouchedEdge = [[NSMutableArray alloc] init];
		
		[self chipmunkSetup];
		[self buildLvlObjs];
		[self scaffoldHUD];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UPD_LVL" object:[[NSNumber alloc] initWithInt:indLvl]];
		
		[self performSelector:@selector(physProvoker:) withObject:self afterDelay:0.33f];
		
		//[self setPosition:CGPointMake(50, 50)];
	}
	
	return (self);
}

- (void)setupSFX {
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_noise-01.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_noise-02.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_light_splat.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_big_stretch.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_long_stretch.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_finish_splatter.mp3"];
	
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95];
}



#pragma Arena Setup

-(void)buildLvlObjs {
	
	plistLvlData = [[LevelDataPlistParser alloc] initWithLevel:indLvl];
	
	//NSLog(@"goals:[%@]", plistLvlData.arrGoalData);
	//NSLog(@"walls:[%@]", plistLvlData.arrWallData);
	
	
	arrTargets = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrGoalData count]];
	[arrTargets addObject:@"NO"];
	[arrTargets addObject:@"NO"];
	[arrTargets addObject:@"NO"];
	
	int ind = 0;
	
	for (NSDictionary *dictGoal in plistLvlData.arrGoalData) {
		CGPoint goalPos = CGPointMake([[dictGoal objectForKey:@"x"] floatValue], [[dictGoal objectForKey:@"y"] floatValue]);
		//NSLog(@"[%d]: [%@]-(%f, %f)", ind, [dictGoal objectForKey:@"x"], goalPos.x, goalPos.y);
		
		[arrTargets addObject:@"NO"];
		
		switch ([[dictGoal objectForKey:@"type"] intValue]) {
			
			case 1:
				if (ind == 0) {
					goalTarget1 = [[GoalTarget alloc] initAtPos:goalPos];
					goalTarget1.ind = ind;
					[_space add:goalTarget1];
					//[self addChild:goalTarget1._sprite];		
					
				} else {
					goalTarget2 = [[GoalTarget alloc] initAtPos:goalPos];
					goalTarget2.ind = ind;
					[_space add:goalTarget2];
					[self addChild:goalTarget2._sprite];
				}
				
				ind++;
				break;
				
			case 2:
				_starGoalTarget = [[StarGoalTarget alloc] initAtPos:goalPos];//cpv((CCRANDOM_0_1() * 280) + 16, (CCRANDOM_0_1() * 400) + 32)];
				_starGoalTarget.ind = 2;
				[_space add:_starGoalTarget];
				[self addChild:_starGoalTarget._sprite];
				break;
		}
	}
	
	for (NSDictionary *dictWall in plistLvlData.arrWallData) {
		
		SpikedWall *wall = [[SpikedWall alloc] initAtPos:CGPointMake([[dictWall objectForKey:@"x"] floatValue], [[dictWall objectForKey:@"y"] floatValue]) large:[[dictWall objectForKey:@"type"] intValue]-1 spikes:[[dictWall objectForKey:@"spikes"] intValue] rotation:0 friction:[[dictWall objectForKey:@"frict"] floatValue] bounce:[[dictWall objectForKey:@"bounce"] floatValue]];
		[wall spaceRef:_space];
		[wall makeSpikes];
		
		[self addChild:wall._sprite];
		[_space add:wall];
	}
	
	for (NSDictionary *dictStud in plistLvlData.arrStudData) {
		
		CGPoint studPos = CGPointMake([[dictStud objectForKey:@"x"] floatValue], [[dictStud objectForKey:@"y"] floatValue]);
		cpFloat studRad = [[dictStud objectForKey:@"radius"] floatValue];
		cpFloat frict = [[dictStud objectForKey:@"frict"] floatValue];
		cpFloat bounce = [[dictStud objectForKey:@"bounce"] floatValue];
		
		
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body.pos = studPos;
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"cog.png"];
		[sprite setPosition:body.pos];
		[self addChild:sprite];
		
		ChipmunkStaticPolyShape *shape = [_space add:[ChipmunkStaticCircleShape circleWithBody:body radius:studRad offset:cpvzero]];
		shape.friction = frict;
		shape.elasticity = bounce;
		shape.data = sprite;
	}
	
	/*
	ChipmunkBody *polyBody;
	ChipmunkPolyShape *polyShape;
	
	cpVect polyVerts1[] = {
		cpv(0.0, 30.0), 
		cpv(70.0, 0.0),
		cpv(55.0, -15.0), 
		cpv(0.0, -15.0)
	};
	
	cpVect polyVerts2[] = {
		cpv(0.0, 0.0), 
		cpv(30.0, 80.0),
		cpv(25.0, 0.0), 
		cpv(0.0, -15.0)
	};
	
	polyBody = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
	polyBody.pos = cpv(100, 160);
	
	polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts1 offset:cpvzero];
	polyShape.friction = 0.5;
	polyShape.elasticity = 0.1;
	//[_space add:polyShape];
	
	polyBody = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
	polyBody.pos = cpv(290, 120);
	
	polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts2 offset:cpvzero];
	polyShape.friction = 0.5;
	polyShape.elasticity = 0.1;
	//[_space add:polyShape];
	*/
	
	arrTraps = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrTrapData count]];
	for (NSDictionary *dictTrap in plistLvlData.arrTrapData) {
		
		int trapType = [[dictTrap objectForKey:@"type"] intValue];
		CGPoint trapPos = CGPointMake([[dictTrap objectForKey:@"x"] floatValue], [[dictTrap objectForKey:@"y"] floatValue]);
		CGPoint trapRange = CGPointMake([[dictTrap objectForKey:@"min"] floatValue], [[dictTrap objectForKey:@"max"] floatValue]);
		float trapSpeed = [[dictTrap objectForKey:@"speed"] floatValue];
		
		RangedTrap *trap = [[RangedTrap alloc] initAtPos:trapPos vertical:(int)(trapType - 1) speed:trapSpeed range:trapRange];
		
		[arrTraps addObject:trap];
		[_space add:trap];
		[self addChild:trap._sprite];
	}
	
	
	arrDartEmitters = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrDartData count]];
	for (NSDictionary *dictDartEmitter in plistLvlData.arrDartData) {
		
		CGPoint dartPos = CGPointMake([[dictDartEmitter objectForKey:@"x"] floatValue], [[dictDartEmitter objectForKey:@"y"] floatValue]);
		DartEmitter *dartEmitter = [[DartEmitter alloc] initAtPos:dartPos fires:[[dictDartEmitter objectForKey:@"type"] intValue] freq:[[dictDartEmitter objectForKey:@"interval"] floatValue] speed:[[dictDartEmitter objectForKey:@"speed"] floatValue]];
		
		[dartEmitter spaceRef:_space];
		[dartEmitter layerRef:self];
		[arrDartEmitters addObject:dartEmitter];
		[_space add:dartEmitter];
		[self addChild:dartEmitter._sprite];
		[dartEmitter toggleFiring:YES];
	}
	
	if ([arrDartEmitters count] > 0)
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDartFired:) name:@"FIRE_DART" object:nil];
	
	
	ChipmunkBody *boxBody = [_space add:[ChipmunkBody bodyWithMass:100 andMoment:cpMomentForBox(100, 30, 10)]];
	boxBody.pos = cpv(190, 190);
	ChipmunkPolyShape *boxShape = [_space add:[ChipmunkPolyShape boxWithBody:boxBody width:30 height:10]];
	boxShape.friction = 0.7;
	
	///ChipmunkConstraint *boxMotor = [_space add:[ChipmunkSimpleMotor simpleMotorWithBodyA:[ChipmunkBody staticBody] bodyB:boxBody rate:CC_DEGREES_TO_RADIANS(360)]];
	
	
	ConveyorBelt *conveyorBelt = [[ConveyorBelt alloc] initAtPos:cpv(220, 190) width:200 speed:-4];
	[_space add:conveyorBelt];
	[self addChild:conveyorBelt._sprite];
	
	arrPinwheels = [[NSMutableArray alloc] init];
	Pinwheel *pinwheel = [[Pinwheel alloc] initAtPos:cpv(250, 310) spinsClockwise:YES speed:2.33f];
	[pinwheel spaceRef:_space];
	[arrPinwheels addObject:pinwheel];
	
	[_space add:pinwheel];
	[self addChild:pinwheel._sprite];
		
	_blob = [[JellyBlob alloc] initWithPos:goalTarget1._sprite.position radius:BLOB_RADIUS count:BLOB_SEGS];
	[_blob adoptSprites:self];
	[_space add:_blob];
}

-(void)setPosition:(CGPoint)position {
	//[[StandardGameController sharedSingleton] setViewpointCenter:position];
	[super setPosition:position];
}

-(void) scaffoldHUD {
	
	CCMenuItemImage *btnPause = [CCMenuItemImage itemFromNormalImage:@"btn_pause.png" selectedImage:@"btn_pauseActive.png" target:nil selector:nil];
	CCMenuItemImage *btnPlay = [CCMenuItemImage itemFromNormalImage:@"btn_pause.png" selectedImage:@"btn_pauseActive.png" target:nil selector:nil];
	btnPlayPauseToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPlayPauseToggle:) items:btnPause, btnPlay, nil];
	CCMenu *mnuPlayPause = [CCMenu menuWithItems: btnPlayPauseToggle, nil];
	
	mnuPlayPause.position = ccp(280, 440);
	[mnuPlayPause alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuPlayPause];
	
	
	scoreDisplaySprite = [[ScoreSprite alloc] init];
	[scoreDisplaySprite setPosition:ccp(55, 450)];
	[self addChild:scoreDisplaySprite];
	
	if (kShowDebugMenus)
		[self debuggingSetup];
}


-(void) debuggingSetup {
	CCMenuItemFont *reset = [CCMenuItemFont itemFromString:@"reset" target:self selector: @selector(onResetArea:)];
	CCMenuItemFont *levelComplete = [CCMenuItemFont itemFromString:@"win" target:self selector: @selector(onLevelComplete:)];
	CCMenuItemFont *gameOver = [CCMenuItemFont itemFromString:@"end" target:self selector: @selector(onGameOver:)];
	CCMenu *mnuDebug = [CCMenu menuWithItems: reset, levelComplete, gameOver, nil];
	
	mnuDebug.position = ccp(160, 150);
	[mnuDebug alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuDebug];
}

-(void)onDartFired:(NSNotification *)notification {
	NSLog(@"onDartFired");
	
	Dart *dart = (Dart *)[notification object];
	[arrDarts addObject:dart];
	
	[_space add:dart];
	[self addChild:dart._sprite];
}

#pragma mark PhysicsEngine

-(void) chipmunkSetup {
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	//CGPoint winsMidPt = CGPointMake(wins.width * 0.5f, wins.height * 0.5f);
	
	NSLog(@"SCREEN SIZE:[%f, %f]", wins.width, wins.height);
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, 0);
	_space.gravity = cpv(0, -320);
	
	
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	
	_multiGrab = [[ChipmunkMultiGrab alloc] initForSpace:_space withSmoothing:cpfpow(0.8, 60.0) withGrabForce:30000];
	_multiGrab.layers = GRABABLE_LAYER;
	
	if (kDrawChipmunkObjs == 1)
		[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space] z:0 tag:666];
	
	arrGibsShape = [[NSMutableArray alloc] init];
	arrGibsSprite = [[NSMutableArray alloc] init];
	
	_arrGibs = [[NSMutableArray alloc] init];
	arrDarts = [[NSMutableArray alloc] init];
	
	creatureSprite = [CCSprite spriteWithFile:@"test.png"];
	[creatureSprite setPosition:ccp(BLOB_X, BLOB_Y)];
	[creatureSprite setScale:0.33f];
	//[self addChild:creatureSprite];
	
	/*
	eyeSprite = [CCSprite spriteWithFile:@"eye.png"];
	[eyeSprite setPosition:cpv(BLOB_X, BLOB_Y - 8)];
	[eyeSprite setScale:0.2f];
	[self addChild:eyeSprite];
	
	mouthSprite = [CCSprite spriteWithFile:@"smile.png"];
	[mouthSprite setPosition:cpv(BLOB_X, BLOB_Y + 5)];
	[mouthSprite setScale:0.5f];
	[self addChild:mouthSprite];
	*/
	
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[Dart class] begin:@selector(beginDartCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateDartCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[RangedTrap class] begin:@selector(beginTrapCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateTrapCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[SpikedWall class] begin:@selector(beginSpikeCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateSpikeCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[StarGoalTarget class] begin:@selector(beginStarGoalCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateStarGoalCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[GoalTarget class] begin:@selector(beginGoalCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateGoalCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:borderType begin:@selector(beginWallCollision:space:) preSolve:@selector(preSolveWallCollision:space:) postSolve:@selector(postSolveWallCollision:space:) separate:@selector(separateWallCollision:space:)];
}


- (void)physProvoker:(id)sender {
	[self schedule:@selector(physicsStepper:)];
	[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
}


-(void) physicsStepper:(ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
	
	[_space step:1.0 / 60.0];
	
	for (BaseGibs *gibs in _arrGibs) {
		[gibs step];
		
		
		if ([gibs lifeRemains] <= 1) {
			
 			if ([_arrGibs containsObject:gibs]) {
				[self removeChild:[gibs _sprite] cleanup:YES];
				[_space addPostStepCallback:self selector:@selector(onGibsExpiry:) key:gibs];
			}
		}
	}
	
	
		
	if (!_isCleared) {
		//[eyeSprite setPosition:cpv([_blob posPt].x, [_blob posPt].y + 12)];
		//[mouthSprite setPosition:cpv([_blob posPt].x, [_blob posPt].y - 12)];
		
		[_blob updSprites];
		//ChipmunkBody *body = (ChipmunkBody *)_pinwheelShape.data;
		//[body setAngle:10.33];
		
		for (RangedTrap *trap in arrTraps)
			[trap updPos];
		
		for (DartEmitter *dartEmitter in arrDartEmitters)
			[dartEmitter updDarts];
		
		for (Pinwheel *pinwheel in arrPinwheels)
			[pinwheel updRot];
	}
}


-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = kWiggleMaxForce;
	cpFloat rndForce = CCRANDOM_0_1() * maxForce;
	
	[_blob wiggleWithForce:[[RandUtils singleton]rndIndex:BLOB_SEGS] force:rndForce];
}



#pragma mark GoalCollisionHandlers

- (BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	/*
	GoalTarget *trg = target.data;
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"YES"];
	[trg updateCovered:YES];
	
	int cnt = 0;
	for (int i=0; i<2; i++) {
		if([[arrTargets objectAtIndex:i] isEqualToString:@"YES"] && ![trg isCleared])
			cnt++;
	}
	
	trg.isCleared = YES;
	
	
	score_amt = (int)(cnt * 32);
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	[[PlayStatsModel singleton] incScore:score_amt];
	*/
	
	return (NO);
}

- (void)separateGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"separateGoalCollision: [%d]", _cntTargets);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	/*
	if ([[arrTargets objectAtIndex:1] isEqualToString:@"YES"] && [[arrTargets objectAtIndex:1] isEqualToString:@"YES"]) {
		NSLog(@"\nGOAL! [%d]", [arrTouchedEdge count]);
		
		_isCleared = YES;
		self.isTouchEnabled = NO;
		
		if (_starGoalTarget.isCovered) {
			NSLog(@"¡¡¡BONUS PTS!!!");
			
			_isBonus = YES;
			_starGoalTarget.isCleared = YES;
			[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[StarGoalTarget class]];
			
			score_amt = 50;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
			[[PlayStatsModel singleton] incScore:score_amt];
		}
		
		
		[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[GoalTarget class]];
		[_space addPostStepCallback:self selector:@selector(clearArena:) key:_blob];
	}
	
	GoalTarget *trg = target.data;
	[trg updateCovered:NO];
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"NO"];
	 */
}


#pragma mark StarGoalCollisionHandlers

- (BOOL)beginStarGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.beginStarGoalCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	/*
	StarGoalTarget *trg = target.data;
	[trg updateCovered:YES];
	
	return (NO);
	 */
	
	GoalTarget *trg = target.data;
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"YES"];
	[trg updateCovered:YES];
	
	int cnt = 0;
	for (int i=0; i<2; i++) {
		if([[arrTargets objectAtIndex:i] isEqualToString:@"YES"] && ![trg isCleared])
			cnt++;
	}
	
	trg.isCleared = YES;
	
	
	score_amt = (int)(cnt * 32);
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateStarGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.separateStarGoalCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//StarGoalTarget *trg = target.data;
	//[trg updateCovered:NO];
	
	NSLog(@"\nGOAL! [%d]", [arrTouchedEdge count]);
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	
	if (_starGoalTarget.isCovered) {
		NSLog(@"¡¡¡BONUS PTS!!!");
		
		_isBonus = YES;
		_starGoalTarget.isCleared = YES;
		[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[StarGoalTarget class]];
		
		score_amt = 50;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
		[[PlayStatsModel singleton] incScore:score_amt];
	}
	
	
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[GoalTarget class]];
	[_space addPostStepCallback:self selector:@selector(clearArena:) key:_blob];
}


#pragma mark DartCollisionHandlers

- (BOOL)beginDartCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.beginDartCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
		
	//Dart *trg = target.data;
	return (NO);
}

- (void)separateDartCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.separateTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//Dart *trg = target.data;
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[Dart class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}


#pragma mark TrapCollisionHandlers

- (BOOL)beginTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.beginTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	RangedTrap *trg = target.data;
	trg.isCleared = YES;
	[trg updateCovered:YES];
	
	score_amt = (int)(2 * 32);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.separateTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	RangedTrap *trg = target.data;
	[trg updateCovered:NO];
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[RangedTrap class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}


#pragma mark TrapCollisionHandlers

- (BOOL)beginSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.beginSpikeCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	return (NO);
}

- (void)separateSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	NSLog(@"%@.separateSpikeCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[SpikedWall class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}


#pragma mark WallCollisionHandlers

- (BOOL)beginWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"beginWallCollision");
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	if (CCRANDOM_0_1() < 0.15f && !_isWallSFX) {
		_isWallSFX = true;
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.1f];
		[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_noise-02.mp3"];
		
		[self performSelector:@selector(resetWallSFX:) withObject:self afterDelay:0.33f];
		
//		vHitForce = cpArbiterTotalImpulse(arbiter);
//		vHitCoords = cpArbiterGetPoint(arbiter, 0);
//		gibPos = vHitCoords;
//		
//		NSLog(@"beginWallCollision [%f, %f] @ (%f, %f)", vHitForce.x, vHitForce.y, vHitCoords.x, vHitCoords.y);
//		[self performSelector:@selector(addGib:) withObject:nil afterDelay:0.05f];
		
		
		
		//cpContactPointSet pset = cpArbiterGetContactPointSet(arbiter);
		//if (pset.count > 0) {
		//	gibPos = cpv(pset.points[0].point.x, pset.points[0].point.y);
		//}
		
		//for (int i=0; i<pset.count; i++) {
		//	NSLog(@"beginWallCollision:[%d] (%f, %f)", i, pset.points[i].point.x, pset.points[i].point.y);
		//}

	}
	
	return (YES);
}

- (BOOL)preSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"preSolveWallCollision");
	
	return (YES);
}

- (void)postSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, wall);
	
	// skip the later collisions
	if (!cpArbiterIsFirstContact(arbiter))
		return;
	
	
	
	// force of the colliding bodies
	if (cpvlength(cpArbiterTotalImpulse(arbiter)) > 192.0f) {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
		[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_light_splat.mp3"];
	}
	
	
	vHitCoords = cpArbiterGetPoint(arbiter, 0);
	vHitForce = cpvclamp(cpArbiterTotalImpulse(arbiter), 144.0f);
	
	//NSLog(@"postSolveWallCollision [%f, %f] @ (%f, %f) |%f|", vHitCoords.x, vHitCoords.y, vHitForce.x, vHitForce.y, cpvlength(vHitForce));
	
	//if ((int)cpvlength(vHitForce) > 52.0f)
	if ((int)cpvlength(vHitForce) > 520.0f)
		[_space addPostStepCallback:self selector:@selector(addGib:) key:nil];
}

- (void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"separateWallCollision: [%d]", _cntTargets);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, wall);
}


-(void)resetWallSFX:(id)sender {
	_isWallSFX = NO;
}


#pragma mark Drawing/Rendering

-(void)flashBG {
	
	if (bg_cnt % 2 == 0)
		[self setColor:ccc3(229, 220, 7)];
	
	else
		[self setColor:ccc3(233, 86, 86)];
	
	
	bg_cnt++;
	
	
	if (bg_cnt >= 16)
		[self unschedule:@selector(flashBG)];
}


- (void)clearArena:(id)sender {
	NSLog(@"\n\n///////[clearArena]////////\n");
	
	//[self removeChild:lEyeSprite cleanup:NO];
	//[self removeChild:rEyeSprite cleanup:NO];
	
	[_blob flushSprites:self];
	[self unschedule:@selector(physicsStepper:)];
	//[_space remove:_blob];
	//[_space remove:goalTarget1];
	//[_space remove:goalTarget2];
	
	//[_space addPostStepRemoval:goalTarget1];
	//[_space addPostStepRemoval:goalTarget2];
	//[_space addPostStepRemoval:_blob];
	
	
	
	[self removeChildByTag:666 cleanup:NO];
	
	
	for (int i=0; i<((int)CCRANDOM_0_1()*16)+32; i++)
		[self addGib:nil];
	
	[self removeChild:goalTarget1._sprite cleanup:NO];
	[self removeChild:goalTarget2._sprite cleanup:NO];
	
	for (RangedTrap *trap in arrTraps)
		[self removeChild:trap._sprite cleanup:NO];
	
	for (DartEmitter *dartEmitter in arrDartEmitters) {
		[dartEmitter toggleFiring:NO];
		[self removeChild:dartEmitter._sprite cleanup:NO];
	}
	
	for (Dart *dart in arrDarts)
		[self removeChild:dart._sprite cleanup:NO];
	
	for (Pinwheel *pinwheel in arrPinwheels)
		[self removeChild:pinwheel._sprite cleanup:NO];
	
	NSMutableArray *arrSplatter = [[NSMutableArray alloc] init];
	
	for (int i=0; i<3; i++) {
		for (int j=1; j<=8; j++) {
			
			NSString *strColor = [NSString alloc];
			
			if (i == 0)
				strColor = [NSString stringWithString:@"YELLOW"];
			
			else if (i == 1)
				strColor = [NSString stringWithString:@"RED"];
			
			else
				strColor = [NSString stringWithString:@"BLUE"];
			
			[arrSplatter addObject:[CCSprite spriteWithFile:[NSString stringWithFormat:@"spermSplatter%@_0%d.png", strColor, j]]];
		}
	}
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.67f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_finish_splatter.mp3"];
	
	
	float delayTime = 0.0f;
	
	for (int i=0; i<[arrSplatter count]; i++) {
		
		CCSprite *sprite = [arrSplatter objectAtIndex:i];		
		[sprite setPosition:ccp(160, 240)];
		[sprite setScale:0.0f];
		[self addChild:sprite];
		[sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delayTime], [CCScaleTo actionWithDuration:0.2 scale:1 + (CCRANDOM_0_1() * 2)], [CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:0.2f position:ccp((CCRANDOM_0_1() * 320) - 160, (CCRANDOM_0_1() * 480) - 240)] rate:0.5f], nil]];
		delayTime += 0.025f;
	}
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:(CCRANDOM_0_1() * 0.33f) + 0.33f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_light_splat.mp3"];
	
	[self schedule:@selector(flashBG) interval:0.1];
	[self performSelector:@selector(onLevelComplete:) withObject:self afterDelay:1];
}


-(void)restartArena:(id)sender {
	NSLog(@"\n\n///////[restartArena]////////\n");
	
	[self unschedule:@selector(physicsStepper:)];
	[self removeChildByTag:666 cleanup:NO];
	[_blob flushSprites:self];
	//[self removeChild:eyeSprite cleanup:NO];
	//[self removeChild:mouthSprite cleanup:NO];
	
	[self removeChild:goalTarget1._sprite cleanup:NO];
	[self removeChild:goalTarget2._sprite cleanup:NO];
	
	for (RangedTrap *trap in arrTraps)
		[self removeChild:trap._sprite cleanup:NO];
	
	for (DartEmitter *dartEmitter in arrDartEmitters) {
		[dartEmitter toggleFiring:NO];
		[self removeChild:dartEmitter._sprite cleanup:NO];
	}
	
	for (Dart *dart in arrDarts)
		[self removeChild:dart._sprite cleanup:NO];
	
	for (Pinwheel *pinwheel in arrPinwheels)
		[self removeChild:pinwheel._sprite cleanup:NO];
	
	//[_multiGrab release];
	[_multiGrab dealloc];
	
	[self schedule:@selector(flashBG) interval:0.1];
	[self performSelector:@selector(onResetArea:) withObject:self afterDelay:0.5];
}


-(void)addGib:(id)sender {
		
	BaseGibs *gibs = [[BaseGibs alloc] initAtPos:cpvadd(vHitCoords, cpvmult(_blob.posPt, 0.5f))];
	
	[gibs spaceRef:_space];
	
	[self addChild:gibs._sprite];
	[_space add:gibs];
	
	[_arrGibs addObject:gibs];
	[gibs applyThrust:cpvmult(vHitForce, 1.33f) from:vHitCoords edgesToo:NO];//[[RandUtils singleton] rndBool]];
	
	/*
	 float fx = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	 float fy = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	 
	 float rad = (CCRANDOM_0_1() * 4) + 1;
	*/
	
	
	
	/*
	 CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gut_bits0%d.png", (int)rad]];
	 [sprite setScale:0.2f];
	 [sprite setPosition:gibPos];
	 [self addChild:sprite];
	 
	 if (gibPos.x < 100)
	 fx *= -1;

	 ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:rad * 0.33f andMoment:INFINITY]];
	body.pos = cpv(gibPos.x, gibPos.y);
	[body setTorque:CCRANDOM_0_1() * 16.0f];
	[body applyImpulse:cpvmult(cpv(fx, fy), 3) offset:cpvzero];
	
	ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:rad offset:cpvzero]];
	shape.friction = 0.25;
	shape.elasticity = 0.875;
	
	[arrGibsShape addObject:shape];
	[arrGibsSprite addObject:sprite];
	*/
}


-(void)onGibsExpiry:(id)sender {
	NSLog(@"PlayScreenLayer.onGibsExpiry(%@)", sender);
	
	BaseGibs *gibs = (BaseGibs *)sender;
	[_arrGibs removeObject:gibs];
	
	
	//[gibs release];
	NSLog(@"\t --> pulled out(%@)", sender);
}


-(void)addGib2 {
	
	cpFloat mass = CCRANDOM_0_1() * 2;
	float fx = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	float fy = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	
	CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gut_bits0%d.png", ((int)(CCRANDOM_0_1() * 4) + 1)]];
	[sprite setScale:0.2f];
	[sprite setPosition:gibPos];
	[self addChild:sprite];
	
	ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:INFINITY]];
	body.pos = cpv(gibPos.x, gibPos.y);
	[body setTorque:CCRANDOM_0_1() * 16.0f];
	[body applyImpulse:cpvmult(cpv(fx, fy), 3) offset:cpvzero];
	
	
	ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:(CCRANDOM_0_1() * 10) + 5 offset:cpvzero]];
	shape.friction = 0.25;
	shape.elasticity = 0.875;
	
	[arrGibsShape addObject:shape];
	[arrGibsSprite addObject:sprite];
}

-(void) draw {
	//NSLog(@"///////[DRAW]////////");
	
	[super draw];
	
	if (!_isCleared) {
		[_blob draw];
		
		
	} else {

	}
	
	
	for (int i=0; i<[_arrDrawPts count]; i++) {
		ChipmunkBody *currBody = (ChipmunkBody *)[_arrDrawPts objectAtIndex:i];
		//ccDrawCircle(currBody.pos, 3, 360, 4, NO);
		
		if (i > 0) {
			ChipmunkBody *prevBody = (ChipmunkBody *)[_arrDrawPts objectAtIndex: i-1];
			ccDrawLine(prevBody.pos, currBody.pos);
		}
	}
	
	//NSLog(@"///////FLOAT(0-10):[%f]////////", [[RandUtils singleton] rndFloat:0.0f max:10.0f]);
	
	//for (int i=0; i<[arrGibs count]; i++) {
	//	ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
	//	ccDrawCircle(shape.body.pos, 3, 360, 4, NO);
	//}
	
}




#pragma mark MenuNav

-(void) onEnter {
	//NSLog(@"PlayScreenLayer.onEnter()");
	
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}


-(void) onPlayPauseToggle:(id)sender {
	NSLog(@"PlayScreenLayer.onPlayPauseToggle(%d)", [sender selectedIndex]);
	
	
	if ([sender selectedIndex] == 1) {
		self.isTouchEnabled = NO;
		[self unschedule:@selector(physicsStepper:)];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GameplayPauseToggle" object:[NSNumber numberWithBool:YES]];
		
	} else {
		self.isTouchEnabled = YES;
		[self schedule:@selector(physicsStepper:) interval:(1.0f / 60.0f)];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GameplayPauseToggle" object:[NSNumber numberWithBool:NO]];
	}
}

-(void) onBackMenu:(id)sender {
	NSLog(@"PlayScreenLayer.onBackMenu()");
	[ScreenManager goLevelSelect:indLvl];
}


-(void) onLevelComplete:(id)sender {
	NSLog(@"PlayScreenLayer.onLevelComplete(%d)", (int)_isBonus);
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.85f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_finish_splatter.wav"];
	
	[ScreenManager goLevelComplete:indLvl withBonus:_isBonus];
}


-(void) onGameOver:(id)sender  {
	NSLog(@"PlayScreenLayer.onGameOver(%@)", sender);	//[ScreenManager goGameOver];
	[ScreenManager goGameOver];
}


-(void) onResetArea:(id)sender {
	[ScreenManager goPlay:indLvl];
}


#pragma mark CLEANUP

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
	
	self.splatDripsAction = nil;
	self.splatExploAction = nil;
	
	// in case you have something to dealloc, do it in this method
	[_space release];
	[_multiGrab release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


#pragma mark Touch Interactions

static cpVect
TouchLocation(UITouch *touch) {
	return ([[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]]);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; {
	_arrDrawPts = [[NSMutableArray alloc] init];
	_isDrawing = NO;
	
	for (UITouch *touch in touches) {
		[_multiGrab beginLocation:TouchLocation(touch)];
		
		int ind = [_blob bodyIndexAt:TouchLocation(touch)];
		
		if (ind >= 0) {
			//NSLog(@"PlayScreenLayer.ccTouchesBegan(%d)", ind);
			[arrTouchedEdge addObject:[NSString stringWithFormat:@"E_%d", ind]];
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_noise-01.mp3"];
		}
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event; {
	
	_isDrawing = YES;
	//UITouch *anyTouch = [touches anyObject];
	//CGPoint currPt = TouchLocation(anyTouch);
	
//	ChipmunkBody *body = [[ChipmunkBody alloc] initWithMass:0 andMoment:0];
//	[body setPos:cpv(currPt.x, currPt.y)];
//	[_arrDrawPts addObject:body];
	
	for (UITouch *touch in touches) {
		[_multiGrab updateLocation:TouchLocation(touch)];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; {
	
	[_arrDrawPts removeAllObjects];
	
	for (UITouch *touch in touches) {
		[_multiGrab endLocation:TouchLocation(touch)];
		
		
		int ind = [_blob bodyIndexAt:TouchLocation(touch)];
		
		if (ind % 2 == 0) {
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.25f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_noise-02.mp3"];
		}
		
			
		for (int i=0; i<[arrTouchedEdge count]; i++) {
			if ([[arrTouchedEdge objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"E_%d", ind]])
				[arrTouchedEdge removeObjectAtIndex:i];
		}
	}
}



@end