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
static NSString *PLAYER_TYPE = @"PLAYER_TYPE";

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
	
	if ((self = [super initWithColor:ccc4(ARENA_BG.r, ARENA_BG.g, ARENA_BG.b, 255)])) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		[self setupSFX];
		
		
		//[[SimpleAudioEngine sharedEngine] playEffect:@"debug_healmag.wav"];
		
		_isBonus = NO;
		_isCleared = NO;
		_isWallSFX = NO;
		_totStars = 0;
		
		_fireArrowSprite = [CCSprite spriteWithFile:@"fireArrow.png"];
		
		_arrDrawPts = [[NSMutableArray alloc] init];
		arrTouchedEdge = [[NSMutableArray alloc] init];
		
		[self chipmunkSetup];
		[self buildLvlObjs];
		//[self scaffoldHUD];
		
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"UPD_LVL" object:[[NSNumber alloc] initWithInt:indLvl]];
		
		[self performSelector:@selector(physProvoker:) withObject:self afterDelay:0.33f];
		
		/*
		[self setPosition:cpv(0, 480)];
		CCAction *action = [CCSequence actions:
								  [CCDelayTime actionWithDuration:0.33], 
								  [CCMoveBy actionWithDuration:1.33f position:ccp(0, -480)], nil];
		[self runAction:action];
		*/
		_isPanning = NO;
		_ptViewOffset = CGPointMake(0, 0);
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
	
	int indBG = [[[plistLvlData dicTopLvl] objectForKey:@"bg"] intValue];
	
	if (indBG == 0)
		indBG = 1;
	
	CCSprite *bg1Sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background_%d.jpg", indBG]];
	[bg1Sprite setPosition:CGPointMake(160, 240)];
	[self addChild:bg1Sprite];
	
	CCSprite *bg2Sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background_%d.jpg", indBG]];
	[bg2Sprite setPosition:CGPointMake(160, -240)];
	//[self addChild:bg2Sprite];

	
	arrHealths = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrHealthData count]];
	for (NSDictionary *dict in plistLvlData.arrHealthData) {
		
		HealthTarget *health = [[HealthTarget alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]) type:[[dict objectForKey:@"type"] floatValue]];
		
		[arrHealths addObject:health];
		[_space add:health];
		[self addChild:health._sprite];
	}
	
	arrStars = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrStarData count]];
	for (NSDictionary *dict in plistLvlData.arrStarData) {
		
		StarGoalTarget *star = [[StarGoalTarget alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue])];
		
		[arrStars addObject:star];
		[_space add:star];
		[self addChild:star._sprite];
	}
	
	arrPickups = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrPointData count]];
	for (NSDictionary *dict in plistLvlData.arrPointData) {
		
		PointTarget *pickup = [[PointTarget alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]) type:[[dict objectForKey:@"type"] floatValue] points:[[dict objectForKey:@"points"] intValue]];
		
		[arrPickups addObject:pickup];
		[_space add:pickup];
		[self addChild:pickup._sprite];
	}
	
	arrBombs = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrBombData count]];
	for (NSDictionary *dict in plistLvlData.arrBombData) {
		
		BombTarget *bomb = [[BombTarget alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue])];
		
		[arrBombs addObject:bomb];
		[_space add:bomb];
		[self addChild:bomb._sprite];
	}
	
	arrCheckTargets = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrGoalData count] - 2];
	for (NSDictionary *dict in plistLvlData.arrGoalData) {
		CGPoint goalPos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		//NSLog(@"[%d]: [%@]-(%f, %f)", ind, [dictGoal objectForKey:@"x"], goalPos.x, goalPos.y);
		
		CheckTarget *checkTarget;
		
		switch ([[dict objectForKey:@"type"] intValue]) {
			case 1:
				_startTarget = [[StartTarget alloc] initAtPos:goalPos];
				//[_space add:_startTarget];
				break;
				
			case 2:
				_goalTarget = [[GoalTarget alloc] initAtPos:goalPos];//cpv((CCRANDOM_0_1() * 280) + 16, (CCRANDOM_0_1() * 400) + 32)];
				[_space add:_goalTarget];
				[self addChild:_goalTarget._sprite];
				break;
				
			case 3:
				checkTarget = [[CheckTarget alloc] initAtPos:goalPos];//cpv((CCRANDOM_0_1() * 280) + 16, (CCRANDOM_0_1() * 400) + 32)];
				[arrCheckTargets addObject:checkTarget];
				[_space add:checkTarget];
				[self addChild:checkTarget._sprite];
				break;
		}
	}
	
	
	for (NSDictionary *dict in plistLvlData.arrWallData) {
		SpikedWall *wall = [[SpikedWall alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]) large:[[dict objectForKey:@"type"] intValue]-1 spikes:[[dict objectForKey:@"spikes"] intValue] rotation:[[dict objectForKey:@"angle"] intValue] friction:[[dict objectForKey:@"frict"] floatValue] bounce:[[dict objectForKey:@"bounce"] floatValue]];
		
		[self addChild:wall._sprite];
		[_space add:wall];
	}
	
	
	for (NSDictionary *dict in plistLvlData.arrStudData) {
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body.pos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"cog.png"];
		[sprite setPosition:body.pos];
		[self addChild:sprite];
		
		ChipmunkStaticPolyShape *shape = [_space add:[ChipmunkStaticCircleShape circleWithBody:body radius:[[dict objectForKey:@"radius"] floatValue] offset:cpvzero]];
		shape.friction = [[dict objectForKey:@"frict"] floatValue];
		shape.elasticity = [[dict objectForKey:@"bounce"] floatValue];
		shape.data = sprite;
	}
	
		
	arrTraps = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrTrapData count]];
	for (NSDictionary *dict in plistLvlData.arrTrapData) {
		
		int trapType = [[dict objectForKey:@"type"] intValue];
		RangedTrap *trap = [[RangedTrap alloc] initAtPos:CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]) vertical:(int)(trapType - 1) speed:[[dict objectForKey:@"speed"] floatValue] range:CGPointMake([[dict objectForKey:@"min"] floatValue], [[dict objectForKey:@"max"] floatValue])];
		
		[arrTraps addObject:trap];
		[_space add:trap];
		[self addChild:trap._sprite];
	}
	
	
	arrDartEmitters = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrDartData count]];
	for (NSDictionary *dict in plistLvlData.arrDartData) {
		
		CGPoint dartPos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		DartEmitter *dartEmitter = [[DartEmitter alloc] initAtPos:dartPos fires:[[dict objectForKey:@"type"] intValue] freq:[[dict objectForKey:@"interval"] floatValue] speed:[[dict objectForKey:@"speed"] floatValue]];
		
		[dartEmitter spaceRef:_space];
		[dartEmitter layerRef:self];
		[arrDartEmitters addObject:dartEmitter];
		[_space add:dartEmitter];
		[self addChild:dartEmitter._sprite];
		[dartEmitter toggleFiring:YES];
	}
	
	
	arrPunters = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrPunterData count]];
	for (NSDictionary *dict in plistLvlData.arrPunterData) {
		
		CGPoint pos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		Punter *punter = [[Punter alloc] initAtPos:pos interval:[[dict objectForKey:@"interval"] floatValue] force:[[dict objectForKey:@"force"] floatValue]];
		
		[arrPunters addObject:punter];
		[_space add:punter];
		[self addChild:punter._sprite];
		[punter toggle:YES];
	}
	
	if ([arrDartEmitters count] > 0)
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDartFired:) name:@"FIRE_DART" object:nil];
	
	
	arrPinwheels = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrHandWheelData count]];
	for (NSDictionary *dict in plistLvlData.arrHandWheelData) {
		CGPoint handwheelPos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		
		Pinwheel *pinwheel = [[Pinwheel alloc] initAtPos:handwheelPos spinsClockwise:YES speed:2.33f];
		[pinwheel attach:_space];
		[arrPinwheels addObject:pinwheel];
		
		[_space add:pinwheel];
		[self addChild:pinwheel._sprite];
	}
		
	arrConveyors = [[NSMutableArray alloc] initWithCapacity:[plistLvlData.arrConveyorData count]];
	for (NSDictionary *dict in plistLvlData.arrConveyorData) {
		CGPoint conveyorPos = CGPointMake([[dict objectForKey:@"x"] floatValue], [[dict objectForKey:@"y"] floatValue]);
		
		ConveyorBelt *conveyorBelt = [[ConveyorBelt alloc] initAtPos:conveyorPos width:200 speed:[[dict objectForKey:@"speed"] floatValue]];
		[_space add:conveyorBelt];
		[self addChild:conveyorBelt._sprite];
	}
	
		
	//_blob = [[JellyBlob alloc] initWithPos:_startTarget._sprite.position radius:BLOB_RADIUS count:BLOB_SEGS color:0];
	//[_blob adoptSprites:self];
	//[_space add:_blob];
	
	_playerFrame = 0;
	_playerFrameState = 0;
	_playerSprite = [CCSprite spriteWithFile:@"player_f0.png"];
	[_playerSprite setPosition:_startTarget._sprite.position];
	[self addChild:_playerSprite];
	
	NSArray *arrIdle = [NSArray arrayWithObjects:@"player_f0.png", @"player_f1.png", @"player_f2.png", @"player_f3.png", @"player_f4.png", @"player_f5.png", @"player_f6.png", nil];
	NSArray *arrSplat = [NSArray arrayWithObjects:@"player_f9.png", @"player_f11.png", @"player_f12.png", @"player_f13.png", nil];
	NSArray *arrStretch = [NSArray arrayWithObjects:@"player_f8.png", @"player_f10.png", nil];
	
	_dictPlayerFrames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:arrIdle, arrSplat, arrStretch, nil] forKeys:[NSArray arrayWithObjects:@"idle", @"splat", @"stretch", nil]];
	_arrActiveFrames = [[NSArray alloc] initWithArray:[_dictPlayerFrames objectForKey:@"idle"]];
	
	_playerBody = [ChipmunkBody bodyWithMass:4.5f andMoment:cpMomentForCircle(4.5f, 0, 24.0f, cpvzero)];
	_playerBody.pos = _startTarget._sprite.position;
	
	_playerShape = [ChipmunkCircleShape circleWithBody:_playerBody radius:20.0f offset:cpvzero];
	_playerShape.layers = GRABABLE_LAYER;
	_playerShape.friction = 2.9f;
	_playerShape.elasticity = 0.0f;
	_playerShape.collisionType = PLAYER_TYPE;
	_playerShape.data = _playerSprite;
	
	[_space add:_playerBody];
	[_space add:_playerShape];
	
	_playerFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(onFrameChange:) userInfo:nil repeats:YES];
	
	vHitCoords = _startTarget._sprite.position;
	[_fireArrowSprite setPosition:vHitCoords];
	[_fireArrowSprite setOpacity:0.0f];
	
	[self addChild:_fireArrowSprite];
	
	_playerSlideConstraint = [ChipmunkSlideJoint slideJointWithBodyA:_playerBody bodyB:_space.staticBody anchr1:cpvzero anchr2:vHitCoords min:0 max:48.0f];
	[_space add:_playerSlideConstraint];
	
	
	/*
	int width = 160;
	int height = 13;
	int ang = 225;
	
	cpVect tl;
	cpVect tr;
	cpVect br;
	cpVect bl;
	
	ChipmunkBody *polyBody = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
	polyBody.pos = cpv(160, 240);
	
	ChipmunkPolyShape *polyShape;
	
	
	switch (ang) {
		case 0:
			tl = cpv(-width * 0.5f, height * 0.5f);
			tr = cpv(width * 0.5f, height * 0.5f);
			br = cpv(width * 0.5f, -height * 0.5f);
			bl = cpv(-width * 0.5f, -height * 0.5f);
			
			cpVect polyVerts0[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts0 offset:cpvzero];
			break;
			
		case 45:
			tl = cpv(sinf(CC_DEGREES_TO_RADIANS(-ang)) * (width * 0.5f), cosf(CC_DEGREES_TO_RADIANS(-ang)) * (width * 0.5f));
			tr = cpvadd(tl, cpv(sinf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * height));
			br = cpvadd(tr, cpv(sinf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height));
			bl = cpvadd(tl, cpv(sinf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height));
			
			cpVect polyVerts45[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts45 offset:cpvzero];
			break;
			
		case 90:
			tl = cpv(-height * 0.5f, width * 0.5f);
			tr = cpv(height * 0.5f, width * 0.5f);
			br = cpv(height * 0.5f, -width * 0.5f);
			bl = cpv(-height * 0.5f, -width * 0.5f);
			
			cpVect polyVerts90[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts90 offset:cpvzero];
			break;
			
		case 135:
			ang = 45;
			tl = cpv(61, 83);
			tr = cpv(83, 61);
			br = cpv(-61, -83);
			bl = cpv(-83, -61);
			
			tl = cpv(sinf(CC_DEGREES_TO_RADIANS(ang)) * (width * 0.5f), cosf(CC_DEGREES_TO_RADIANS(ang)) * (width * 0.5f));
			tr = cpvadd(tl, cpv(sinf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * height));
			br = cpvneg(tl);
			bl = cpvneg(tr);
			
			cpVect polyVerts135[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts135 offset:cpvzero];
			break;
			
		case 180:
			tl = cpv(-width * 0.5f, height * 0.5f);
			tr = cpv(width * 0.5f, height * 0.5f);
			br = cpv(width * 0.5f, -height * 0.5f);
			bl = cpv(-width * 0.5f, -height * 0.5f);
			
			cpVect polyVerts180[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts180 offset:cpvzero];
			break;
			
		case 225:
			ang = 45;
			tl = cpv(sinf(CC_DEGREES_TO_RADIANS(-ang)) * (width * 0.5f), cosf(CC_DEGREES_TO_RADIANS(-ang)) * (width * 0.5f));
			tr = cpv(sinf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * (width * 0.5f), cosf(CC_DEGREES_TO_RADIANS(90.0f + ang)) * (width * 0.5f));
			br = cpvadd(tr, cpv(sinf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height));
			bl = cpvadd(tl, cpv(sinf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height, cosf(CC_DEGREES_TO_RADIANS(180.0f + ang)) * height));
			
			cpVect polyVerts225[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts225 offset:cpvzero];
			break;
			
		case 270:
			tl = cpv(-height * 0.5f, width * 0.5f);
			tr = cpv(height * 0.5f, width * 0.5f);
			br = cpv(height * 0.5f, -width * 0.5f);
			bl = cpv(-height * 0.5f, -width * 0.5f);
			
			cpVect polyVerts270[] = {tl, tr, br, bl};
			polyShape = [[ChipmunkPolyShape alloc] initWithBody:polyBody count:4 verts:polyVerts270 offset:cpvzero];
			break;
			
		case 315:
			break;
	}
	
	
	//NSLog(@"TR:[%f, %f]", tr.x, tr.y);
	//NSLog(@"BR:[%f, %f]", br.x, br.y);
	//NSLog(@"BL:[%f, %f]", bl.x, bl.y);
	
	polyShape.friction = 0.5;
	polyShape.elasticity = 0.1;
	[_space add:polyShape];
	*/
}

-(void)onFrameChange:(id)sender {
	_playerFrame++;
	
	if (_playerFrame == [_arrActiveFrames count])
		_playerFrame = 0;
	
	if (_playerFrameState > 0) {
		[_playerFrameTimer invalidate];
		_playerFrameTimer = nil;
	}
	[self removeChild:_playerSprite cleanup:NO];
	_playerSprite = [CCSprite spriteWithFile:[_arrActiveFrames objectAtIndex:_playerFrame]];
	[_playerSprite setPosition:_playerBody.pos];
	[_playerSprite setScale:(CCRANDOM_0_1() * 0.1f) + 0.95f];
	[self addChild:_playerSprite];
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


#pragma mark PhysicsEngine

-(void) chipmunkSetup {
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	//CGPoint winsMidPt = CGPointMake(wins.width * 0.5f, wins.height * 0.5f);
	
	NSLog(@"SCREEN SIZE:[%f, %f]", wins.width, wins.height);
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, 0);
	//_space.gravity = cpv(0, -320);
	_space.damping = 0.33f;
	
	
	//CGRect rect = CGRectMake(0, -480, wins.width, wins.height + 480);
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	[_space addBounds:rect thickness:532 elasticity:0.0f friction:2.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	_multiGrab = [[ChipmunkMultiGrab alloc] initForSpace:_space withSmoothing:cpfpow(0.5, 60.0) withGrabForce:20000];
	_multiGrab.layers = GRABABLE_LAYER;
	
	if (kDrawChipmunkObjs == 1)
		[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space] z:0 tag:666];
	
	arrGibsShape = [[NSMutableArray alloc] init];
	arrGibsSprite = [[NSMutableArray alloc] init];
	
	_arrGibs = [[NSMutableArray alloc] init];
	arrDarts = [[NSMutableArray alloc] init];
	
	_isStuck = NO;
	
	
	[self toggleCollisions:YES];
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
		[_blob updSprites];
		
		int ang;
		
		switch (_playerFrameState) {
			case 0:
				ang = 180;
				break;
				
			case 1:
				ang = -90;
				break;
				
			case 2:
				ang = 0;
				break;
				
			case 3:
				ang = 270;
				break;
				
		}
		
		[_playerSprite setPosition:_playerBody.pos];
		[_playerSprite setRotation:CC_RADIANS_TO_DEGREES(cpvtoangle(cpvneg(cpvsub(vHitCoords, _playerBody.pos)))) + ang];
		[_fireArrowSprite setRotation:CC_RADIANS_TO_DEGREES(cpvtoangle(cpvneg(cpvsub(vHitCoords, _playerBody.pos)))) + 90];
		
		for (RangedTrap *trap in arrTraps)
			[trap updPos];
		
		for (DartEmitter *dartEmitter in arrDartEmitters)
			[dartEmitter updDarts];
		
		for (Pinwheel *pinwheel in arrPinwheels)
			[pinwheel updRot];
		
		for (Punter *punter in arrPunters)
			[punter updPos];
	}
}


-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = kWiggleMaxForce;
	cpFloat rndForce = CCRANDOM_0_1() * maxForce;
	
	[_blob wiggleWithForce:[[RandUtils singleton]rndIndex:BLOB_SEGS] force:rndForce];
}


-(void)addStick:(id)sender {
	[_fireArrowSprite setPosition:vHitCoords];
	
	_playerSpringConstraint = [ChipmunkDampedSpring dampedSpringWithBodyA:_playerBody bodyB:_space.staticBody anchr1:cpvzero anchr2:vHitCoords restLength:0.0f stiffness:160.0f damping:0.5f];
	_playerSlideConstraint = [ChipmunkSlideJoint slideJointWithBodyA:_playerBody bodyB:_space.staticBody anchr1:cpvzero anchr2:vHitCoords min:0 max:48.0f];
	
	[_space add:_playerSlideConstraint];
	[_space add:_playerSpringConstraint];
}


-(void)toggleCollisions:(BOOL)isEnabled {
	
	if (isEnabled) {
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[Dart class] begin:@selector(beginDartCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateDartCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[RangedTrap class] begin:@selector(beginTrapCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateTrapCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[Punter class] begin:@selector(beginPunterCollision:space:) preSolve:nil postSolve:nil separate:@selector(separatePunterCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[BombTarget class] begin:@selector(beginBombCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateBombCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[SpikedWall class] begin:@selector(beginSpikeCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateSpikeCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[CheckTarget class] begin:@selector(beginCheckGoalCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateCheckGoalCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[GoalTarget class] begin:@selector(beginGoalCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateGoalCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[HealthTarget class] begin:@selector(beginHealthCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateHealthCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[StarGoalTarget class] begin:@selector(beginStarCollision:space:) preSolve:nil postSolve:nil separate:@selector(separateStarCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:[PointTarget class] begin:@selector(beginPointCollision:space:) preSolve:nil postSolve:nil separate:@selector(separatePointCollision:space:)];
		[_space addCollisionHandler:self typeA:PLAYER_TYPE typeB:borderType begin:@selector(beginWallCollision:space:) preSolve:@selector(preSolveWallCollision:space:) postSolve:@selector(postSolveWallCollision:space:) separate:@selector(separateWallCollision:space:)];
	
	} else {
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[Dart class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[RangedTrap class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[RangedTrap class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[BombTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[Punter class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[SpikedWall class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[CheckTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[GoalTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[StarGoalTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[HealthTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:[PointTarget class]];
		[_space removeCollisionHandlerForTypeA:PLAYER_TYPE andB:borderType];
	}
}

#pragma mark PointCollisionHandlers

- (BOOL)beginPointCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginPointCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	PointTarget *trg = target.data;
	[trg updCovered:YES];
	
	return (NO);
}

- (void)separatePointCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separatePointCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	PointTarget *trg = target.data;
	
	if (!trg.isCleared) {
		trg.isCleared = YES;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:trg.points]];
		[[PlayStatsModel singleton] incScore:score_amt];
		//[self removeChild:trg._sprite cleanup:NO];
		//[_space remove:trg];
	}
}

#pragma mark HealthCollisionHandlers

- (BOOL)beginHealthCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginHealthCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	HealthTarget *trg = target.data;
	[trg updCovered:YES];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:50]];
	//[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateHealthCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateHealthCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	HealthTarget *trg = target.data;
	
	if (!trg.isCleared) {
		trg.isCleared = YES;
		//[self removeChild:trg._sprite cleanup:NO];
		//[_space remove:trg];
	}	
}


#pragma mark StarCollisionHandlers

- (BOOL)beginStarCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginStarCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	StarGoalTarget *trg = target.data;
	[trg updCovered:YES];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:50]];
	//[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateStarCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateStarCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	StarGoalTarget *trg = target.data;
	
	if (!trg.isCleared) {
		trg.isCleared = YES;
		_totStars++;
	}	
}



#pragma mark CheckGoalCollisionHandlers

- (BOOL)beginCheckGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginGoalCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	
	return (NO);
}

- (void)separateCheckGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"separateCheckGoalCollision()");
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	if (!_isPanning) {
		
		//[self toggleCollisions:NO];
		CCAction *action = [CCSequence actions:[CCMoveBy actionWithDuration:0.5f position:ccp(0, 480)], nil];
		[self runAction:action];
		
		[_blob shiftDown];
		_isPanning = YES;
		_ptViewOffset = CGPointMake(0, 480);
	}
}


#pragma mark GoalCollisionHandlers

- (BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginGoalCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	GoalTarget *trg = target.data;
	[trg updateCovered:YES];
	trg.isCleared = YES;
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateGoalCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	NSLog(@"\nGOAL! [%d]", [arrTouchedEdge count]);
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	
	if (_totStars == 3) {
		NSLog(@"¡¡¡BONUS PTS!!!");
		
		_isBonus = YES;
		_goalTarget.isCleared = YES;
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
	//NSLog(@"%@.beginDartCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
		
	//Dart *trg = target.data;
	return (NO);
}

- (void)separateDartCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//Dart *trg = target.data;
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[Dart class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}


#pragma mark TrapCollisionHandlers

- (BOOL)beginTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	RangedTrap *trg = target.data;
	trg.isCleared = YES;
	[trg updateCovered:YES];
	
	score_amt = (int)(2 * 32);
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	//[[PlayStatsModel singleton] incScore:score_amt];
	
	return (NO);
}

- (void)separateTrapCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateTrapCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	RangedTrap *trg = target.data;
	[trg updateCovered:NO];
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[RangedTrap class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}

#pragma mark PunterCollisionHandlers

- (BOOL)beginPunterCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginPunterCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//Punter *trg = target.data;
	[_blob pushWithForce:1200 angle:90];
	
	return (NO);
}

- (void)separatePunterCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separatePunterCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
}


#pragma mark BombCollisionHandlers

- (BOOL)beginBombCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	///NSLog(@"%@.beginBombCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	BombTarget *trg = target.data;
	[trg updCovered:YES];
	
	if (!trg.isCleared) {
		trg.isCleared = YES;
		
		cpVect slope = cpvsub(_blob.posPt, trg._body.pos);
		float ang = cpvtoangle(slope);
		float force = 3200;
		NSLog(@"%@.separateBombCollision(%f, %f)", [self class], slope.x, slope.y);
		
		for (int i=0; i<2; i++) {
			float aOffset = ang + (CCRANDOM_0_1() * 4) - 2;
			float fOffset = force + (CCRANDOM_0_1() * 100) - 50;
			
			[_blob pushWithForce:fOffset angle:CC_RADIANS_TO_DEGREES(aOffset)];
		}
	}
	
	return (NO);
}

- (void)separateBombCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateBombCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//BombTarget *trg = target.data;
	
	/*
	if (!trg.isCleared) {
		trg.isCleared = YES;
		
		cpVect slope = cpvsub(_blob.posPt, trg._body.pos);
		float ang = cpvtoangle(slope);
		float force = 3200;
		NSLog(@"%@.separateBombCollision(%f, %f)", [self class], slope.x, slope.y);
		
		for (int i=0; i<3; i++) {
			float aOffset = ang + (CCRANDOM_0_1() * 10) - 5;
			float fOffset = force + (CCRANDOM_0_1() * 100) - 50;
			
			[_blob pushWithForce:fOffset angle:CC_RADIANS_TO_DEGREES(aOffset) + 180];
		}
	*/
		
	
		
		//[trg remove];
		//[self removeChild:trg._sprite cleanup:NO];
		//[_space remove:trg];
}

#pragma mark TrapCollisionHandlers

- (BOOL)beginSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.beginSpikeCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	return (NO);
}

- (void)separateSpikeCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"%@.separateSpikeCollision()", [self class]);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	_isCleared = YES;
	self.isTouchEnabled = NO;
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[SpikedWall class]];
	[_space addPostStepCallback:self selector:@selector(restartArena:) key:_blob];
}


#pragma mark WallCollisionHandlers

- (BOOL)beginWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"beginWallCollision");
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, playerShape, target);
	
	if (CCRANDOM_0_1() < 0.15f && !_isWallSFX) {
		_isWallSFX = true;
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.1f];
		[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_noise-02.mp3"];
		
		[self performSelector:@selector(resetWallSFX:) withObject:self afterDelay:0.33f];
		
		vHitForce = cpArbiterTotalImpulse(arbiter);
		vHitCoords = cpArbiterGetPoint(arbiter, 0);
		gibPos = vHitCoords;
		
		NSLog(@"beginWallCollision [%f, %f] @ (%f, %f)", vHitForce.x, vHitForce.y, vHitCoords.x, vHitCoords.y);
		//[self performSelector:@selector(addGib:) withObject:nil afterDelay:0.05f];
		
		
		
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
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, playerShape, wall);
	
	// skip the later collisions
	if (!cpArbiterIsFirstContact(arbiter))
		return;
	
	// force of the colliding bodies
	if (cpvlength(cpArbiterTotalImpulse(arbiter)) > 192.0f) {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
		[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_light_splat.mp3"];
	}
	
	_playerFrameState = 2;
	_playerFrame = 0;
	[_arrActiveFrames dealloc];
	_arrActiveFrames = [[NSArray alloc] initWithObjects:@"player_f9.png", @"player_f11.png", @"player_f12.png", @"player_f13.png", nil];
	[_playerFrameTimer invalidate];
	_playerFrameTimer = nil;
	_playerFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(onFrameChange:) userInfo:nil repeats:YES];
	
	vHitCoords = cpArbiterGetPoint(arbiter, 0);
	vHitForce = cpvclamp(cpArbiterTotalImpulse(arbiter), 144.0f);
	
	NSLog(@"postSolveWallCollision [%f, %f] @ (%f, %f) |%f|", vHitCoords.x, vHitCoords.y, vHitForce.x, vHitForce.y, cpvlength(vHitForce));
	if (!_isStuck) {
		_isStuck = YES;
		
		[_space addPostStepCallback:self selector:@selector(addStick:) key:nil];
	}
	
	//if ((int)cpvlength(vHitForce) > 52.0f)
	if ((int)cpvlength(vHitForce) > 520.0f)
		[_space addPostStepCallback:self selector:@selector(addGib:) key:nil];
}

- (void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	//NSLog(@"separateWallCollision: [%d]", _cntTargets);
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, playerShape, wall);
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
	
	[_blob flushSprites:self];
	[self unschedule:@selector(physicsStepper:)];
	//[_space remove:_blob];
	//[_space remove:_startTarget];
	//[_space remove:goalTarget2];
	
	//[_space addPostStepRemoval:_startTarget];
	//[_space addPostStepRemoval:goalTarget2];
	//[_space addPostStepRemoval:_blob];
	
	[self removeChildByTag:666 cleanup:NO];
	
	
	for (int i=0; i<((int)CCRANDOM_0_1()*16)+32; i++)
		[self addGib:nil];
	
	[self removeChild:_startTarget._sprite cleanup:NO];
	[self removeChild:_goalTarget._sprite cleanup:NO];
	
	for (HealthTarget *healthTarget in arrHealths)
		[self removeChild:healthTarget._sprite cleanup:NO];
	
	for (StarGoalTarget *starTarget in arrStars)
		[self removeChild:starTarget._sprite cleanup:NO];
	
	for (PointTarget *pointTarget in arrPickups)
		[self removeChild:pointTarget._sprite cleanup:NO];
	
	for (CheckTarget *checkTarget in arrCheckTargets)
		[self removeChild:checkTarget._sprite cleanup:NO];
	
	for (RangedTrap *trap in arrTraps)
		[self removeChild:trap._sprite cleanup:NO];
	
	for (Pinwheel *pinwheel in arrPinwheels)
		[self removeChild:pinwheel._sprite cleanup:NO];
	
	for (ConveyorBelt *conveyorBelt in arrConveyors)
		[self removeChild:conveyorBelt._sprite cleanup:NO];
	
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
	
	for (UITouch *touch in _arrDrawPts)
		[_multiGrab endLocation:cpvadd([[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]], cpvneg(_ptViewOffset))];
	
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
	
	[self removeChild:_startTarget._sprite cleanup:NO];
	[self removeChild:_goalTarget._sprite cleanup:NO];
	
	for (HealthTarget *healthTarget in arrHealths)
		[self removeChild:healthTarget._sprite cleanup:NO];
	
	for (StarGoalTarget *starTarget in arrStars)
		[self removeChild:starTarget._sprite cleanup:NO];
	
	for (PointTarget *pointTarget in arrPickups)
		[self removeChild:pointTarget._sprite cleanup:NO];
	
	for (CheckTarget *checkTarget in arrCheckTargets)
		[self removeChild:checkTarget._sprite cleanup:NO];
	
	for (RangedTrap *trap in arrTraps)
		[self removeChild:trap._sprite cleanup:NO];
	
	for (Pinwheel *pinwheel in arrPinwheels)
		[self removeChild:pinwheel._sprite cleanup:NO];
	
	for (ConveyorBelt *conveyorBelt in arrConveyors)
		[self removeChild:conveyorBelt._sprite cleanup:NO];
	
	for (DartEmitter *dartEmitter in arrDartEmitters) {
		[dartEmitter toggleFiring:NO];
		[self removeChild:dartEmitter._sprite cleanup:NO];
	}
	
	for (Dart *dart in arrDarts)
		[self removeChild:dart._sprite cleanup:NO];
	
	for (Pinwheel *pinwheel in arrPinwheels)
		[self removeChild:pinwheel._sprite cleanup:NO];
	
	for (UITouch *touch in _arrDrawPts)
		[_multiGrab endLocation:cpvadd([[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]], cpvneg(_ptViewOffset))];
	
	
	
	NSMutableArray *arrSplatter = [[NSMutableArray alloc] init];
	
	for (int i=0; i<21; i++) {
		NSString *slime = [NSString stringWithFormat:@"slime_f%d.png", i];
		NSLog(@"SLIME:[%@]", slime);
		[arrSplatter addObject:[CCSprite spriteWithFile:slime]];
	}
		
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.67f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_finish_splatter.mp3"];
	
	
	float delayTime = 0.0f;
	
	for (int i=0; i<[arrSplatter count]; i++) {
		
		CCSprite *sprite = [arrSplatter objectAtIndex:i];		
		[sprite setPosition:ccp(160, 240)];
		[sprite setScale:0.0f];
		[self addChild:sprite];
		[sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delayTime], [CCScaleTo actionWithDuration:0.15 scale:1 + (CCRANDOM_0_1() * 2)], [CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:0.2f position:ccp((CCRANDOM_0_1() * 320) - 160, (CCRANDOM_0_1() * 480) - 240)] rate:0.5f], nil]];
		delayTime += 0.025f;
	}
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:(CCRANDOM_0_1() * 0.33f) + 0.33f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_light_splat.mp3"];

	
	
	
	[self schedule:@selector(flashBG) interval:0.1];
	[self performSelector:@selector(onResetArea:) withObject:self afterDelay:1];
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
	_isDrawing = NO;
	
	_playerFrameState = 1;
	_playerFrame = 0;
	[_arrActiveFrames dealloc];
	_arrActiveFrames = [[NSArray alloc] initWithObjects:@"player_f7.png", @"player_f8.png", nil];
	
	[_playerFrameTimer invalidate];
	_playerFrameTimer = nil;
	_playerFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(onFrameChange:) userInfo:nil repeats:YES];
	
	//_arrActiveFrames = [_dictPlayerFrames objectForKey:@"stretch"];
	[_fireArrowSprite setRotation:CC_RADIANS_TO_DEGREES(cpvtoangle(cpvsub(vHitCoords, _playerBody.pos)))];
	for (UITouch *touch in touches) {
		
		if (_playerSlideConstraint)
			[_fireArrowSprite setOpacity:255.0f];
		
		[_arrDrawPts addObject:touch];
		[_multiGrab beginLocation:cpvadd(TouchLocation(touch), cpvneg(_ptViewOffset))];
		
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
		[_multiGrab updateLocation:cpvadd(TouchLocation(touch), cpvneg(_ptViewOffset))];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; {
	
	[_arrDrawPts removeAllObjects];
	_isStuck = NO;
	
	[_fireArrowSprite setOpacity:0.0f];
	
	cpVect slope = cpvnormalize(cpvsub(vHitCoords, _playerBody.pos));
	float dist = cpvdist(vHitCoords, _playerBody.pos);
	
	_playerFrameState = 3;
	_playerFrame = 0;
	[_arrActiveFrames dealloc];
	_arrActiveFrames = [[NSArray alloc] initWithObjects:@"player_f10.png", nil];
	
	[_playerFrameTimer invalidate];
	_playerFrameTimer = nil;
	_playerFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(onFrameChange:) userInfo:nil repeats:YES];
	
	//if (slope.x != -1 || slope.x != 1) {
		NSLog(@"PlayScreenLayer.ccTouchesEnded(%f, %f) %f", slope.x, slope.y, dist);
		
		[_playerBody applyImpulse:cpvmult(cpvneg(slope), dist * 80) offset:cpvzero];
		
		if (_playerSlideConstraint) {
			[_space removeConstraint:_playerSlideConstraint];
			_playerSlideConstraint = nil;
		
			if (_playerSpringConstraint) {
				[_space removeConstraint:_playerSpringConstraint];
				_playerSpringConstraint = nil;
			}
		}
	//}
	
	for (UITouch *touch in touches) {
		[_multiGrab endLocation:cpvadd(TouchLocation(touch), cpvneg(_ptViewOffset))];
		int ind = [_blob bodyIndexAt:TouchLocation(touch)];
		
		if (ind % 2 == 0) {
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.25f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_noise-02.mp3"];
		}
		
			
		for (int i=0; i<[arrTouchedEdge count]; i++) {
			if ([[arrTouchedEdge objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"E_%d", ind]])
				[arrTouchedEdge removeObjectAtIndex:i];
		}
		
		[_arrDrawPts removeObject:touch];
	}
}



@end